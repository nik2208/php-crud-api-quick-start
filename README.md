# PHP-CRUD-API QUICK START
A customizable, ready to go, docker compose file featuring
- [PHP-CRUD-API](https://github.com/mevdschee/php-crud-api)
- MySQL
- PHP-FPM
- NGINX
- PHPMYADMIN
- SWAGGER (OPENAPI)

Just rename `.env.sample` to `.env` and set the environment values to suite your needs.

## PREREQUISITES:
- Any host runnign Docker[^1]
[^1]:You will be able to reach your Treeql instance via `http(s)://<your_docker_host_ip>:8080/`
  
  
## PREREQUISITES FOR THE INSTANCE TO BE REACHED ON THE WEB
- Any host running Docker
- A reverse proxy with public IP redirecting **YOUR A RECORD** (e.g. api.exemple.com) towards your docker host[^2]
[^2]:Needs a minimal network knowledge.

## USAGE:
### Your `tests` table will be available at
https://api.example.com/records/tests (no need of explicit api.php)[^3]
[^3]:After your first deployment the database will be empty.
### Your PHPMYADMIN instance will be available at
https://api.example.com/phpmyadmin/
### Your SWAGGER instance will be available at
https://api.example.com/openapi/

## GITLAB CD/CI
A `.gitlab-ci.yml` file is provided.[^4]
[^4]:Needs Gitlab variables properly set.

The CD/CI flow expects to find a cloned repository on the deploying host, and the `.env` file properly set for that specific host/environment.
The provided Gitlab pipeline encompasses three branches, related to three hosts/environments:
- develop
- staging
- prod

Merges into develop will update the development environment, merges into staging will update the staging environment, a commit tag will update the production environment.
