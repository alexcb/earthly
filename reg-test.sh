#!/bin/sh
set -e

sudo find / | grep earthly | grep config

configpath="$HOME/.earthly/config.yml"

mkdir -p "$(dirname "$configpath")"
cat>"$configpath"<<EOF
global:
  disable_analytics: true
EOF

registryip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' registry)"
test -n "$registryip"

cat>>"$configpath"<<EOF
  buildkit_additional_config: |
    [registry."docker.io"]
      mirrors = ["http://$registryip:5000"]
      http = true
      insecure = true
EOF

echo mirror setup complete
cat "$configpath"
