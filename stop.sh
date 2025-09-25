#!/bin/bash

if podman stop helmseek-demo 2>/dev/null; then
  echo "Stopped container: helmseek-demo"
else
  echo "Container 'helmseek-demo' was not running"
fi

if podman rm helmseek-demo 2>/dev/null; then
  echo "Removed container: helmseek-demo"
else
  echo "Container 'helmseek-demo' did not exist or was already removed"
fi