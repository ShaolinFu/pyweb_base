FROM continuumio/miniconda

# clear "debconf: unable to initialize frontend: Dialog" warning messages
ENV DEBIAN_FRONTEND=noninteractive

# temp folder for running script, this folder will be cleaned later
WORKDIR /build-tmp

# Install basic tools, Sqlite and Nginx, System packages
RUN apt-get update && apt-get install -y software-properties-common \
  && apt-get install -y tar git curl nano wget dialog net-tools build-essential \
  && apt-get install -y nginx supervisor \
  && apt-get install -y sqlite3 libsqlite3-dev postgresql postgresql-contrib redis-server \
  && apt-get update && apt-get install -y curl libssl-dev libpq-dev libcurl4-openssl-dev

# Copy requirements.txt and install pip packages
ADD ./requirements.txt /build-tmp/requirements.txt
RUN pip --no-cache-dir install $PIPMIRROR -r /build-tmp/requirements.txt \
  && pip install $PIPMIRROR gunicorn

# restore sources.list and clean the build-tmp folder
RUN rm -r -f /build-tmp
