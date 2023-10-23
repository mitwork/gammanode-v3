FROM openjdk:20-jdk-slim-buster

EXPOSE 14589

######### TUMAR
# Install
ADD lib/TumarCSP_5.2_linux64.tgz /opt
WORKDIR /opt/TumarCSP5.2
RUN ./setup_csp.sh install
WORKDIR /opt
# https://unix.stackexchange.com/questions/195975/cannot-force-remove-directory-in-docker-build
# https://github.com/moby/moby/issues/783
RUN find /opt/TumarCSP5.2 -type f | xargs -L1 rm -f

# Links to shared objects
RUN ln -s /lib64/libcptumar.so.4.0 /lib64/libcptumar.so
RUN ln -s /lib64/libcptumar_r.so.4.0 /lib64/libcptumar_r.so

RUN update-ca-certificates

WORKDIR /app
ARG artifact=build/libs/GammaNode.jar
COPY $artifact /app/GammaNode.jar
RUN mkdir /app/cache
VOLUME /app/cache
ENTRYPOINT ["java", "-jar", "GammaNode.jar"]
HEALTHCHECK --interval=20s --timeout=30s --retries=7 \
    CMD wget -O - http://127.0.0.1:14589/actuator/health | grep -v DOWN || exit 1
