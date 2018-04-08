#!/bin/sh
set -e

function ts {
  echo "[`date '+%Y-%m-%d %T'`] monitor.sh:"
}

# mkdir /jdownloader
echo "$(ts) Create group ${USER_NAME} (id ${USER_ID}) if needed..."
addgroup -g ${USER_ID} ${USER_NAME} 2>/dev/null
echo "$(ts) Create user ${USER_NAME} (id ${USER_ID}) if needed..."
adduser -D -u ${USER_ID} -G ${USER_NAME} -s /bin/sh -h /jdownloader ${USER_NAME} 2>/dev/null

# Set directory permissions.
echo "$(ts) Set user ${USER_NAME} (id ${USER_ID}) owner of /jdownloader and /downloads..."
chown -R ${USER_NAME}:${USER_NAME} /jdownloader /downloads
echo "$(ts) Set permissions of /downloads to 755..."
chmod -R u+rwx /downloads

# Finally, start JDownloader.
echo "$(ts) Starting JDownloader..."
exec su -pc "exec java -Djava.awt.headless=true -jar /jdownloader/JDownloader.jar 2>&1 >/dev/null" $USER_NAME &
# exec su -pc "exec java -Djava.awt.headless=true -jar /jdownloader/JDownloader.jar 2>&1 >/dev/null" $USER_NAME
while sleep 3600; do :; done
