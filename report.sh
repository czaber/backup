#!/bin/bash
# Najlepiej dodać do cron:
# Wpisy w cronie:
# 0 6    * * 7 /root/bin/report.sh

LSOPT='-1st --si'

echo "Stan dysku"
echo "=========="

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
