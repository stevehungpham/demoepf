FROM openshift/base-centos7

ENV MULE_HOME /opt/mule
ENV MULE_VERSION 3.7.3

EXPOSE 8080

# Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Mule ESB EE Applications" \
      io.k8s.display-name="Mule ESB 3.7.3 Enterprise" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,mule,3.x,java"

# we need some tools from yum
# and install mule ee standalone
RUN yum update -y \
    && yum install -y java-1.8.0-openjdk-devel maven zip \
    && yum clean all -y \
    && cd /opt \
    && curl -o mule.tar.gz https://s3.amazonaws.com/MuleEE/fe49c9b102bcce22304d198936ea663f/mule-ee-distribution-standalone-3.7.3.tar.gz \
    && tar -xf mule.tar.gz \
    && mv mule-enterprise-standalone-$MULE_VERSION mule \
    && rm mule.tar.gz*

# Copy configuration files
COPY ./conf/* $MULE_HOME/conf/

# Installing license file
COPY ./license/license.lic $MULE_HOME/license.lic
RUN $MULE_HOME/bin/mule -installLicense $MULE_HOME/license.lic

# Copy application files
COPY ./target/*.zip $MULE_HOME/apps/

# run as non-root user
RUN chown -R 1001:0 $MULE_HOME && \
    chmod -R g+wrx $MULE_HOME

# Openshift runtime user
USER 1001

# engage
CMD exec $MULE_HOME/bin/mule $MULE_OPTS_APPEND
