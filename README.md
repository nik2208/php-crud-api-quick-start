# PHP-CRUD-API QUICK START
A customizable, ready-to-go, Docker Compose file featuring
- [PHP-CRUD-API](https://github.com/mevdschee/php-crud-api)
- MySQL
- PHP-FPM
- NGINX
- ADMINER/PHPMYADMIN
- SWAGGER (OPENAPI)

## INSTALLATION:

Just pull the repo `git clone https://github.com/nik2208/php-crud-api-quick-start.git && cd php-crud-api-quick-start`, rename the file `.env.sample` into `.env` and set the environment values to suite your needs:

```ini
#rename to .env
# NGINX EXPOSED PORT: THE PORT WHERE YOU WANT YOUR DOCKER STACK TO LISTEN.
PORT=8080

# API SUBDOMAIN (DNS RECORD A) OR HTTP(S)://IP_ADDRESS:PORT/ IF LOCALLY DEPLOYED
# IF YOU DON'T HAVE AN FQDN (FULLY QUALIFIED DOMAIN NAME) AND YOU USE AN IP ADDRESS
# (WHETHER PUBLIC OR PRIVATE), THE ADDRESS MUST CONTAIN THE STACK-EXPOSED PORT AS
# CONFIGURED IN THE PREVIOUS STEP.
SERVER_NAME=http://127.0.0.1:8080/

###########################################
#DATABASE PARAMETERS
MYSQL_ROOT_PASSWORD=samplepassword
MYSQL_DATABASE=sampledb
MYSQL_USER=sampleuser
MYSQL_PASSWORD=samplepassword

###########################################
#API.PHP PARAMETERS
#DEBUG MODE
PHP_CRUD_API_DEBUG=1

###########################################
#DB ADMIN TOOL ("adminer" OR "phpmyadmin")
DB_ADMIN_TOOL=phpmyadmin
```

Then run `start.sh`. Enjoy!🎉🚀
To stop the stack run `stop.sh`.
Refer to [PHP-CRUD-API](https://github.com/mevdschee/php-crud-api) for further customizations.

## REQUIREMENTS:
- Any host runnign [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

In case your running your instance on localhost and your selected port is 8080.

**Your `tests` table will be available at**
http://127.0.0.1:8080/records/tests (no need of explicit api.php)[^1]
**Your MYSQL ADMIN instance will be available at**
http://127.0.0.1:8080/dbadmin/
**Your SWAGGER instance will be available at**
http://127.0.0.1:8080/swagger/

Change ip and port accordingly if host and port differ.

[^1]:After your first deployment the database will be empty.



## REQUIREMENTS FOR THE INSTANCE TO BE REACHED OVER THE WEB
- Any host running [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).
- A FQDN (Fully Qualified Domain Name), a public IP, a [reverse proxy](https://nginxproxymanager.com/) to forward **YOUR A RECORD** requests (e.g. api.exemple.com) to your Docker host[^2].

**Your `tests` table will be available at**
https://api.example.com/records/tests (no need of explicit api.php)[^1]
**Your MYSQL ADMIN instance will be available at**
https://api.example.com/dbadmin/
**Your SWAGGER instance will be available at**
https://api.example.com/swagger/


[^2]:Minimal networking knowledge is required.

## PERSISTENCY
After starting the Docker containers using `docker-compose up -d`, the MySQL database will be created and stored in the `mysql` folder of the cloned project. This folder is used to persist the database data between container restarts. It is important to regularly back up this folder to avoid data loss.

## GITLAB CI/CD
A `.gitlab-ci.yml` file is provided.[^3]
[^3]:Requires Gitlab CI/CD knowledge and Gitlab variables properly set.

The CI/CD flow expects to find a cloned repository on the deploying host, and the `.env` file properly set for that specific host/environment.
The provided Gitlab pipeline encompasses three branches, related to three hosts/environments:
- develop
- staging
- prod

Merges into `develop` will update the development environment, merges into `staging` will update the staging environment, a commit tag will update the production environment.
