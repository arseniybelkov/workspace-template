REPO_URL := "SOME"

DEFAULT_PROJECT_NAME := file_stem(REPO_URL)
DEFAULT_CONTAINER_NAME := DEFAULT_PROJECT_NAME + "-" + "workspace"

DEFAULT_HOST_WORKSPACE_DIR := justfile_directory()
DEFAULT_CONTAINER_WORKSPACE_DIR := "/workspace"
DEFAULT_CONTAINER_BASHRC_PATH := DEFAULT_CONTAINER_WORKSPACE_DIR / "image" / "bashrc"
DEFAULT_DOCKER_COMPOSE_PATH := DEFAULT_HOST_WORKSPACE_DIR / "image" / "docker-compose.yml"
DEFAULT_HOST_BASHRC_PATH := DEFAULT_HOST_WORKSPACE_DIR / "image" / "bashrc"

DEFAULT_GROUP_ID := just_pid()
DEFAULT_USER := env("USER", "ubuntu")
DEFAULT_USER_ID := env("EUID", "12345")

export COMPOSE_PROJECT_NAME := file_stem(DEFAULT_HOST_WORKSPACE_DIR)

[private]
default:
    just --list

alias i := init
alias b := build
alias l := login
alias r := restart

# Should be called only after cloning the *-workspace repo.
# Attaches target repo as a submodule and pulls it.
init:
    git submodule add {{REPO_URL}}
    git submodule update --init
    git status

# Rebuild the docker image.
build container=DEFAULT_CONTAINER_NAME workspace=DEFAULT_HOST_WORKSPACE_DIR:
    just compose_config {{container}} {{workspace}} {{DEFAULT_DOCKER_COMPOSE_PATH}}
    just compose_build {{container}} {{workspace}} {{DEFAULT_DOCKER_COMPOSE_PATH}}
    just compose_add_group {{container}} {{DEFAULT_GROUP_ID}}
    just compose_add_user {{container}} {{DEFAULT_GROUP_ID}} {{DEFAULT_USER}} {{DEFAULT_USER_ID}}
    just compose_change_owner {{container}} {{DEFAULT_USER}} {{DEFAULT_CONTAINER_WORKSPACE_DIR}}

# Login into linux container under non-root user.
login container=DEFAULT_CONTAINER_NAME user_id=DEFAULT_USER_ID group_id=DEFAULT_GROUP_ID bashrc_path=DEFAULT_CONTAINER_BASHRC_PATH:
    docker exec -it --user {{user_id}}:{{group_id}} \
    --env REPO_NAME {{container}} /bin/bash --rcfile {{bashrc_path}}

# Restart the container after it has been stopped.
restart container=DEFAULT_CONTAINER_NAME workspace=DEFAULT_HOST_WORKSPACE_DIR:
    just compose_config {{container}} {{workspace}} {{DEFAULT_DOCKER_COMPOSE_PATH}}
    just compose_restart {{container}} {{workspace}} {{DEFAULT_DOCKER_COMPOSE_PATH}}

[private]
compose_config container host_workspace_dir docker_compose_path:
    export HOST_WORKSPACE_DIR={{host_workspace_dir}} && export CONTAINER_NAME={{container}} && \
    docker compose -f {{docker_compose_path}} up -d

[private]
compose_build container host_workspace_dir docker_compose_path:
    export HOST_WORKSPACE_DIR={{host_workspace_dir}} && export CONTAINER_NAME={{container}} && \
    docker compose -f {{docker_compose_path}} up -d --build --force-recreate

[private]
compose_add_group container group_id:
    docker exec -it {{container}} groupadd -g {{group_id}} grp

[private]
compose_add_user container group_id user user_id:
    docker exec -it {{container}} useradd -u {{user_id}} -g {{group_id}} -m {{user}}

[private]
compose_change_owner container user container_workspace_dir:
    docker exec -it {{container}} chown -R {{user}} {{container_workspace_dir / DEFAULT_PROJECT_NAME}}

[private]
compose_restart container host_workspace_dir docker_compose_path:
    export HOST_WORKSPACE_DIR={{host_workspace_dir}} && export CONTAINER_NAME={{container}} && \
    docker compose -f {{docker_compose_path}} up -d
