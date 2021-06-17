# esocial
Acompanhamento do eSocial.

# Criação das imagens

```shell
 docker build -t base ./imagens/base 
 docker build -t wildfly-base ./imagens/wildfly-base/
 docker build -t gerencial ./imagens/gerencial/
```

# Setup Variáveis

## Para uso via Docker
Altere o arquivo **env.ini** com seus dados de conexão e addons. 

```
# - MEMORY_SIZE
# - JBOSS_ADMIN_USER
# - JBOSS_ADMIN_PASS
# - APM_PACKAGES
# - APM_SERVER
# - ENABLE_PROMETHEUS
# - ENABLE_APM
# - ENVIRONMENT
# - APPLICATION
# - DB_HOST_GERAL
# - DB_PORT
# - DB_NAME_GERAL
# - DB_USER_GERENCIAL
# - DB_PASS_GERENCIAL
# - DB_USER_CONECTIVIDADE
# - DB_PASS_CONECTIVIDADE
```

## Para uso via Helm
Altere o arquivo **values.yaml** com seus dados de conexão e configurações do k8s. 

```
gerencial:
  replicaCount: 1
  image:
    repository: gerencial
    tag: latest
  imagePullSecrets: []
  #    - name: registry
  service:
    type: ClusterIP
  ingress:
    enabled: false
    tls: false
    host: gerencial.tre-xx.gov.br
  resources: {}
    # limits:
    #   cpu: 1000m
    #   memory: 512Mi
    # requests:
    #   cpu: 1000m
    #   memory: 512Mi
  autoscaling:
    enabled: false
  envs:
    DB_HOST_GERAL: 10.x.x.x
    DB_PORT: 1521
    DB_NAME_GERAL: nome_do_banco_de_dados
    DB_USER_GERENCIAL: gerencial
    DB_PASS_GERENCIAL: gerencial_pass
    DB_USER_CONECTIVIDADE: conectividade
    DB_PASS_CONECTIVIDADE: conectividade_pass
    # Wildfly Options
    ENABLE_PROMETHEUS: false
    ENABLE_APM: false
    MEMORY_SIZE: 512M
    JBOSS_ADMIN_USER: admin
    JBOSS_ADMIN_PASS: admin1
```

# Rodar Aplicação com Docker

```shell
  docker run --rm --name esocial -p 8080:8080 -p 9990:9990 -p 1234:1234 --env-file=env.ini gerencial
```

# Rodar Aplicação com Helm

```shell
  helm install eSocial -f ./values.yaml ./esocial/ 
```

# Acessando via Docker

```shell
# Metricas do Prometheus
http://127.0.0.1:1234/

# Console de Administração
http://127.0.0.1:9990/

# Aplicação de teste
http://127.0.0.1:8080/app/
```
