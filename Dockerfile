FROM openjdk:8-alpine

ENV USER_ID="1000" \
    USER_NAME="jd2" \
    JDDIR="/jdownloader"
ENV JDJARFULLNAME="$JDDIR/JDownloader.jar"

RUN \
# Update Bash and add su-exec and wget
	apk add --no-cache bash sudo su-exec wget \
	
# Download Jdownloader
	&& mkdir $JDDIR \
	&& wget -O $JDJARFULLNAME --progress=bar:force http://installer.jdownloader.org/JDownloader.jar \
	&& java -Djava.awt.headless=true -jar $JDJARFULLNAME -update -norestart \
	
# Cleaning
	&& apk del wget \
	&& rm -rf /tmp/* /var/cache/apk/* /var/lib/apk/lists/*

ADD start_jd2.sh /start_jd2.sh

# Configure starter script
RUN	chmod +x /start_jd2.sh

VOLUME /jdownloader/cfg


HEALTHCHECK --interval=5m --timeout=3s CMD jps -l | grep "${JDJARFULLNAME}" >/dev/null || exit 1

CMD ["/start_jd2.sh"]
