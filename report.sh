#!/bin/bash
# Najlepiej dodać do cron:
# Wpisy w cronie:
# 0 6    * * 7 /root/bin/report.sh

LSOPT='-1st --si'
SMARTCTL=/usr/sbin/smartctl

echo "Stan dysku"
echo "=========="
df -H -x tmpfs -x devtmpfs
echo "..."
echo "S.M.A.R.T /dev/sda"
$SMARTCTL -l selftest /dev/sda | grep '#'
echo "S.M.A.R.T /dev/sdb"
$SMARTCTL -l selftest /dev/sdb | grep '#'
echo "S.M.A.R.T /dev/sdc"
$SMARTCTL -l selftest /dev/sdc | grep '#'
echo -e "...\n"

echo "Dzienne kopie"
echo "============="
ls $LSOPT /backup/daily/ | head -n 72 # 7 x 10 files per day + 1 header line + 1 extra file
echo -e "...\n"

echo "Tygodniowe kopie"
echo "================"
ls $LSOPT /backup/weekly/ | head -n 42 # 4 x 10 files per day + 1 header line + 1 extra file
echo -e "...\n"

echo "Miesięczne kopie"
echo "================"
ls $LSOPT /backup/monthly/ | head -n 22 # 2 x 10 files per day + 1 header line + 1 extra file
echo -e "...\n"
