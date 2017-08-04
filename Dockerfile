FROM anapsix/alpine-java:8_jdk_unlimited as builder

WORKDIR /src

# install maven
RUN wget http://mirrors.ocf.berkeley.edu/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
		&& tar zxvf apache-maven-3.3.9-bin.tar.gz \
		&& rm -f apache-maven-3.3.9-bin.tar.gz 

COPY . ./

# start with spring boot
RUN apache-maven-3.3.9/bin/mvn package


##################
FROM anapsix/alpine-java:8_jdk_unlimited

WORKDIR /app
USER nobody

# install dumb-init; helps dockerized java handle signals properly
# using ADD avoids installing openssl dependency
COPY --from=builder /src/target/glghproxy-0.0.1-SNAPSHOT.war /app/glfhproxy.war

EXPOSE 8080

# start with spring boot
CMD java -jar glfhproxy.war -DgitlabUrl="$GITLAB_URL"
