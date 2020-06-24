# Multistage Docker and Virtualenv Demo


## Getting started

Have [Docker][] and [Docker Compose][] installed and then simply run:

```bash
$ docker-compose up app
```

This will build the docker image and start the server. So far the service is very simple, but should give you a starting point.
See the [Responder docs][] if you'd like to play around more with that.
I think it's quite an interesting project.

I've also included a Pipfile and Pipfile.lock if you'd like to use [pipenv][] instead. To use that with the default setup
change your command to:

```bash
$ docker-compose up app-pipenv
```

There is also the `Dockerfile-full`, which is an example of the result of not using multi-stage builds for your python
environment. Build that with the following command and then you can compare for yourself:

```bash
$ docker-compose up app-full
```
