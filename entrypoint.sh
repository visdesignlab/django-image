#! /bin/bash

# The entrypoint.sh script is executed when the container is started. 
# It is the perfect time to install the dependencies from the bound volume, run the migrations, and start the server.
# We'll use the docker-compose file that references this container to set an environment variable that will be used to determine if we should run the production or development server.

# Install dependencies
poetry config virtualenvs.create false
poetry install --no-interaction --no-ansi

# Run migrations
poetry run migrate

# Start server
if [ "$DJANGO_DEBUG" = "False" ]; then
    poetry run serve:prod
else
    poetry run serve
fi
