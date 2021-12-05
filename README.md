# Devspace

---

**WARNING**: This specific Dockerfile is an opinionated setup and also contains values unique to me, so this is not something anybody should use as their daily driver, but a source of inspiration for how to create your own `devspace`. Also, this is for terminal users (`emacs`, `neovim` etc.), so if you are a Visual Studio Code user or any other GUI based IDE, this is not for you (or at least would require some serious adaption).

---

I like to separate my setup based on the specific task. I do this both to ensure that each project has its own clean setup, where something I do to accommodate something in project A does not end up affecting something in project B. I also do this for security reasons, so any vulnerabilities that arises in a project has a smaller chance affect the rest of the system.

To do this I have created a dockerized version of my development machine which I use when I work on any project.

This approach is still a work in progress but at the time of writing my workflow is as follows

## Usage

**Setup**

I create a `docker-compose.yml` file inside a `.devspace` folder in the project (which I have added to my global git ignore) with a `devspace` container where I mount the current project directory (`..`), and add any services that specific project needs. I would usually set the image of `devspace` to `ghcr.io/morten-olsen/devspace`, but for more complex projects that requires additional tools added to my dev space I also add a `Dockerfile` inside the `.devspace` folder and use the `build` prop inside `docker-compose` instead of the image.

See [the example](./.devspace) for an advanced example with an extended docker file and a Redis service

**Running**

Start the development environment using `docker-compose -f .devspace/docker-compose.yml up -d`, and enter the development environment with `docker-compose -f .devspace/docker-compose.yml exec devspace /bin/zsh`. Once I'm done I run `docker-compose -f .devspace/docker-compose.yml down` to shut the development environment down.

The same approach can de used for pulling, building and running one of containers for specific tasks

To simplify these commands I have added a [bash script](./devspace) with the commands I use (`up`, `down`, `enter`, `run` and `update`).

If you have cloned this repo you can try to run `./devspace up`, `./devspace enter`, `redis-cli -h redis` to create the development environment, enter it and connect to the redis service. After you are down type `exit` to exit out of the session and then `./devspace down` to remove the environment.

__Pro tip__: Since `devspace` depends on `redis` you can also do `./devspace run redis-cli -h redis`

## Your own `devspace`

The easiest way to get started is to fork this project and change the content of the `Dockerfile`. GitHub Actions inside `./github/workflows` will automatically build and release your custom `devspace` as `ghcr.io/{your-github-name}/devspace:main`

Be aware that the current `Dockerfile` has some tests inside `./scripts/test.sh`. You should either exclude those from the `Dockerfile` or update them to reflect your setup.

## Extra security

This allows you to run your daily workflow inside the safety of a container, but one extra thing I have done to increase the security is to not expose any `gpg`/`git` information to the containers (or any other non-essential information). This means that I have to do git commits (as I use `gpg` signing), pull and pushes from outside the container, so no rogue dependency or RAT infested dev server can gain access to those secrets.
