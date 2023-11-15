# tomcat에서 제공하는 tomcat 8.5ver + java jre8인 이미지 가져옴
FROM tomcat:8.5-jre8

# 톰캣 타임존 설정
RUN ["rm", "/etc/localtime"]
RUN ["ln", "-sf", "/usr/share/zoneinfo/Asia/Seoul", "/etc/localtime"]

COPY setenv.sh /usr/local/tomcat/bin


#추후 간단한 파일 편집을 위해 컨테이너 내부에 vim 설치
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "vim", "-y"]

#컨테이너 내부에 필요한 파일을 복사한다. 예를들어 war, 위 타임존 세팅할 때 사용할 setenv.sh 파일
#COPY {복사할 파일} {복사하여 붙여넣을 컨테이너 내 위치}
COPY target/external-oidc-provider-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps

# 컨테이너 외부에서 사용하는 포트 지정
EXPOSE 8081

#start tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]