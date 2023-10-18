# Quick start

```bash
mkdir -p webapp
cd webapp
curl -L https://raw.githubusercontent.com/noras-salman/nest-shortcuts/master/create-project.sh > create-project.sh &&\
curl -L https://raw.githubusercontent.com/noras-salman/nest-shortcuts/master/create-repository.sh > create-repository.sh &&\
bash create-project.sh
```

## Create fullstack project

This script creates a project with:

- nestjs (backend)
- nextjs (frontend)
- mysql or posgress (database)
- ngnix (reverse proxy)

with the following structure

```bash
├── backend
│   ├── Dockerfile
│   ├── README.md
│   ├── create-repository.sh
│   ├── nest-cli.json
│   ├── package-lock.json
│   ├── package.json
│   ├── src
│   │   ├── app.controller.spec.ts
│   │   ├── app.controller.ts
│   │   ├── app.module.ts
│   │   ├── app.service.ts
│   │   └── main.ts
│   ├── test
│   │   ├── app.e2e-spec.ts
│   │   └── jest-e2e.json
│   ├── tsconfig.build.json
│   └── tsconfig.json
├── config
│   └── variables
├── create-project.sh
├── create-repository.sh
├── docker-compose.yml
├── frontend
│   ├── Dockerfile
│   ├── README.md
│   ├── jsconfig.json
│   ├── next.config.js
│   ├── package-lock.json
│   ├── package.json
│   ├── public
│   │   ├── next.svg
│   │   └── vercel.svg
│   └── src
│       └── app
│           ├── favicon.ico
│           ├── globals.css
│           ├── layout.js
│           ├── page.js
│           └── page.module.css
└── proxy
    ├── Dockerfile
    ├── includes
    │   └── development.conf
    └── nginx.conf
```

everything should run wih one command in docker

```bash
docker compose up
```

and the app will run at http://127.0.0.1:8080 or http://localhost:8080

### Run:

```bash
bash create-project.sh -p PROJECT_NAME
```

or

```bash
bash create-project.sh
```

## Create nest.js repository with CRUD operations

Add the script `create-repository.sh` to the root dir of nest.js project

```bash
bash create-repository.sh -s ENTITY_NAME
```

for example running

```bash
bash create-repository.sh -s users
```

will create the resources and a repository with all CRUD operations with the following file structure:

```bash
src
└── users
    ├── users.controller.ts
    ├── users.dto.ts
    ├── users.module.ts
    ├── users.repository.ts
    └── users.service.ts
```
