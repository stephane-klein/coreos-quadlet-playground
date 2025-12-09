#!/usr/bin/env bash

cat <<'EOF'
Before running the playground, I make sure the environment is clean and contains no quadlets to start from scratch.
To do this, I execute:

```
stephane@stephane-coreos:/mnt/shared$ podman quadlet rm -a -f
stephane@stephane-coreos:/mnt/shared$ sudo journalctl --user --rotate
stephane@stephane-coreos:/mnt/shared$ sudo journalctl --user --vacuum-time=1s
EOF
podman quadlet rm -a -f
sudo journalctl --user --rotate
sudo journalctl --user --vacuum-time=1s

cat <<'EOF'
```

The playground really starts here.
I begin by installing the quadlet files present in `./quadlets`:

```sh
stephane@stephane-coreos:/mnt/shared$ podman quadlet install ./quadlets/
EOF
podman quadlet install ./quadlets/

cat <<'EOF'
```

This `podman` command generates the following Systemd units:

```
stephane@stephane-coreos:/mnt/shared$ ls -1 /run/user/1001/systemd/generator/
EOF
ls -1 /run/user/1001/systemd/generator/

cat <<'EOF'
```

I can see that a systemd unit `postgresql.service` is created but not started:

```
stephane@stephane-coreos:/mnt/shared$ systemctl --user status postgresql.service
EOF
systemctl --user status postgresql.service

cat <<'EOF'
```

I start the services:

```
stephane@stephane-coreos:/mnt/shared$ systemctl --user start postgresql.service
stephane@stephane-coreos:/mnt/shared$ systemctl --user start adminer.service
EOF
systemctl --user start postgresql.service
systemctl --user start adminer.service

cat <<'EOF'
```

Wait container image pulling and starting...

```
stephane@stephane-coreos:/mnt/shared$ podman ps
EOF

podman ps

cat <<'EOF'
```

✅ Adminer is accessible from the host at:
http://localhost:8080/?pgsql=systemd-postgresql&username=postgres&db=postgres

Password: password
EOF
