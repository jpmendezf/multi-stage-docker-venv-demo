########
# Python dependencies builder
#
FROM python:3-stretch AS builder

# Always set a working directory
WORKDIR /app
# Sets utf-8 encoding for Python
ENV LANG=C.UTF-8
# Turns off writing .pyc files. Superfluous on an ephemeral container.
ENV PYTHONDONTWRITEBYTECODE=1
# Seems to speed things up
ENV PYTHONUNBUFFERED=1

# Ensures that the python and pip executables used
# in the image will be those from our virtualenv.
ENV PATH="/venv/bin:$PATH"

# Install OS package dependencies.
# Do all of this in one RUN to limit final image size.
RUN yum update && \
    yum install -y --no-install-recommends gettext build-essential && \
    rm -rf /var/lib/apt/lists/*

# Setup the virtualenv
RUN python -m venv /venv

# Install Python deps
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


########
# slim app container
#
FROM python:3-slim-stretch AS app

# Extra python env
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PATH="/venv/bin:$PATH"
ENV PORT=8000

# add non-priviledged user
RUN adduser --uid 1000 --disabled-password --gecos '' --no-create-home webdev

WORKDIR /app
EXPOSE 8000
CMD ["python", "app.py"]

# copy in Python environment
COPY --from=builder /venv /venv

COPY ./static ./static
COPY ./templates ./templates
COPY ./app.py ./

RUN chown webdev.webdev -R .
USER webdev
