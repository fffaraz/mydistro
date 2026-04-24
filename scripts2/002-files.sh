#!/bin/bash
set -exuo pipefail

ln -sv /proc/self/mounts /etc/mtab

cp ./assets/etc/hosts /etc/hosts
cp ./assets/etc/passwd /etc/passwd
cp ./assets/etc/group /etc/group

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
