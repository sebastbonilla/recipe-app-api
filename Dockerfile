FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1 # env var to run python on an unbuffered mode which is recommended for containers

# install dependencies from requirements.txt
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# make directory to store our src code
RUN mkdir /app
WORKDIR /app
COPY ./app /app

# create the user that will run the app
RUN adduser -D user
USER user

