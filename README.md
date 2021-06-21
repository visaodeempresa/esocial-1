# esocial
Acompanhamento do eSocial.

 Setup Variáveis

## Para uso via Docker
Altere o arquivo **env.ini** com seus dados de conexão e addons. 

```

# Conectividade
CONECTIVIDADE_DS_URL=jdbc:oracle:thin:@db_addr:1521/db_name
CONECTIVIDADE_DS_USERNAME=username
CONECTIVIDADE_DS_PASSWORD=passwod

#IMAGE GERENCIAL

CONECTORES_DS_URL=jdbc:oracle:thin:@db_addr:1521/db_name
CONECTORES_DS_USERNAME=username
CONECTORES_DS_PASSWORD=passwod
CONECTORES_DS_MAX_POOL=5
CONECTORES_DS_MIN_POOL=1
GERENCIAL_DS_URL=jdbc:oracle:thin:@db_addr:1521/db_name
GERENCIAL_DS_USERNAME=username
GERENCIAL_DS_PASSWORD=passwod

#esocial-backend
DB_URL=jdbc:oracle:thin:@db_addr:1521/db_name
DB_USER=username
DB_PASS=passwod

#esocial-frontend
PROFILE=prod
KEYCLOAK_AUTH_SERVER_URL=https://login.tse.jus.br/auth
URL_BACKEND=backend
```

## Para uso via Helm
Altere o arquivo **values.yaml** com seus dados de conexão e configurações do k8s. 

# Rodar Aplicação com Docker Compose

```shell
  docker-compose up -d
```

# Rodar Helm Test

```shell
export ENVIRONMENT=[homologacao|producao]
helm lint -f ./k8s/environment/${ENVIRONMENT}/values.yaml ./k8s/esocial/
```

# Rodar Aplicação com Helm

```shell
  export ENVIRONMENT=[homologacao|producao]
  helm upgrade -i esocial-gerencial -n esocial -f ./k8s/environment/${ENVIRONMENT}/values.yaml ./k8s/esocial/  
```