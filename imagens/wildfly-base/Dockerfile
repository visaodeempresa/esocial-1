FROM base AS source

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 18.0.0.Final
ENV WILDFLY_SHA1 2d4778b14fda6257458a26943ea82988e3ae6a66

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \    
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION/* $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME} \
    && rm -rf $JBOSS_HOME/welcome-content/*

FROM base

USER jboss

WORKDIR ${JBOSS_HOME}

COPY --chown=jboss --from=source ${JBOSS_HOME} ${JBOSS_HOME}
COPY --chown=jboss misc/extras/             .
COPY --chown=jboss misc/entrypoint.sh       .
RUN chmod +x entrypoint.sh

# Expose the ports we're interested in
EXPOSE 8080 9404

ENTRYPOINT ["./entrypoint.sh"]