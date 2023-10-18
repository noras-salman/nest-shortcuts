#!/bin/bash
############################################
# This script creates a project with:
# - nestjs (backend)
# - nextjs (frontend)
# - mysql or posgress (database)
# - ngnix (reverse proxy)
# everything should run wih one command 
# $ docker compose up
# Run: bash create-project.sh -p PROJECT_NAME
# or Run: bash create-project.sh 
############################################

current_dir=$(pwd)
project_name=""
suggested_project_name=$(basename "$current_dir")




if   [ -z "$project_name" ]; then
    while getopts "p:" arg; do
      case $arg in
        p)
          project_name=$OPTARG
          ;;
      esac
    done
  if   [ -z "$project_name" ]; then
      read -p "[?] Use '$suggested_project_name' as porject name [Yy]?  " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
          project_name=$suggested_project_name
      fi
  fi
    if   [ -z "$project_name" ]; then
      echo 'Error: project_name not passed with arg -p. ex: bash create-project.sh -p PROJECT_NAME' >&2
      exit 1
    fi
fi

echo "[*] Using '$project_name' as project name..."

new_dir=0
read -p "[?] Create new dir for the project [Yy]?  " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    new_dir=1
    mkdir -p $project_name
    cd $project_name
fi
 
PS3="[*] Select Database (Enter a number): "
db_type="'mysql'"
db_package='mysql2'
db_port=3306
db_pass="proccess.env.MYSQL_ROOT_PASSWORD"
db_user="'root'"
db_name="proccess.env.MYSQL_DATABASE"
select database in MySQL PostgreSQL
do
    case $database in
        MySQL)
          echo "Selected database: $database"
            break;;
        PostgreSQL)
            echo "Selected database: $database"
            db_type="'postgres'"
            db_package='pg'
            db_port=5432
            db_pass="proccess.env.POSTGRES_PASSWORD"
            db_name="proccess.env.POSTGRES_DB"
            db_user="proccess.env.POSTGRES_USER"
            break;;
        *) 
            echo "Invalid option $REPLY";
    esac
done

mkdir -p config

random_string=$(cat /dev/urandom | head -c 60 | base64 )
if [ $database == "MySQL" ]; then

    echo "MYSQL_ROOT_PASSWORD=$random_string">./config/variables
    echo "MYSQL_DATABASE=$project_name">>./config/variables
else
    echo "POSTGRES_PASSWORD=$random_string">./config/variables
    echo "POSTGRES_USER=$project_name">>./config/variables
    echo "POSTGRES_DB=$project_name">>./config/variables
fi

if command -v nest > /dev/null 2>&1; then
  echo "[*] @nestjs/cli is installed"
else
  npm i -g @nestjs/cli
fi


npx create-next-app@latest frontend --use-npm 

nest new backend 

NODE_DOCKER_FILE='FROM node:alpine
WORKDIR /app

COPY ./ /app

RUN rm -Rf node_modules
RUN npm install
#RUN npm run build
'




cd backend
npm install --save @nestjs/typeorm typeorm $db_package
npm i --save class-validator class-transformer

echo "import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors()
  app.setGlobalPrefix('api');
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(3000);
}
bootstrap();
"> ./src/main.ts

echo "import { Module } from '@nestjs/common';
import { InjectDataSource, TypeOrmModule } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: '$db_type',
      host: '$project_name-database',
      port: $db_port,
      username: $db_user,
      password: $db_pass,
      database: $db_name,
      entities: [],
      synchronize: true,
    }),
  ],
})
export class AppModule {
  constructor(@InjectDataSource() private dataSource: DataSource) {}
  async onModuleInit() {
    const sql_clean = ``;
    const sql = ``;
    for (const statement of sql_clean.split(';')) {
      try {
        if (statement.trim() !== '') await this.dataSource.query(statement);
      } catch (e) {
        console.error(e);
      }
    }

    for (const statement of sql.split(';')) {
      try {
        if (statement.trim() !== '') await this.dataSource.query(statement);
      } catch (e) {
        console.error(e);
      }
    }
  }
}
">./src/app.module.ts



cd ..


 
echo "$NODE_DOCKER_FILE">./backend/Dockerfile
echo "$NODE_DOCKER_FILE">./frontend/Dockerfile

mkdir -p proxy/includes

echo 'FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY ./includes/development.conf /etc/nginx/includes/enviroment.conf
CMD ["nginx", "-g", "daemon off;"]'>./proxy/Dockerfile

echo "server { 
 
 include /etc/nginx/includes/enviroment.conf;

 
  location /api {
   proxy_set_header X-Real-IP \$remote_addr;
   proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
   proxy_set_header X-NginX-Proxy true;
   proxy_pass http://$project_name-backend:3000/api;
   proxy_ssl_session_reuse off;
   proxy_set_header Host \$http_host;
   proxy_cache_bypass \$http_upgrade;
   proxy_redirect off;
 }
}">./proxy/nginx.conf

echo "listen 80;
server_name $project_name-frontend;

 location / {
   proxy_set_header X-Real-IP \$remote_addr;
   proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
   proxy_set_header X-NginX-Proxy true;
   proxy_pass http://$project_name-frontend:3000;
   proxy_ssl_session_reuse off;
   proxy_set_header Host \$http_host;
   proxy_cache_bypass \$http_upgrade;
   proxy_redirect off;
 }">./proxy/includes/development.conf



if [ $database == "MySQL" ]; then

DATABASE_CONTAINER="$project_name-database:
    container_name: $project_name-database
    image: mysql:8.1
    volumes:
      - ./persistence/db:/var/lib/mysql
    ports:
      - 3306:3306
    env_file:
      - ./config/variables
    restart: always"
else
DATABASE_CONTAINER="$project_name-database:
    container_name: $project_name-database
    image: postgres:latest
    volumes:
      - ./persistence/db:/var/lib/postgresql/data
    ports:
      - 5432:5432
    env_file:
      - ./config/variables
    restart: always"
fi

echo "version: '3'
services:
  $project_name-proxy:
    container_name: $project_name-proxy
    build: ./proxy
    ports:
      - 8080:80
    depends_on:
      - $project_name-frontend
      - $project_name-backend
    volumes:
      - ./proxy/nginx.conf:/etc/nginx/conf.d/default.conf
      - ./proxy/includes/development.conf:/etc/nginx/includes/enviroment.conf
    restart: always
  $project_name-frontend:
    container_name: $project_name-frontend
    build: ./frontend
    depends_on:
      - $project_name-backend
    volumes:
      - ./frontend/public:/app/public
      - ./frontend/src:/app/src
    entrypoint: npm run dev

  $project_name-backend:
    container_name: $project_name-backend
    build: ./backend/
    volumes:
      - ./backend/src:/app/src
    entrypoint: npm run start:dev
    env_file:
      - ./config/variables

  $DATABASE_CONTAINER
"> docker-compose.yml



echo '
# Created by https://www.gitignore.io/api/osx,linux,python,windows,pycharm,visualstudiocode

### Linux ###
*~

# temporary files which can be created if a process still has a handle open of a deleted file
.fuse_hidden*

# KDE directory preferences
.directory

# Linux trash folder which might appear on any partition or disk
.Trash-*

# .nfs files are created when an open file is removed but is still being accessed
.nfs*

### OSX ###
*.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

### PyCharm ###
# Covers JetBrains IDEs: IntelliJ, RubyMine, PhpStorm, AppCode, PyCharm, CLion, Android Studio and Webstorm
# Reference: https://intellij-support.jetbrains.com/hc/en-us/articles/206544839

# User-specific stuff:
.idea/**/workspace.xml
.idea/**/tasks.xml
.idea/dictionaries

# Sensitive or high-churn files:
.idea/**/dataSources/
.idea/**/dataSources.ids
.idea/**/dataSources.xml
.idea/**/dataSources.local.xml
.idea/**/sqlDataSources.xml
.idea/**/dynamic.xml
.idea/**/uiDesigner.xml

# Gradle:
.idea/**/gradle.xml
.idea/**/libraries
.idea

# CMake
cmake-build-debug/

# Mongo Explorer plugin:
.idea/**/mongoSettings.xml

## File-based project format:
*.iws

## Plugin-specific files:

# IntelliJ
/out/

# mpeltonen/sbt-idea plugin
.idea_modules/

# JIRA plugin
atlassian-ide-plugin.xml

# Cursive Clojure plugin
.idea/replstate.xml

# Ruby plugin and RubyMine
/.rakeTasks

# Crashlytics plugin (for Android Studio and IntelliJ)
com_crashlytics_export_strings.xml
crashlytics.properties
crashlytics-build.properties
fabric.properties

### PyCharm Patch ###
# Comment Reason: https://github.com/joeblau/gitignore.io/issues/186#issuecomment-215987721

# *.iml
# modules.xml
# .idea/misc.xml
# *.ipr

# Sonarlint plugin
.idea/sonarlint

### Python ###
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
.pytest_cache/
nosetests.xml
coverage.xml
*.cover
.hypothesis/

# Translations
*.mo
*.pot

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# Jupyter Notebook
.ipynb_checkpoints

# pyenv
.python-version

# celery beat schedule file
celerybeat-schedule.*

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/

### VisualStudioCode ###
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.history

### Windows ###
# Windows thumbnail cache files
Thumbs.db
ehthumbs.db
ehthumbs_vista.db

# Folder config file
Desktop.ini

# Recycle Bin used on file shares
$RECYCLE.BIN/

# Windows Installer files
*.cab
*.msi
*.msm
*.msp

# Windows shortcuts
*.lnk

# Build folder

*/build/*
# End of https://www.gitignore.io/api/osx,linux,python,windows,pycharm,visualstudiocode

.data
packaged.yaml
shared_resources_packaged.yaml
config_packaged.yaml
config.yaml
src/layers/**/python/
src/reports_service/layers/**/python/
*.zip
calibrations_api/stitch/develop/*

# docker compose
docker-compose.override.yml

# .env
.env

# visual studio folder
.vscode/

# pipenv files
Pipfile
Pipfile.lock
calibrations_api_resources_packaged.yaml
scratch
shared-resources
docker-compose.override.yml
samconfig.toml

#terraform
.terraform
.terraform.lock.hcl

persistence'>.gitignore


if [ $database == "MySQL" ]; then
    cp create-repository.sh ./backend/

    read -p "[?] Create test 'Users' CRUD ENDPOINT [Yy]?  " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        cd backend 
        nest g res user
        bash create-repository.sh -s users
        cd ..
    fi
fi
 
rm -Rf ./backend/.git
rm -Rf ./frontend/.git
git init

if [ $new_dir -eq 1 ];then
  cd ..
fi