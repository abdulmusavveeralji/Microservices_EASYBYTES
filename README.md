# MICROSERVICES
- Accounts Service : 8080
- Loan Service : 8090
- Cards Service : 9000
  - H2 in memory database is added, and schema is auto generated using `schema.sql` file
  - h2 database will be directly hosted in this endppoint during runtime `/h2-console`
  - Global exception handler supported
  - Audit Aware integrated, for generating audit for each operation.
- ConfigServer : 8071
- Eureka Server : 8070
  - Service registry and discovery, Eureka server will discover all the microservices, and those microservices should have eureka client integrated.

### Account Service Endpoints
```text
POST: http://locahost:8080/api/create
GET: http://locahost:8080/api/fetch?mobileNumber=1234567890
UPDATE: http://locahost:8080/api/update
DELETE: http://locahost:8080/api/delete?mobileNumber=1234567890

SWAGGER UI:
http://locahost:8080/swagger-ui.html
```


# Section 4
To build a project run below command, which will generate a jar file for deployment. **make sure you dont get any errors why building your project.**

```bash
mvn clean install
```
To run the build you have created in the terminal:
```bash
# Run thru Maven
mvn spring-boot:run

#Or Java
java -jar target/accounts-0.0.1-SNAPSHOT.jar
```

## Docker and Containerization
### 1 Docker Approach
***Step 1***: Create a docker file
1. Create a Dockerfile in each service
2. use base image
3. copy jar file to that base image
4. run your spring boot application in container
   <br>[Here is the example of Dockerfile](accounts/Dockerfile)

***Step 2***: Build docker file
```bash
docker build . -t abdulmusavveeralji/accounts:s4
```

### 2 Build-pack Docker Approach
### 3 Generate Docker image using google jib (Recommended)
After adding JIB plugin to your pom.xml file, run below command to build a docker image of this microservice.
this will create a very lightweight image compare to other 2 approaches, so this one is recommended.

```bash
# Build Spring Boot image using Jib
mvn compile jib:dockerBuild

# Build Spring Boot image without storing locally using jib and push directly to remote
mvn compile jib:build
```

for `build` command, refer the official document. which explain how to push to different platforms (aws or dockerhub)

<br>
To push image to docker.io, take help of google!


Docker commands
```bash
# Inspect an image
docker image inspect <image_name>

# List images
docker images

# List running containers
docker ps

# List all containers (running + stopped)
docker ps -a

# Remove an image
docker rmi <image_name>

# Remove a container
docker rm <container_id>

# Run a container interactively
docker run -it <image_name>

# Run a container and map ports
docker run -p 8080:8080 <image_name>

# Docker Compose
docker compose up

# Docker Compose in detached mode
docker compose up -d

# Stop and remove containers, networks
docker compose down
```

Additional useful commands

```bash
# View container logs
docker logs <container_id>

# Follow logs
docker logs -f <container_id>

# Execute a shell inside a running container
docker exec -it <container_id> /bin/bash

# Build an image
docker build -t my-app .

# Pull an image
docker pull nginx

# Start a container
docker start <container_id>

# Stop a container
docker stop <container_id>

# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Build Spring Boot image using Jib
mvn compile jib:dockerBuild

# View image layers
docker history <image_name>

# Tag image
docker tag my-app:latest username/my-app:v1

# Push image
docker push username/my-app:v1
```


# Spring Cloud
- **Spring Cloud Config (Configuration Service/Server)**: 
  - This is a centralized configuration service, which holds the credential or configuration service of the microservices
  - easy to configure, create a config folder in resource and add properties files of each services,
  - Mandatory to enable `@EnableConfigServer` in main
  - we can remove the copied information from their respective microservices, ex. application-prod and -qa in accounts service is no longer needed.
  - To validate configs for each services
```text
http://localhost:8071/accounts/prod
http://localhost:8071/accounts/qa
http://localhost:8071/cards/prod
and so on...
```

config server should be started, otherwise property binding issue may occur for $`{build.version}` because now they have moved to config server service.
<br> config server also supports encryption of data, if reading encrypted data from external config, use prefix as `{ciper}then_your_encrypted_code_here`

```yaml
accounts:
  email: {cipher}a85404b53fc9070fe004709beed9a42225a9c5782414a599c4a0c9fbe8e0bd43
```

- **Spring boot Actuator**
  - We can refresh the environment properties data without restarting running microservices.
- **Spring Cloud Bus**
  - `/actuator/busrefresh`: This is similar to `/actuator/refresh endpoint, but when used any one of the microservice same action triggered to every microservices which are connected to SPRING CLOUD BUS
- **Spring Cloud Config Monitor**
  - works when webhook event is triggered, all services then busrefreshed
  - should be added in configserver

# Annotations Used
- `@ConfigurationProperties(prefix="account")`
  - This annotation is used to bind data from application.yml file to a record class where data will be final
  - For this annotation to work, we need to enable configuration property by adding `@EnableConfigurationProperties(value={Class_References_where we are actually using ConfigurationProperties})` in Main Class

# Section 7
- Add Mysql DB and remove H2.
  - create a docker image for mysql for each service

```bash
docker run -p 3306:3306 --name accountsdb -e MYSQL_ROOT_PASSWORD="root" -e MYSQL_DATABASE="accountsdb" -d mysql
docker run -p 3307:3306 --name cardsdb -e MYSQL_ROOT_PASSWORD="root" -e MYSQL_DATABASE="cardsdb" -d mysql
docker run -p 3308:3306 --name loansdb -e MYSQL_ROOT_PASSWORD="root" -e MYSQL_DATABASE="loansdb" -d mysql
```

# Section 8
- `Eureka Server`