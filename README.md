## Requirements
- [just](https://github.com/casey/just)
- [docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/install/)
- [git](https://git-scm.com/install)
## Usage
- ```just init``` - clone __REPO_URL__ into the workspace as submodule.
- ```just build``` - build docker container with the workspace attached as volume.
- ```just login``` - login into the container under your username.
- ```just restart``` - restart the container after e.g. computer restart.
