docker build -t base ./imagens/base 
docker build -t wildfly-base ./imagens/wildfly-base/
docker build -t gerencial ./imagens/gerencial/
docker run --rm --name esocial -p 8080:8080 -p 9990:9990 -p 1234:1234 --env-file=env.ini gerencial
