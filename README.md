# PHP-CRUD-API QUICK START
A customizable, ready-to-go, Docker Compose file featuring
- [PHP-CRUD-API](https://github.com/mevdschee/php-crud-api)
- MySQL / PostgreSQL (optional)
- FRANKEN PHP
- CADDY
- ADMINER/PHPMYADMIN
- SWAGGER (OPENAPI)

## INSTALLATION:

Just pull the repo `git clone https://github.com/nik2208/php-crud-api-quick-start.git && cd php-crud-api-quick-start`, rename the file `.env.sample` into `.env` and set the environment values to suit your needs:

```ini
#rename to .env
# DOCKER STACK EXPOSED PORT.
PORT=8080

# API SUBDOMAIN (DNS RECORD A) OR HTTP(S)://IP_ADDRESS:PORT/ IF LOCALLY DEPLOYED
SERVER_NAME=http://127.0.0.1:8080/

###########################################
#DATABASE DRIVER ("mysql" or "pgsql")
#Choose your database driver - use "mysql" for MySQL/MariaDB or "pgsql" for PostgreSQL
PHP_CRUD_API_DRIVER=mysql

###########################################
#MYSQL DATABASE PARAMETERS (only if using MySQL)
MYSQL_ROOT_PASSWORD=samplepassword
MYSQL_DATABASE=sampledb
MYSQL_USER=sampleuser
MYSQL_PASSWORD=samplepassword

###########################################
#POSTGRESQL DATABASE PARAMETERS (only if using PostgreSQL)
POSTGRES_DATABASE=sampledb
POSTGRES_USER=sampleuser
POSTGRES_PASSWORD=samplepassword

###########################################
#API.PHP PARAMETERS
#These are auto-calculated based on PHP_CRUD_API_DRIVER (leave empty)
PHP_CRUD_API_PORT=
PHP_CRUD_API_ADDRESS=
PHP_CRUD_API_DATABASE=sampledb
PHP_CRUD_API_USERNAME=sampleuser
PHP_CRUD_API_PASSWORD=samplepassword
PHP_CRUD_API_DEBUG=1

###########################################
#DB ADMIN TOOL ("adminer" OR "phpmyadmin" - phpmyadmin only with MySQL)
DB_ADMIN_TOOL=phpmyadmin

#Auto-calculated (leave empty)
ADMINER_DEFAULT_SERVER=

###########################################
#CONTAINERS' NAME SUFFIX
CONTAINERS_NAME_SUFFIX=php-quick-start
```

## Quick Start with MySQL (Default)
```bash
# Copy sample config
cp .env.sample .env

# Edit .env and ensure:
PHP_CRUD_API_DRIVER=mysql
# Other values will be auto-calculated

# Start stack
chmod +x start.sh stop.sh
./start.sh
```

## Quick Start with PostgreSQL
```bash
# Copy sample config
cp .env.sample .env

# Edit .env and change only:
PHP_CRUD_API_DRIVER=pgsql
POSTGRES_DATABASE=sampledb
POSTGRES_USER=sampleuser
POSTGRES_PASSWORD=samplepassword
DB_ADMIN_TOOL=adminer  # PhpMyAdmin only works with MySQL

# Start stack
chmod +x start.sh stop.sh
./start.sh
```

Then run `./start.sh`. Enjoy!🎉🚀

To stop the stack run `./stop.sh`.

## REQUIREMENTS:
- Any host running [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

In case your running your instance on localhost and your selected port is 8080 with MySQL:

**Your `tests` table will be available at**
http://127.0.0.1:8080/records/tests (no need of explicit api.php)[^1]

**Your MYSQL ADMIN instance will be available at**
http://127.0.0.1:8080/dbadmin/

**Your SWAGGER instance will be available at**
http://127.0.0.1:8080/swagger/

Change ip and port accordingly if host and port differ.

### With PostgreSQL
If you're using PostgreSQL with Adminer (recommended for PostgreSQL):

**Your `tests` table will be available at**
http://127.0.0.1:8080/records/tests

**Your DB ADMIN (Adminer) will be available at**
http://127.0.0.1:8080/dbadmin/

Connection settings in Adminer:
- System: PostgreSQL
- Server: postgres_treeqlqs-{CONTAINERS_NAME_SUFFIX}
- Username: {POSTGRES_USER}
- Password: {POSTGRES_PASSWORD}
- Database: {POSTGRES_DATABASE}

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
