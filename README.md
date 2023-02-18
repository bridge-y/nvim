# Neovim configuration

This repository is my own configuration of Neovim based on [dope](https://github.com/glepnir/dope).

## Usage

The following command will link this repository to $HOME/.config/nvim.

```shell
sh install
```

## How to work with Devcontainer

This repository is intended to use Neovim with devcontainer.

I have prepared the following two methods.

1. [devcontainer cli](https://github.com/devcontainers/cli)

   This method uses devcontainer cli.
   In this way, devcontainers features can be used.

   - Install this repository locally.
   - Copy .devcontainer directory to your project.
   - If necessary, add the appropriate [devcontainers features](https://github.com/devcontainers/features) for your project to devcontainer.json

     - For example: Python

       ```json
       "features": {
            // add the following to devcontainer.json
           "ghcr.io/devcontainers/features/python:1": {}
       }
       ```

   - Execute the following command.  
     This command mounts $HOME/.config/nvim to the container and logs into the container via ssh.  
     The directory immediately after login is /workspaces, so you need to move to the project directory.

     ```shell
     sh .devcontainer/start.sh
     ```

2. [Open Devcontainer](https://gitlab.com/smoores/open-devcontainer)

   This method uses Open Devcontainer.  
   Open Devcontainer implements useful features not found in the devcontainer cli, such as SSH and GPG forwarding.

   - Create Dockerfile and devcontainer.json for your project.
   - Execute `odc run --dotfiles-repo <url of this repository>`

There is another way to use the [nvim-dev-container](https://github.com/esensar/nvim-dev-container) plugin, but it did not work in my environment.

## Notes

- `dope` command does not work correctly.
