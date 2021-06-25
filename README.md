# esocial
Acompanhamento do eSocial.

## Configuração dos Repositórios

É nessário adiconar o repositório do TSE como insecure-registries em cada um dos nodes que a aplicação irá rodar.

```shell

#para RedHat-like
/etc/docker/daemon.json
{
  "insecure-registries": ["registry.tse.jus.br:5000"]
}

```
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