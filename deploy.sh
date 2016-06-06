NAMESPACE=leokraken
NODE_ENV=development

# MONGODB-COCHERA ENV
MONGODB_DATABASE=cochera
MONGODB_USER=cochera
MONGODB_PASSWORD=cochera
MONGODB_SERVICE_NAME=mongo
MONGO_PERSISTENCE=ephemeral

# MONGODB-COCHERA ENV
MONGODB_KEYCLOAK_DATABASE=keycloak
MONGODB_KEYCLOAK_USER=keycloak
MONGODB_KEYCLOAK_PASSWORD=keycloak
MONGODB_KEYCLOAK_SERVICE_NAME=mongo-keycloak
MONGO_KEYCLOAK_PERSISTENCE=ephemeral

# MYSQL_GHOST
MYSQL_PERSISTENCE=ephemeral
MYSQL_DATABASE_SERVICE_NAME=mysql
MYSQL_USER=ghost
MYSQL_PASSWORD=ghost
MYSQL_DATABASE=ghost

# COCHERA ENV
COCHERA_SERVICE_NAME=cochera
SOURCE_REPOSITORY_URL=https://github.com/thedigitalgarage/cochera.git
SOURCE_REPOSITORY_REF=UrlRedirection

GHOST_URL=http://ghost-leotesting.apps.thedigitalgarage.io
GHOST_ADMIN_PASSWORD=mypassword
GHOST_ADMIN=lclavijo@bixlabs.com

CHARGEBEE_DEFAULT_PLAN=cbdemo_free


# KEYCLOAK ENV
KEYCLOAK_USER=admin
KEYCLOAK_PASSWORD=admin

# GHOST ENV
## Set up mail configuration in order to invite registered people to create post
GHOST_MAIL_ACCOUNT=ghostmail@gmail.com
GHOST_MAIL_AUTH=mypassword


# INSTANCES

#####################################################################
#####    KEYCLOAK						#####
#####################################################################


# MONGO-KEYCLOAK INSTANCE
oc new-app "mongodb-${MONGO_KEYCLOAK_PERSISTENCE}" \
--param "DATABASE_SERVICE_NAME=${MONGODB_KEYCLOAK_SERVICE_NAME}" \
--param "MONGODB_PASSWORD=${MONGODB_KEYCLOAK_PASSWORD}" \
--param "MONGODB_USER=${MONGODB_KEYCLOAK_USER}" \
--param "MONGODB_DATABASE=${MONGODB_KEYCLOAK_DATABASE}"

# KEYCLOAK INSTANCE
oc new-app ${NAMESPACE}/keycloak-mongo \
-e "KEYCLOAK_USER=${KEYCLOAK_USER}" \
-e "KEYCLOAK_PASSWORD=${KEYCLOAK_PASSWORD}" \
-e "MONGO_PORT_27017_TCP_ADDR=${MONGODB_KEYCLOAK_SERVICE_NAME}" \
-e "MONGODB_DBNAME=${MONGODB_KEYCLOAK_DATABASE}" \
-e "MONGODB_USER=${MONGODB_KEYCLOAK_USER}" \
-e "MONGODB_PASSWORD=${MONGODB_KEYCLOAK_PASSWORD}"

#####################################################################
#####    GHOST							#####
#####################################################################

# MYSQL-GHOST
oc new-app "mysql-${MYSQL_PERSISTENCE}" \
--param "DATABASE_SERVICE_NAME=${MYSQL_DATABASE_SERVICE_NAME}" \
--param "MYSQL_USER=${MYSQL_USER}" \
--param "MYSQL_PASSWORD=${MYSQL_PASSWORD}" \
--param "MYSQL_DATABASE=${MYSQL_DATABASE}"

# GHOST INSTANCE
oc new-app ${NAMESPACE}/ghost-style \
-e "GHOST_MAIL_ACCOUNT=${GHOST_MAIL_ACCOUNT}" \
-e "GHOST_MAIL_AUTH=${GHOST_MAIL_AUTH}" \
-e "MYSQL_SERVICE_HOST=${MYSQL_DATABASE_SERVICE_NAME}" \
-e "MYSQL_USER=${MYSQL_USER}" \
-e "MYSQL_PASSWORD=${MYSQL_PASSWORD}" \
-e "MYSQL_DATABASE=${MYSQL_DATABASE}"


#####################################################################
#####    COCHERA						#####
#####################################################################

# MONGO-COCHERA INSTANCE
oc new-app "mongodb-${MONGO_PERSISTENCE}" \
--param "DATABASE_SERVICE_NAME=${MONGODB_SERVICE_NAME}" \
--param "MONGODB_PASSWORD=${MONGODB_PASSWORD}" \
--param "MONGODB_USER=${MONGODB_USER}" \
--param "MONGODB_DATABASE=${MONGODB_DATABASE}"

# PRE:
## Create ghost admin account
## Create Keycloak client and client_secret, and attach .json file.

# COCHERA NEEDS KEYCLOAK AND GHOST URL
# COCHERA INSTANCE
oc new-app ${NAMESPACE}/cochera \
-e "MONGODB_SERVICE_HOST=${MONGODB_SERVICE_NAME}" \
-e "MONGODB_DATABASE=${MONGODB_DATABASE}" \
-e "MONGODB_USER=${MONGODB_USER}" \
-e "MONGODB_PASSWORD=${MONGODB_PASSWORD}" \
-e "NODE_ENV=${NODE_ENV}" \
-e "GHOST_URL=${GHOST_URL}" \
-e "GHOST_ADMIN=${GHOST_ADMIN}" \
-e "GHOST_ADMIN_PASSWORD=${GHOST_ADMIN_PASSWORD}" \
-e "CHARGEBEE_DEFAULT_PLAN=${CHARGEBEE_DEFAULT_PLAN}"





