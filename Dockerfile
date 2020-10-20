FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1 # env var to run python on an unbuffered mode which is recommended for containers

# install dependencies from requirements.txt
COPY ./requirements.txt /requirements.txt
# we need to install this package before installing posgres dependencies in python (see requirements.txt)
RUN apk add --update --no-cache postgresql-client jpeg-dev
# build temporary requirements needed for postgres to run
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
# delete the temporary requirements
RUN apk del .tmp-build-deps

# make directory to store our src code
RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# create the user that will run the app
RUN adduser -D user
# give permission access to the web vol for this user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user

