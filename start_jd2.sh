#!/bin/sh
set -e

function ts {
  echo "[`date '+%Y-%m-%d %T'`] monitor.sh:"
}

# Display settings on standard out.

#USER_NAME="jdownloader"
echo "$(ts) ===================="
echo "$(ts) JDownloader settings"
echo "$(ts) ===================="
echo
echo "$(ts)   User:      ${USER_NAME}"
echo "$(ts)   UID:       ${USER_UID}"
echo


# mkdir /jdownloader
echo "$(ts) Create group if needed..."
addgroup -g ${USER_UID} ${USER_NAME} 2>/dev/null
echo "$(ts) [DONE]"
echo "$(ts) Create user if needed..."
adduser -D -u ${USER_UID} -G ${USER_NAME} -s /bin/sh -h /jdownloader ${USER_NAME} 2>/dev/null
echo "$(ts) [DONE]"

# Set directory permissions.
echo "$(ts) Setting permissions... "
chown -R ${USER_NAME}: /jdownloader /downloads
chmod -R 755 /downloads
# chown ${USER_NAME}: /media
# chmod a+wx /jdownloader/JDownloader.jar
echo "$(ts) [DONE]"

# Finally, start JDownloader.
echo "$(ts) Starting JDownloader..."
exec su -pc "exec java -Djava.awt.headless=true -jar /jdownloader/JDownloader.jar 2>&1 >/dev/null" $USER_NAME &
# exec su -pc "exec java -Djava.awt.headless=true -jar /jdownloader/JDownloader.jar 2>&1 >/dev/null" $USER_NAME
while sleep 3600; do :; done
