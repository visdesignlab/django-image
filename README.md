# Django Docker Image'

## Overview

This repo defines a docker image for Django projects. It is based on the official python image and adds some additional packages that are useful for Django projects. The goal is for it to be a good base image for Django projects, that can be used for our backend development. It comes with all the linux dependencies needed to install the most common django python packages, like sql libraries, etc.

We publish this image to the GitHub Container Registry, and the image is tagged with the django version and release version, so you can pin your project to a specific version of the image. When using the image, we always prefer that you pin to a specific version so that we can ensure that your project will always work with the image, and so that we can identify security issues with repos that are using the image.

The images we build will always include the 2 most recent LTS versions of Django. The python versions will be pinned to the python version that is best supported by the Debian base image, for best compatibility with python3-dev.  

## Usage

To use this image in your project, we recommend that you use docker-compose to define your services. You can use the image in your docker-compose.yml file like this:

```yaml
services:
  backend:
    image: ghcr.io/visdesignlab/django-image:4.2-v0.0.12
    volumes:
      - .:/app
    environment:
      - DJANGO_DEBUG=True
      - DJANGO_SECRET_KEY=this-is-not-secret
      - REQUIRE_LOGINS=False
      - MYSQL_DB=sanguine
      - MYSQL_USER=sanguine
      - MYSQL_PASSWORD=test
      - MYSQL_HOST=mysql
      - MYSQL_PORT=3306
    ports:
      - "8000:8000"

  mariadb:
    image: mariadb:lts
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: sanguine
      MYSQL_USER: sanguine
      MYSQL_PASSWORD: test
    ports:
      - "3306:3306"
```

This defines a backend service that uses the image, and a mariadb service that is used by the backend service. The backend service is configured to use the mysql service as its database. The backend service is also configured to mount the current directory as a volume in the container, so that you can edit your code and see the changes without having to rebuild the image.

Before you run `docker-compose up` you will need to make sure you have poetry set up in your project. You can do this by running `poetry init` in your project directory. This will create a pyproject.toml file that defines your project. In your projects poetry environment, you will need to make sure you have django installed and pinned to the lts version of the image that you're using here. For example, for 4.2 as above, you'd need to run `poetry add django~=4.2`. You can also add any other dependencies you need to your project here, including any sql libraries you're planning to use. In this example you'd run `poetry add mysqlclient` to add the mysql client library to your project.

Once you have your project set up, you can run `docker-compose up` to start the backend service. You can then access your project at http://localhost:8000.
