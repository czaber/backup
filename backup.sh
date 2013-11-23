#!/bin/bash
# Najlepiej dodać do cron:
# Wpisy w cronie:
# 20 4    * * * /root/bin/backup.sh daily 7
# 30 4    * * 7 /root/bin/backup.sh weekly 40
# 40 4    1 * * /root/bin/backup.sh monthly 730

if [ "$1" = "" ] ; then
        echo "Użycie: "
        echo "$0 PERIOD DAYS";
        exit 1
fi

if [ "$2" = "" ] ; then
        echo "Użycie: "
        echo "$0 PERIOD DAYS";
        exit 1
fi

PERIOD=$1
PERIOD_DAYS=$2

# 1. zmienne
BASEDIR='/backup'
FULLDIR="${BASEDIR}/${PERIOD}"
DATE=`date +%Y%m%d%H%M%S`

R="--exclude home/redmine/redmine/tmp"
G="--exclude home/git/gitlab/tmp"
TAROPT="-pczf"
RSYNCOPT="-az -H --delete"
DUMPOPT="--defaults-extra-file=/root/etc/backup.cnf"
ROOTDUMPOPT="--defaults-extra-file=/root/etc/root.cnf --ignore-table=mysql.event"

# 2. katalogi robocze
mkdir -p "$FULLDIR"

# 3. backup
cd $FULLDIR

tar    $TAROPT ${DATE}_owncloud.tgz -C / home/owncloud
tar $R $TAROPT ${DATE}_redmine.tgz -C / home/redmine
tar $G $TAROPT ${DATE}_gitlab.tgz -C / home/git
tar    $TAROPT ${DATE}_root.tgz  -C / root
tar    $TAROPT ${DATE}_etc.tgz  -C / etc

mysqldump $DUMPOPT -u owncloud owncloud_production | gzip > ${DATE}_owncloud.sql.gz
mysqldump $DUMPOPT -u gitlab   gitlabhq_production | gzip > ${DATE}_gitlab.sql.gz
mysqldump $DUMPOPT -u redmine  redmine_production  | gzip > ${DATE}_redmine.sql.gz
mysqldump $ROOTDUMPOPT -u root mysql | gzip > ${DATE}_backup.sql.gz

dpkg --get-selections > ./${DATE}_installed-packages

# 4. uprawnienia
chmod 640 ${DATE}_*.*

# 5. kopia na serwerze zewnętrznym
#rsync $RSYNCOPT -e ssh $FULLDIR/${DATE}_* 

# 6. usuwamy stare pliki backupow, ktore maja wiecej dni niz podany argument
for i in `find  $FULLDIR -name "*.*gz" -atime +$PERIOD_DAYS`; do
  echo "Usuwam $i"
  rm $i
done
