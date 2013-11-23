#!/bin/bash
# Najlepiej dodać do cron:
# Wpisy w cronie:
# 0 6    * * 7 /root/bin/report.sh

LSOPT='-1st --si'

echo "Stan dysku"
echo "=========="
df -H -x tmpfs -x devtmpfs
echo "..."
echo "S.M.A.R.T /dev/sda"
smartctl -l selftest /dev/sda | grep '#'
echo "S.M.A.R.T /dev/sdb"
smartctl -l selftest /dev/sdb | grep '#'
echo "S.M.A.R.T /dev/sdc"
smartctl -l selftest /dev/sdc | grep '#'
echo "...\n"

echo "Dzienne kopie"
echo "============="
ls $LSOPT /backup/daily/ | head -n 72 # 7 x 10 files per day + 1 header line + 1 extra file
echo "...\n"

echo "Tygodniowe kopie"
echo "================"
ls $LSOPT /backup/weekly/ | head -n 42 # 4 x 10 files per day + 1 header line + 1 extra file
echo "...\n"

echo "Miesięczne kopie"
echo "================"
ls $LSOPT /backup/monthly/ | head -n 22 # 2 x 10 files per day + 1 header line + 1 extra file
echo "...\n"
