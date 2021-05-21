#!/bin/bash
# Mais em âmbito da aplicação, as seguintes variáveis de ambiente podem ser
# utilizadas:
#
# - MEMORY_SIZE
# - JBOSS_ADMIN_USER
# - JBOSS_ADMIN_PASS
# - APM_PACKAGES
# - APM_SERVER

CLI="${JBOSS_HOME}/bin/jboss-cli.sh"
CONF="${JBOSS_HOME}/bin/standalone.conf"
STARTCMD="${JBOSS_HOME}/bin/standalone.sh -c standalone-ha.xml"

function add_user() {

    echo "INFO: Adding or enabling \$JBOSS_ADMIN_USER user"
    ${JBOSS_HOME}/bin/add-user.sh -u ${JBOSS_ADMIN_USER:-admin} -p ${JBOSS_ADMIN_PASS:-admin}
}

function set_javaopts() {

    tee -a $CONF <<ADDITIONS

JAVA_OPTS="\$JAVA_OPTS -Xms${MEMORY_SIZE:-1G} -Xmx${MEMORY_SIZE:-1G}"
JAVA_OPTS="\$JAVA_OPTS -Duser.language=pt -Duser.country=BR -Dserver -Duser.timezone=America/Sao_Paulo"

ADDITIONS
}

function set_elastic_apm() {

echo "Configurando APM..."

    tee -a $CONF <<ADDITIONS

# APM configuration
JAVA_OPTS="\$JAVA_OPTS -javaagent:${JBOSS_HOME}/additions/apm-agent/apm-agent.jar"
JAVA_OPTS="\$JAVA_OPTS -Delastic.apm.service_name=${APPLICATION:-unnamed}"
JAVA_OPTS="\$JAVA_OPTS -Delastic.apm.environment=${ENVIRONMENT^^}"
JAVA_OPTS="\$JAVA_OPTS -Delastic.apm.application_packages=br.jus"
JAVA_OPTS="\$JAVA_OPTS -Delastic.apm.server_urls=http://${APM_SERVER:-127.0.0.1}:8200"

ADDITIONS
}


function set_prometheus() {

echo "Configurando Prometheus..."

    tee -a $CONF <<ADDITIONS

# Prometheus configuration
JAVA_OPTS="\$JAVA_OPTS -Xbootclasspath/p:${JBOSS_HOME}/modules/system/layers/base/org/jboss/logmanager/main/jboss-logmanager-2.1.14.Final.jar:${JBOSS_HOME}/modules/system/layers/base/org/wildfly/common/main/wildfly-common-1.5.1.Final.jar"
JAVA_OPTS="\$JAVA_OPTS -Djboss.modules.system.pkgs=org.jboss.byteman,org.jboss.logmanager"
JAVA_OPTS="\$JAVA_OPTS -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
JAVA_OPTS="\$JAVA_OPTS -javaagent:${JBOSS_HOME}/additions/prometheus/jmx-prometheus.jar=1234:${JBOSS_HOME}/additions/prometheus/config.yaml"

# end of additions from entrypoint.sh
ADDITIONS
}

function set_datasources(){
    
    echo "Configurando módulos e datasources, por favor aguardar..."

    bash -c "${STARTCMD} -bmanagement 127.0.0.1 &>/dev/null &"
    timeout=30
    until $($CLI -c "ls /deployment" &>/dev/null); do
        sleep 1
        timeout=$((timeout-1))
        if [ "$timeout" -eq "0" ]; then
            echo "ERROR: Server timed-out when trying to start." >&2
            break
        fi
    done
       
    $CLI -c "/subsystem=datasources/jdbc-driver=oracle:add(driver-name=oracle,driver-module-name=oracle.jdbc.driver)"

    echo "Drives OK"
    $CLI -c "xa-data-source add --name=Gerencial-eSocial-Pool-XA --jndi-name=java:/gerencial/esocial/XA-DS --user-name=${DB_USER_GERENCIAL} --password=${DB_PASS_GERENCIAL} --driver-name=oracle --xa-datasource-properties={"URL"=>"jdbc:oracle:thin:@${DB_HOST_GERAL}:${DB_PORT}:${DB_NAME_GERAL}"}"
    $CLI -c "xa-data-source add --name=Conectividade-eSocial-Pool-XA --jndi-name=java:/conectores/esocial/XA-DS --user-name=${DB_USER_CONECTIVIDADE} --password=${DB_PASS_CONECTIVIDADE} --driver-name=oracle --xa-datasource-properties={"URL"=>"jdbc:oracle:thin:@${DB_HOST_GERAL}:${DB_PORT}:${DB_NAME_GERAL}"}"

    echo "Datasources OK"

    $CLI --connect ":shutdown"

}

function set_deploy(){
    staging=${JBOSS_HOME}/staging
    deployments=${JBOSS_HOME}/standalone/deployments

    for war in $staging/*.war; do
        if [ -f $war ]; then
            mv $war $deployments && \
            touch $deployments/$(basename $war).dodeploy
        fi
    done
}

add_user
set_javaopts
set_datasources

if [ "$ENABLE_APM" = true ] ; then
    set_elastic_apm
fi 

if [ "$ENABLE_PROMETHEUS" = true ] ; then
    set_prometheus
fi 

set_deploy


${JBOSS_HOME}/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -c standalone-ha.xml
