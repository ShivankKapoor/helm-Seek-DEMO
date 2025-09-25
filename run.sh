#!/bin/bash
./stop.sh
podman build -t helmseek-demo .
podman run -d --name helmseek-demo -p 3003:80 helmseek-demo
echo "helmseek-demo app built and running on port 3003"