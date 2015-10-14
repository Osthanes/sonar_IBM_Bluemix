#!/bin/bash
apt-get update
apt-get upgrade


export TEST_HOST=`hostname`
export TEST_IP=`ip addr show | grep "\<172\." | awk '{print $2}' | awk -F "/" '{print $1}'`
echo -e "$TEST_IP    $TEST_HOST" >>/etc/hosts

set -e

if [ "${1:0:1}" != '-' ]; then
	exec "$@"
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="-Djava.security.egd=file:/dev/./urandom" \
	"$@"