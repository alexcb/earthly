#!/bin/sh
set -e

sudo find / | grep earthly | grep config

configpath="/etc/.earthly/config.yml"

mkdir -p "$(dirname "$configpath")"
cat>"$configpath"<<EOF
global:
  disable_analytics: true
EOF

cat>>"$configpath"<<EOF
  buildkit_additional_config: |
    [registry."docker.io"]
      mirrors = ["registry:5000"]
      http = true
      insecure = true
EOF

echo mirror setup complete
