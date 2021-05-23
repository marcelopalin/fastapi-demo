# https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

# set environment variables
ENV PYTHONWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

# set working directory
WORKDIR /api

# copy dependencies
COPY requirements.txt /api/

# install dependencies
RUN pip install -r requirements.txt

# copy project
COPY . /api/

# expose port
EXPOSE 5000
