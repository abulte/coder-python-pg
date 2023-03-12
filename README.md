---
name: Develop in Docker with python and postgresql
description: Build images with a specified python version when creating a workspace, plus a postgres db in a container
tags: [local, docker, postgres]
icon: /icon/docker.png
---

# coder-python-pg

Depends on [coder-python](https://github.com/abulte/coder-python).

## Getting started

Run `coder templates push` from this directory.

## Using the database from python/workspace container

Use `$DATABASE_URL` for credentials and location of the database.
