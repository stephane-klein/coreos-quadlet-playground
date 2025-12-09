#!/usr/bin/env bash

ssh-keygen -R "[127.0.0.1]:2222" >/dev/null 2>&1 || true
ssh -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR stephane@127.0.0.1 -t "cd /mnt/shared && exec bash"
