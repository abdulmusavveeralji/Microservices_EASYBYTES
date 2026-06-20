# MICROSERVICES
- Accounts Service : 8080
- Loan Service : 8090
- Cards Service : 9000
  - H2 in memory database is added, and schema is auto generated using `schema.sql` file
  - h2 database will be directly hosted in this endppoint during runtime `/h2-console`
  - Global exception handler supported
  - Audit Aware integrated, for generating audit for each operation.

### Account Service Endpoints
```text
POST: http://locahost:8080/api/create
GET: http://locahost:8080/api/fetch?mobileNumber=1234567890
UPDATE: http://locahost:8080/api/update
DELETE: http://locahost:8080/api/delete?mobileNumber=1234567890

SWAGGER UI:
http://locahost:8080/swagger-ui.html
```


# Docker and Containerization

# Annotations Used
- `@ConfigurationProperties(prefix="account")`
  - This annotation is used to bind data from application.yml file to a record class where data will be final
  - For this annotation to work, we need to enable configuration property by adding `@EnableConfigurationProperties(value={Class_References_where we are actually using ConfigurationProperties})` in Main Class
  - 