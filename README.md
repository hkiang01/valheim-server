# Valheim Server

A secure, non-root docker compose service running a Valheim dedicated server

<img src="./valheim-shield.png" width="250" height="250" />

- [Valheim Server](#valheim-server)
  - [Motive](#motive)
    - [Compared with lloesche/valheim-server](#compared-with-lloeschevalheim-server)
  - [Getting started](#getting-started)
    - [Docker Compose](#docker-compose)
    - [Kubernetes](#kubernetes)
  - [Customizing server options](#customizing-server-options)
  - [Known limitations](#known-limitations)


## Motive

Built with security in mind:
- non-root user for all images
- minimal packges installed on valheim image
- separate image for installation and update that runs for a short period of time
  - steamcmd requires a lot of packages containing vulnerabilities

### Compared with lloesche/valheim-server

The default user for lloesche/valheim-server is `root`.

  ```bash
  docker run -it --rm --entrypoint="" lloesche/valheim-server id
  uid=0(root) gid=0(root) groups=0(root)
  ```

See [Processes In Containers Should Not Run As Root](https://medium.com/@mccode/processes-in-containers-should-not-run-as-root-2feae3f0df3b).

While you can set [`PGID` and `PUID`](https://github.com/lloesche/valheim-server-docker/blob/0996dc3a1fc1f5f88bcbd4056a28254adadb884e/Dockerfile#L100) when building the container, we're still left with an image with many vulnerabilities. The valheim image in the valheim docker compose service has *significantly* fewer vulnerabilities.
Note the `trivy image` results below:

  From `trivy image lloesche/valheim-server`:
  ```
  lloesche/valheim-server (debian 11.9)
  =====================================
  Total: 1007 (UNKNOWN: 5, LOW: 276, MEDIUM: 590, HIGH: 127, CRITICAL: 9)
  ```

  From `trivy image valheim`:
  ```
  valheim (ubuntu 24.04)

  Total: 12 (UNKNOWN: 0, LOW: 10, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
  ```

## Getting started

### Docker Compose

If you're using the [Public Test Branch](https://steamcommunity.com/app/892970/discussions/0/3589961352692129408/), be sure to set the `PUBLIC_TEST` environment variable in the `installupdate` service to `true`.

1. Spin up the service. Make sure you have [Docker](https://docs.docker.com/get-docker/) installed.

    ```zsh
    docker compose up --build --detach
    ```

2. (Optional) If you have an existing save, copy it into the `valheim` service's `worlds_local` directory.

    ```zsh
    docker compose cp <my_server.db> /home/steam/.config/unity3d/IronGate/Valheim/worlds_local/
    docker compose cp <my_server.fwl> /home/steam/.config/unity3d/IronGate/Valheim/worlds_local/
    docker compose restart
    ```

### Kubernetes

These images are able to run under the `Restricted` [Pod Security Standard](https://kubernetes.io/docs/concepts/security/pod-security-standards/).
See [kubernetes.yaml](./kubernetes.yaml) as an example.

1. Update the server config as desired (env vars in [kubernetes.yaml](./kubernetes.yaml), [start_server.sh](./start_server.sh), etc.)
2. Build the images and push them to your choice of registry
3. Change the `image`s in [kubernetes.yaml](./kubernetes.yaml) to align with your image registry
4. `kubectl apply -f ./kubernetes.yaml`

## Customizing server options

Edit [start_server.sh](./start_server.sh) as you see fit.
See "List of Console Commands" at https://www.valheimgame.com/support/a-guide-to-dedicated-servers/ for more options.
If needed, edit the entrypoint/cmd of the `valheim` service.


## Known limitations
- Does not work on Apple Silicon
  - A Segmentation fault in the `steamcmd` image will result.
