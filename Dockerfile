# tomcat9 has no jsp loading problem with jdk11
FROM tomcat:9.0.48-jdk11-openjdk-slim

# install vim for edit file if needed
RUN apt-get update
RUN apt-get install vim -y

# set default working directory
WORKDIR /usr/local/tomcat

# copy war file to webapps, use as ROOT.war to remove app name in url
COPY target/external-oidc-provider-0.1.war webapps/ROOT.war

# copy context.xml to tomcat conf folder
COPY script/context.xml /conf/context.xml

# use 8080 8443 port as default port
EXPOSE 8080 8443
