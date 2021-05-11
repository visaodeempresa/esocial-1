# esocial
Acompanhamento do eSocial.

# Criação das imagens

```shell
 docker build -t base ./imagens/base 
 docker build -t wildfly-base ./imagens/wildfly-base/
 docker build -t gerencial ./imagens/gerencial/
```

# Setup Variáveis

Altere o arquivo **env** com seus dados de conexão e addons. 

```
# - MEMORY_SIZE
# - JBOSS_ADMIN_USER
# - JBOSS_ADMIN_PASS
# - APM_PACKAGES
# - APM_SERVER
# - ENABLE_PROMETHEUS
# - ENABLE_APM
# - DB_HOST_GERAL
# - DB_PORT
# - DB_NAME_GERAL
# - DB_USER_GERENCIAL
# - DB_PASS_GERENCIAL
# - DB_USER_CONECTIVIDADE
# - DB_PASS_CONECTIVIDADE
```


# Rodar Aplicação

```shell
  docker run --rm --name esocial -p 8080:8080 -p 9990:9990 -p 1234:1234 --env-file=env.ini gerencial
```

# Acessando

```shell
# Metricas do Prometheus
http://127.0.0.1:1234/

# Console de Administração
http://127.0.0.1:9990/

# Aplicação de teste
http://127.0.0.1:8080/app/
```
