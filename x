#!/bin/bash

#export PBS_REPOSITORY=pbs_client@pbs@pbs.local:mydatastore
export PBS_REPOSITORY=root@pam@PBS01.local:backup-store
export PBS_PASSWORD=7fd32tmas96
export PBS_FINGERPRINT="02:39:10:2d:23:59:5a:29:13:95:43:ad:d9:e7:d2:13:e5:f7:3e:fd:10:2e:38:9b:12:a3:1e:9e:4a:32:de:23"

apt clean cache
cd /usr/local/bin/pbs_backup
./proxmox-backup-client.sh backup root.pxar:/