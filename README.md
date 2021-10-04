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

# Docker

### Para uso via Docker
Altere o arquivo **env.ini** com seus dados de conexão e addons. 

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

# Kubernetes
## Usando namespaces para criar ambientes de produção e homologação
O kubernetes tem o conceito de namespaces, que permitem agrupar recursos (pods, secrets, configmaps, etc) logicamente. Namespaces podem ser criados para emular ambientes, por exemplo:
```shell
kubectl create namespace esocial-homologacao
kubectl create namespace esocial-producao
```
A criação dos namespaces só é necessária uma única vez.

## Helm

### Para uso via Helm
Altere o arquivo **./k8s/environment/{homologacao|producao}/values.yaml** com seus dados de conexão e configurações do k8s. 

### Rodar Helm Test

```shell
export ENVIRONMENT=[homologacao|producao]
helm lint -f ./k8s/environment/${ENVIRONMENT}/values.yaml ./k8s/esocial/
```
### Criação do certificado via secret (Quando diponível)

```shell
  export ENVIRONMENT=[homologacao|producao]
  kubectl -n esocial-${ENVIRONMENT} create secret generic cert-secret --from-file ./k8s/environment/${ENVIRONMENT}/project.ini  
```
* Manter o nome certificado **project.ini**. A aplicaçã
o espera por esse nome.
* Atualizar o arquivo **values.yaml** com os valores correpondentes:

```yaml
certificate:
    enabled: true
    secret_name: cert-secret
    cert_path: /opt/appsrv/esocial/tse/
```

### Instalar ou Atualizar via Helm

```shell
  export ENVIRONMENT=[homologacao|producao]  
  helm upgrade -i esocial-${ENVIRONMENT} -n esocial-${ENVIRONMENT} -f ./k8s/environment/${ENVIRONMENT}/values.yaml ./k8s/esocial/
```

### OPCIONAL: "Amarrando" os namespaces automaticamente em nodes específicos
Para que essas configurações desse tópico funcionem, o seu cluster kubernetes tem que suportar o admission plugin `PodNodeSelector`. Para verificar, execute o seguinte comando em um node master:
```shell
docker inspect kube-apiserver |  grep enable-admission-plugins
```
O passo a passo de como habilitar esse plugin foge do escopo desse documento.

Em um cluster kubernetes, é possível usar labels nos nodes, com o objetivo de identificar/rotular os nodes com propósitos específicos. Por exemplo, é possível ter nodes mais robustos (mais cpu e memória) com o label `infra=prod` e nodes menos robustos com label `infra=hmg`. Para adicionar um label é um node:
```shell
kubectl label nodes <nome_do_node> <chave>=<valor>
```

Exemplo real:
```shell
kubectl label nodes k8s-worker1 infra=prod
kubectl label nodes k8s-worker2 infra=prod
kubectl label nodes k8s-worker3 infra=prod
```

Existe uma funcionalidade, pouco documentada na documentação do kubernetes, que permite adicionar uma annotation específica em um namespace, de modo que os pods deployados nesse namespace fiquem automaticamente atrelados a nodes com um derminado label. Essa annotation é `scheduler.alpha.kubernetes.io/node-selector: <chave>=<valor>`, onde `<chave>=<valor>` é o label dos nodes escolhidos. Um exemplo concreto, adicionando a annotation nos namespaces `esocial-producao` e `esocial-homologacao`:

Exemplo real:
```shell
kubectl annotate namespaces esocial-producao scheduler.alpha.kubernetes.io/node-selector=infra=prod
kubectl annotate namespaces esocial-homologacao scheduler.alpha.kubernetes.io/node-selector=infra=hmg
```
Essa configuração só precisa ser feita uma vez.


```sequence
Alice->Bob: Hello Bob, how are you?
Note right of Bob: Bob thinks
Bob-->Alice: I am good thanks!
```

