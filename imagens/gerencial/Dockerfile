FROM jboss/wildfly

LABEL maintainer="Justiça Eleitoral do Brasil"
LABEL version="0.0.1"

ENV DB_HOST_GERAL        = 'host geral'
ENV DB_NAME_GERAL        = 'Nome do banco de dados'

ENV DB_USER_GERENCIAL     = 'gerencial'
ENV DB_PASS_GERENCIAL     = 'gerencial_pass'

ENV DB_USER_CONECTIVIDADE = 'conectividade'
ENV DB_PASS_CONECTIVIDADE = 'conectividade_pass'


RUN /bin/sh -c '$JBOSS_HOME/bin/standalone.sh &' && \
  sleep 10 && \
  cd /tmp && curl --location --output ojdbc8-12.2.0.1.jar --url https://maven.xwiki.org/externals/com/oracle/jdbc/ojdbc8/12.2.0.1/ojdbc8-12.2.0.1.jar && \
  $JBOSS_HOME/bin/jboss-cli.sh --connect --command="deploy /tmp/ojdbc8-12.2.0.1.jar" && \
  $JBOSS_HOME/bin/jboss-cli.sh --connect --command="xa-data-source add --name=campstur --jndi-name=java:/jdbc/datasources/campsturDS --user-name=${DB_USER_GERENCIAL} --password=${DB_PASS_GERENCIAL} --driver-name=postgresql-9.4-1201-jdbc41.jar --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=ServerName=${DB_HOST_GERAL},PortNumber=5432,DatabaseName=${DB_NAME_GERAL} --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter" && \
  $JBOSS_HOME/bin/jboss-cli.sh --connect --command="xa-data-source add --name=campstur --jndi-name=java:/jdbc/datasources/campsturDS --user-name=${DB_USER_CONECTIVIDADE} --password=${DB_PASS_CONECTIVIDADE} --driver-name=postgresql-9.4-1201-jdbc41.jar --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=ServerName=${DB_HOST_GERAL},PortNumber=5432,DatabaseName=${DB_NAME_GERAL} --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter" && \
  $JBOSS_HOME/bin/jboss-cli.sh --connect --command=:shutdown && \
  rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history/ $JBOSS_HOME/standalone/log/* && \
  rm /tmp/ojdbc8-*.jar && \
  rm -rf /tmp/ojdbc8-*.jar
