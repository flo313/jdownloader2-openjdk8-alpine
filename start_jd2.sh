#!/bin/sh
function ts {
  echo "[`date '+%Y-%m-%d %T'`] `basename "$(test -L "$0" && readlink "$0" || echo "$0")"`:"
}
echo "*****************************************************************************************************"
echo "$(ts) Start Script"
echo ""
# mkdir /jdownloader
echo "$(ts) Create group ${USER_NAME} (id ${USER_ID}) if needed..."
cat /etc/group | grep ${USER_NAME} >/dev/null 2>&1
if [ $? = 1 ] ; then
   addgroup -g ${USER_ID} ${USER_NAME} 2>/dev/null
fi
echo "$(ts) Create user ${USER_NAME} (id ${USER_ID}) if needed..."
cat /etc/passwd | grep ${USER_NAME} >/dev/null 2>&1
if [ $? = 1 ] ; then
    adduser -D -u ${USER_ID} -G ${USER_NAME} -s /bin/sh -h /jdownloader ${USER_NAME} 2>/dev/null
fi

echo "$(ts) Set user ${USER_NAME} (id ${USER_ID}) owner of /jdownloader..."
chown -R ${USER_NAME}:${USER_NAME} /jdownloader
echo "$(ts) Set access for ${USER_NAME} (id ${USER_ID}) on /jdownloader..."
chmod -R +rwx /jdownloader

echo "$(ts) Check user write access on folders (user: ${USER_NAME} id ${USER_ID})"
for dir in /downloads /jdownloader ; do
  echo "$(ts)    Check $dir..."
  if sudo su - $USER_NAME -c "[ -w $dir ]" ; then 
    echo "$(ts)    Write access to $dir -> OK"
  else
    echo "$(ts)    /!\ Write access to $dir /!\ -> KO"
    echo "$(ts)    Exiting script..."
    exit
  fi
done 

# Finally, start JDownloader.
echo "$(ts) Starting JDownloader..."
#exec su -pc "exec java -Djava.awt.headless=true -jar /jdownloader/JDownloader.jar 2>&1 >/dev/null" $USER_NAME
if [ -f "$JDJARFULLNAME" ]; then
    echo "$(ts) ${JDJARFULLNAME} already exist"
else
    wget -O $JDJARFULLNAME http://installer.jdownloader.org/JDownloader.jar
fi
chmod +x $JDJARFULLNAME
exec su -pc "exec java -Djava.awt.headless=true -jar $JDJARFULLNAME" $USER_NAME

#while sleep 3600; do :; done
