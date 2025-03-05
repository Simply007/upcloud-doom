# Upcloud & Doom

This repository showcases 

# Getting Started



## Notes

* The solution is based on the assumption that you have a Kubernetes cluster running on UpCloud. If you don’t have one, you can follow the instructions in the [UpCloud Kubernetes guide](https://upcloud.com/community/tutorials/get-started-kubernetes/).
* The solution uses a Docker image to run the game. If you don’t have Docker installed, you can follow the instructions in the [Docker installation guide](https://docs.docker.com/get-docker/).
* `upctl` is being treatherd as a typo (kubectl) - this can be handled by sending the inquiry to google (had thew same with Kontent keyword)
* pushing on kubernetes: Kubernetes pods are currently disabled during trial. Please contact UpCloud support, or make a one-time payment of €10 or more to remove trial account restrictions.
* issue without getting the image from the dockerhub `Failed to pull image "simply007/chocolate-doom:latest": failed to pull and unpack image "docker.io/simply007/chocolate-doom:latest": failed to resolve reference "docker.io/simply007/chocolate-doom:latest": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed` => I build it on MAC, but the cluster on UpcLoud is accepting amd64 => so I needed to make a multiarch build 
* couls have used any prepared image from dockerhub (i.e. https://hub.docker.com/r/mattipaksula/http-doom), but that would cut out the the path and talking points


## Process

* Analysis
The solution involves building a Docker image that runs the game (along with a virtual X server and VNC or noVNC for remote access), pushing the image to a registry, and then deploying it via Kubernetes. You can adapt the approach for any retro open source game if you prefer.

¨
* choose Chocolate Doom and read through the setup

Chocolate Doom is an open source port of the original Doom engine. Because Doom is a graphical game, you’ll need a way to run it headlessly on a server and view its output remotely. One common approach is to use a virtual framebuffer (using Xvfb) and serve the display via a VNC server or a browser-based solution like noVNC.

* build a Docker image

put together a Dockerfile that installs Chocolate Doom, Xvfb, and a VNC server.
Then adjust with a couple of sleep commands to keep the flow running and do not waste time to identify where and for what should I use for the readiness

```sh
# docker build -t simply007/chocolate-doom:latest . # only linux/arm64/v8
docker buildx build --platform linux/amd64,linux/arm64 -t simply007/chocolate-doom:latest .

```

* push the image to a registry

```sh
docker push simply007/chocolate-doom:latest
```

* deploy the image via Kubernetes



* analyze the process

```sh
kubectl get pods
kubectl describe pod chocolate-doom-5495bff8d6-cdhsr      
kubectl get svc chocolate-doom-service 
```


* expose the service

* test the service

* clean up

## References

* [Chocolate Doom](https://www.chocolate-doom.org/)
* [Doom](https://en.wikipedia.org/wiki/Doom_(1993_video_game))
* [Xvfb](https://www.x.org/releases)
* [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing)
* [noVNC](https://novnc.com/info.html)
* [Docker](https://www.docker.com/)
* [Kubernetes](https://kubernetes.io/)

