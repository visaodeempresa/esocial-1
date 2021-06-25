# esocial
Acompanhamento do eSocial.

## Para uso via Docker
Altere o arquivo **env.ini** com seus dados de conexão e addons. 

## Para uso via Helm
Altere o arquivo **./k8s/environment/{homologacao|producao}/values.yaml** com seus dados de conexão e configurações do k8s. 

# Docker
### Rodar Aplicação com Docker Compose

```shell
  docker-compose up -d
```

### Listar Containers em execução
```shell
  docker-compose ps
```

### Checar logs
```shell
  docker-compose logs
```

### Parar Aplicação
```shell
  docker-compose down
```

# Kuberentes
## Rodar Helm Test

```shell
export ENVIRONMENT=[homologacao|producao]
helm lint -f ./k8s/environment/${ENVIRONMENT}/values.yaml ./k8s/esocial/
```

# Rodar Aplicação com Helm

```shell
  export ENVIRONMENT=[homologacao|producao]
  kubectl create secret generic cert-secret --from-file ./k8s/environment/${ENVIRONMENT}/project.ini
  helm upgrade -i esocial-gerencial -n esocial -f ./k8s/environment/${ENVIRONMENT}/values.yaml ./k8s/esocial/  
```