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

## Updating images

After editing the Dockerfile (or related assets):

1. Edit the Terraform template (`main.tf`)

```console
vim main.tf
```

Bump the image tag to a new version:

```diff
resource "docker_image" "coder_image" {
    name = "coder-base-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
    build {
        path       = "./build/"
        dockerfile = "${var.docker_image}.Dockerfile"
-        tag        = ["coder-${var.docker_image}:v0.1"]
+        tag        = ["coder-${var.docker_image}:v0.2"]
    }

    # Keep alive for other workspaces to use upon deletion
    keep_locally = true
}
```

Update the template:

```console
coder template push
```

Optional: Update workspaces to the latest template version

```console
coder ls
coder update [workspace name]
```
