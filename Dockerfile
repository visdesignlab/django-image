FROM python:PYTHON_VERSION-slim
LABEL org.opencontainers.image.source="https://github.com/visdesignlab/django-image"

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential libpq-dev python3-dev default-libmysqlclient-dev pkg-config \
  && rm -rf /var/lib/apt/lists/*

COPY ./djangoDJANGO_VERSION/* /install/
WORKDIR /install

RUN pip3 install poetry
RUN poetry install

VOLUME /app
WORKDIR /app

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /app
WORKDIR /app

EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
