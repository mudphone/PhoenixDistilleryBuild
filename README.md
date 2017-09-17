# Phoenix Distillery Release for EC2

## Build the container
`docker build -t test/myapp .`

## Run the container and connect
`docker run -it --rm test/myapp`

## Run with app volume attached
`docker run -it --rm -v /path/to/myapp:/app test/myapp`

## Run with volume and ports 
`docker run -it --rm -v /path/to/myapp:/app -p 4000:4000 -e MIX_ENV=prod -e PORT=4000 test/myapp`

## Only if you're not going to use the SECRET_KEY_BASE env var...
copy prod.secret.exs to /root or wherever specified in prod.exs

## If using `${VAR}` syntax
Include `-e REPLACE_OS_VARS=true` (in Docker `run`)
Currently using `{:system, "VAR"}` syntax in prod.exs to replace at runtime

## To build the release from the container:
```bash
cd myapp
boot build
MIX_ENV=prod mix do phx.digest, release --env=prod
```

## To build the release from command line (using container):
`docker run -it --rm -v /path/to/myapp:/app -p 4000:4000 -e MIX_ENV=prod -e PORT=4000 test/myapp ./distillery_build.sh`

## Create local_deploy dir, expand files
To be done on AWS EC2 instance, running same OS (ubuntu 16.04 currently):
```bash
mkdir local_deploy
cp _build/prod/rel/myapp/releases/0.0.1/myapp.tar.gz local_deploy/
cd local_deploy
tar xvfz myapp.tar.gz
```

## Runtime Env Vars:
Replace "secret" with result of `mix phx.gen.secret`
```bash
DB_USERNAME_PROD
DB_PASSWORD_PROD
DB_NAME_PROD
DB_URL_PROD=postgres://username:password@host/database
PORT
SECRECT_KEY_BASE="64_bit_string"
REPLACE_OS_VARS=true
```

Example:
`PORT=4000 DB_URL_PROD="postgres://postgres:secret@host/myapp_prod" SECRET_KEY_BASE="64_bit_secret" REPLACE_OS_VARS=true ./bin/myapp foreground`

### Run the release interactively
`PORT=4000 SECRET_KEY_BASE=secret ./bin/myapp console`

### Run the release in foreground (Ctrl-C kills it)
`PORT=4000 SECRET_KEY_BASE=secret ./bin/myapp foreground`

### Run the release as a daemon (keeps running after remote shell exits)
`PORT=4000 SECRET_KEY_BASE=secret ./bin/myapp start`
