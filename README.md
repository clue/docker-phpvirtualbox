# docker-phpvirtualbox

[phpVirtualBox](http://sourceforge.net/projects/phpvirtualbox/) is a modern web interface that allows
you to control remote VirtualBox instances - mirroring the VirtualBox GUI.
This is a [docker](https://www.docker.io) image that eases setup.

## About phpVirtualBox

> *From [the official description](http://sourceforge.net/projects/phpvirtualbox/):*

An open source, AJAX implementation of the VirtualBox user interface written in PHP.
As a modern web interface, it allows you to access and control remote VirtualBox instances.
phpVirtualBox is designed to allow users to administer VirtualBox in a headless
environment - mirroring the VirtualBox GUI through its web interface.

![](http://a.fsdn.com/con/app/proj/phpvirtualbox/screenshots/phpvb1.png)

## Usage

This docker image is available as a [trusted build on the docker index](https://index.docker.io/u/clue/phpvirtualbox/).
Using this image for the first time will start a download automatically.
Further runs will be immediate, as the image will be cached locally.

This image provides the phpVirtualBox web interface that communicates with any
number of VirtualBox installations on your computers.

![](https://cloud.githubusercontent.com/assets/776829/3137332/d8500a54-e850-11e3-921d-479d43c9c80a.png)

As per the above diagram the following examples assume we have two computers `PC2` and `PC3`
in our cluster that we want to manage through a single installation of phpVirtualBox.

Applying the same scheme to any number of computers running Virtualbox should be fairly straight forward.
Also, the same scheme applies if you only want to manage a single PC, which hosts both VirtualBox and
this image.

Internally, the phpVirtualBox web interface communicates with each VirtualBox installation through the
`vboxwebsrv` program that is installed as part of VirtualBox.
So for every computer connected to the phpVirtualbox instance, we're going to use minimal container
that eases exposing the `vboxwebsrv`.

For PC2:

```bash
$ docker run -it --name=vb2 clue/vboxwebsrv vbox@10.1.1.2
```

And for PC3:

```bash
$ docker run -it --name=vb3 clue/vboxwebsrv myuser@10.1.1.3
```

This will start an interactive container that will establish a connection to the given host.
To establish an encrypted SSH connection it will likely ask for your password for each user. This is the user that runs your virtual machines (VMs). See [clue/vboxwebsrv](https://github.com/clue/vboxwebsrv) for more details.

> Some background: The official readme describes setting up the `vboxwebsrv` daemon so
> that it is automatically started when the machine boots up and is exposed over the network.
> Instead of requiring this upfront configuration, we only spawn the `vboxwebsrv` on demand
> and expose its socket only through an encrypted SSH tunnel.

Now that all `vboxwebsrv` instance are up, we can link everything together and start our actual phpVirtualBox container.
The recommended way to run this container looks like this:

```bash
$ docker run -d --link vb2:FirstPC --link vb3:MyLaptop -p 80:80 clue/phpvirtualbox
```

You can now point your webbrowser to this URL:

```
http://localhost
```

This is a rather common setup following docker's conventions:

* `-d` will run a detached session running in the background
* `-p {OutsidePort}:80` will bind the webserver to the given outside port
* `--link {ContainerName}:{DisplayName}` links a `vboxwebsrv` instance with the given {ContainerName} and exposes it under the visual {DisplayName}
* `clue/phpvirtualbox` the name of this docker image
