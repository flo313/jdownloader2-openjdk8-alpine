# About
![Jdownloader](http://jdownloader.org/lib/tpl/arctic/images/logo.png)

Jdownloader 2 headless container based on the alpine linux openjdk image

## Parameters
### Volumes
   ```
     /jdownloader/cfg : config folder
     /downloads : download folder
   ```
### Environnment variables
   ```
    USER_UID : User ID who run jdownloader
    USER_NAME : User Name who run jdownloader
   ```

## Instructions
1. First, the container must be run to create the configuration folder tree and files
   ```
    docker run -d --name jd2 \
        -v /path/to/config:/jdownloader/cfg \
			  -v /path/to/download/dir:/downloads \
        -e USER_UID=1500 \
        -e USER_NAME=JdownloaderUser \
        flo313/jdownloader2-openjdk8-alpine
   ```
2. Wait a minute for the container to initialize
3. Stop the container
   ```
    docker stop jd2
   ```
4. On your host, enter your credentials (in quotes) to the file `org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json` as in:
    ```
     { "password" : "mypasswort", "email" : "email@home.org" }
    ```
6.  Start the container:
    ```
     docker start jd2
    ```
