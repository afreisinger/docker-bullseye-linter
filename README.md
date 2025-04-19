# Linter Container
[![Build](https://github.com/afreisinger/docker-bullseye-linter/actions/workflows/build.yml/badge.svg)](https://github.com/afreisinger/docker-bullseye-linter/actions/workflows/build.yml) 
![Docker Pulls](https://img.shields.io/docker/pulls/afreisinger/docker-bullseye-linter?link=https%3A%2F%2Fhub.docker.com%2Fr%2Fafreisinger%2Fdocker-bullseye-linter)



This Docker container provides a lightweight environment to lint Bash scripts, Dockerfiles, YAML files, and Markdown files using the following tools:

- **bashate**: Lints Bash scripts (`.sh` or scripts with `#!/bin/bash`).
- **hadolint**: Lints Dockerfiles (`Dockerfile` or `*.dockerfile`).
- **yamllint**: Lints YAML files (`.yaml`, `.yml`).
- **markdownlint**: Lints Markdown files (`.md`, `.markdown`).

The container is designed for use in CI/CD workflows, with support for custom arguments and configuration files for each linter.  
It includes commands to check tool versions and display help.

## Features

- **Multi-stage build** for a minimal image size (~100-120 MB).
- **Parameterized tool versions** via build arguments.
- **Support for linter-specific arguments** (e.g., `--strict`, `--ignore`).
- **Automatic detection of configuration files** (e.g., `.yamllint`, `.hadolint.yaml`).
- **Custom configuration files** via `--config`.
- **Commands**: `bashate`, `hadolint`, `yamllint`, `markdownlint`, `version`, `help`, and interactive shell.

## Prerequisites

- Docker installed on your system.
- A directory with files to lint (e.g., `script.sh`, `Dockerfile`, `config.yaml`, `README.md`).
- Optional: Configuration files for linters (e.g., `.yamllint`, `.hadolint.yaml`).

## Building the Image

The Dockerfile uses build arguments to specify tool versions. Default versions are:

- `BASHATE_VERSION=2.1.1`
- `YAMLLINT_VERSION=1.37.0`
- `MARKDOWNLINT_VERSION=0.44.0`
- `HADOLINT_VERSION=2.12.0`
- `NODE_VERSION=18.19.1`
- `NPM_VERSION=10.2.4`

To build the image with default versions:

```bash
docker build -t mi-linter .
```

To build with custom versions:

```bash
docker build -t mi-linter \
  --build-arg BASHATE_VERSION=2.1.1 \
  --build-arg YAMLLINT_VERSION=1.38.0 \
  --build-arg MARKDOWNLINT_VERSION=0.44.0 \
  --build-arg HADOLINT_VERSION=2.12.0 \
  --build-arg NODE_VERSION=20.11.0 \
  --build-arg NPM_VERSION=10.2.4 .
```

To build with docker compose

```bash
docker compose build
```

## Usage

The container mounts the current directory to `/src` to access files for linting.  
Use the `-v $(pwd):/src` flag with `docker run`.

## Available Commands

- **bashate**: Lints Bash scripts.  
- **hadolint**: Lints Dockerfiles.  
- **yamllint**: Lints YAML files.  
- **markdownlint**: Lints Markdown files.  
- **version**: Shows installed tool versions.  
- **help**: Displays detailed help with examples.  
- **(no command)**: Starts an interactive shell.

## Configuration

Linters automatically detect configuration files in the working directory (`/src`):

| Tool         | Configuration Files                             |
|--------------|--------------------------------------------------|
| bashate      | `.bashaterc`                                    |
| hadolint     | `.hadolint.yaml`                                |
| yamllint     | `.yamllint`, `.yamllint.yaml`                   |
| markdownlint | `.markdownlint.json`, `.markdownlint.yaml`      |

You can also use the `--config` argument to specify custom configuration files.

## Examples

### Lint a Bash Script with bashate

```bash
docker run --rm -v $(pwd):/src <image> bashate script.sh
docker run --rm -v $(pwd):/src <image> bashate --ignore E006 script.sh
docker run --rm -v $(pwd):/src <image> bashate --config .bashaterc script.sh
```

### Lint a Dockerfile with hadolint

```bash
docker run --rm -v $(pwd):/src <image> hadolint Dockerfile
docker run --rm -v $(pwd):/src <image> hadolint --ignore DL3008 Dockerfile
docker run --rm -v $(pwd):/src <image> hadolint --config .hadolint.yaml Dockerfile
```

### Liant a YAML file with yamllint

```bash
docker run --rm -v $(pwd):/src <image> yamllint config.yaml
docker run --rm -v $(pwd):/src <image> yamllint --strict config.yaml
docker run --rm -v $(pwd):/src <image> yamllint --config custom-yamllint.yaml config.yaml   
```

### Lint a Markdown file with markdownlint

```bash
docker run --rm -v $(pwd):/src <image> markdownlint README.md
docker run --rm -v $(pwd):/src <image> markdownlint --ignore MD013 README.md
docker run --rm -v $(pwd):/src <image> markdownlint --config custom-md.json README.md
```

### Show Tool Versions

```bash
docker run --rm <image> version
```

### Display Help

```bash
docker run --rm <image> help
```
