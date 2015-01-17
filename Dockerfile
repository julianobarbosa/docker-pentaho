FROM ubuntu:14.04

MAINTAINER Sharoon Thomas

ENV PENTAHO_HOME /pentaho
RUN mkdir -p $PENTAHO_HOME

# Install all required dep
RUN apt-get update
RUN apt-get install -y wget unzip git postgresql-client-9.3 zip openjdk-7-jdk python-setuptools fabric

# Set java home
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre/
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre/

# Replace this with download from
# http://ufpr.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/5.2/biserver-ce-5.2.0.0-209.zip
ADD biserver-ce.zip /downloads/biserver-ce.zip

# Unzip the file
RUN unzip -q /downloads/biserver-ce.zip -d  $PENTAHO_HOME

# Remove the user prompt
RUN rm $PENTAHO_HOME/biserver-ce/promptuser.sh

# Make the server run as a foreground process
RUN sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/biserver-ce/tomcat/bin/startup.sh

# Clean up
RUN rm /downloads/biserver-ce.zip

# Set workdir
WORKDIR /pentaho/

# Add the fabfile for the ops
ADD data /pentaho/data
ADD fabfile.py /pentaho/fabfile.py

ENTRYPOINT ["fab"]
CMD ["run"]

ENTRYPOINT ["sh"]
CMD ["-c", "bash"]