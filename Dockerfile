FROM openjdk:8-alpine

ENV USER_ID="1000" \
    USER_NAME="jd2"

 ADD start_jd2.sh /start_jd2.sh

RUN \
# Update Bash and add su-exec and wget
	apk add --no-cache bash su-exec wget \
	
# Download Jdownloader
	&& mkdir /jdownloader \
	&& wget -O /jdownloader/JDownloader.jar --progress=bar:force http://installer.jdownloader.org/JDownloader.jar \
	&& java -Djava.awt.headless=true -jar /jdownloader/JDownloader.jar \
	
# Cleaning
	&& apk del wget \
	&& rm -rf /tmp/* /var/cache/apk/* /var/lib/apk/lists/* \

# Configure starter script
	&& chmod +x /start_jd2.sh

VOLUME /jdownloader/cfg

CMD ["/start_jd2.sh"]
