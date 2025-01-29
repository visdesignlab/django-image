#!/bin/bash

# The entrypoint.sh script is executed when the container is started. 
# It is the perfect time to install the dependencies from the bound volume, run the migrations, and start the server.
# We'll use the docker-compose file that references this container to set an environment variable that will be used to determine if we should run the production or development server.

# Trap SIGINT and SIGTERM signals and forward them to the child process
trap 'kill -SIGINT $PID' SIGINT
trap 'kill -SIGTERM $PID' SIGTERM

# Install dependencies
poetry config virtualenvs.create false
poetry install --no-interaction --no-ansi --no-root

# Run migrations
poetry run python manage.py migrate --no-input

# Start server
if [ "$DJANGO_DEBUG" = "True" ]; then
    poetry run python manage.py runserver 0.0.0.0:8000 &
else
    GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-30}
    poetry run gunicorn api.wsgi:application --bind 0.0.0.0:8000 --timeout $GUNICORN_TIMEOUT &
fi

# Get the PID of the background process
PID=$!

# Wait for the background process to finish
wait $PID
