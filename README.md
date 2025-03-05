# Upcloud & Doom

This is a solution for running the original [Doom](https://cs.wikipedia.org/wiki/Doom) game on a Kubernetes cluster on [UpCloud](https://upcloud.com/). The solution involves building a Docker image that runs the game (along with a virtual X server and VNC or noVNC for remote access), pushing the image to a registry, and then deploying it via Kubernetes.

> [!TIP]
> The repo has been put together as a demonstration of the process and is not intended for production use. I know you can deploy the game i.e. directly on the UpCloud managed server, but where is the fun in that.
> You can adapt the approach for any retro open source game if you prefer or use it as a enjoyable starter with the running game at the end before you dive into your kubernetes deployment.

## Prerequisites

- [UpCloud account](https://upcloud.com/) charged with at least 10 EUR to enable kubernetes pods
- [Docker](https://docs.docker.com/get-docker/) installed
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed

## Getting Started

- Clone the repo

```sh
git clone github.com/Simply007/upcloud-doom

## Build from scratch

- Analysis
  The solution involves building a Docker image that runs the game (along with a virtual X server and VNC or noVNC for remote access), pushing the image to a registry, and then deploying it via Kubernetes. You can adapt the approach for any retro open source game if you prefer.
- choose Chocolate Doom and read through the setup

Chocolate Doom is an open source port of the original Doom engine. Because Doom is a graphical game, you’ll need a way to run it headlessly on a server and view its output remotely. One common approach is to use a virtual framebuffer (using Xvfb) and serve the display via a VNC server or a browser-based solution like noVNC.

Pick a WAD see [Gotchas](#gotchas) for more info.

- build a Docker image

put together a Dockerfile that installs Chocolate Doom, Xvfb, and a VNC server.

see [Dockerfile](./Dockerfile) 

```sh
# docker build -t simply007/chocolate-doom:latest . # only linux/arm64/v8
docker buildx build --platform linux/amd64,linux/arm64 -t simply007/chocolate-doom:latest .
```

- Push the image to a registry

```sh
docker push simply007/chocolate-doom:latest
```

- The solution is based on the assumption that you have a Kubernetes cluster running on UpCloud. If you don’t have one, you can follow the instructions in the [UpCloud Kubernetes guide](https://upcloud.com/community/tutorials/get-started-kubernetes/).

- deploy the image via Kubernetes

```sh
kubectl apply -f deployment.yaml
```

- analyze the process

```sh
kubectl get pods
kubectl describe pod chocolate-doom-5495bff8d6-cdhsr
kubectl get svc chocolate-doom-service # or  kubectl get services -w
```

- expose the service

- test the service

- clean up

## Use existing image



## Handy commands

## Gotchas

During the process, I encountered a few fails that you might want to be aware of:

### upctl vs kubectl

UpCloud provides a CLI for all of the

- `upctl` is being treatherd as a typo (kubectl) - this can be handled by sending the inquiry to google (had thew same with Kontent keyword)
- mention export `KUBECONFIG=$(pwd)/doom-dev_kubeconfig.yaml`

### UpCloud trial restrictions

- pushing on kubernetes: Kubernetes pods are currently disabled during trial. Please contact UpCloud support, or make a one-time payment of €10 or more to remove trial account restrictions.

### Docker platform and buildx

- issue without getting the image from the dockerhub `Failed to pull image "simply007/chocolate-doom:latest": failed to pull and unpack image "docker.io/simply007/chocolate-doom:latest": failed to resolve reference "docker.io/simply007/chocolate-doom:latest": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed` => I build it on MAC, but the cluster on UpcLoud is accepting amd64 => so I needed to make a multiarch build

### Doom alternatives

- couls have used any prepared image from dockerhub (i.e. https://hub.docker.com/r/mattipaksula/http-doom), but that would cut out the the path and talking points

findind the WAD file - I did not want to use the original WAD file, so I needed to find a free one - I found one on https://freedoom.github.io/download.html. Some of the alternatives were not compatible, or license was not permissii

### Managed Kubernetes vs. self-hosted

- Error from server: Get "https://10.0.0.2:10250/containerLogs/default/chocolate-doom-54fdbbd57f-spxlf/chocolate-doom": No agent available -> most of the time when getting logs, running commands

### Game setup

- WEBSOCKET DID NOT WORK ON OTHER PORT THAN 80 - so using other port for noVNC was not possible - I dod not investigate further
- sound bug -> MIDI player not configured - the sound and it's setting were hard to configure and digging deeper on the MIDI player was worth a hustle for this showcase, but deffinitely something to consider when you want to stream any sound
- keyboard binding overrides - when you have your keyboard setup as usin control + arrow up to display Mission COntrol and want got upfronr and shoot - guess what happened ? :-)
- The startup of the service can lead to the state that not everythin is up and running on time - to overcome that and start with some MVP and keep the flow running I pimped the Dockerfile with a couple of sleep commands. Of course - this is something I would come back to and identify where and for what should I use for the readiness

## References

- [Chocolate Doom](https://www.chocolate-doom.org/)
- [Doom](<https://en.wikipedia.org/wiki/Doom_(1993_video_game)>)
- [Xvfb](https://www.x.org/releases)
- [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing)
- [noVNC](https://novnc.com/info.html)
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)
