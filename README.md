# docker-phpvirtualbox

[phpVirtualBox](http://sourceforge.net/projects/phpvirtualbox/) is a modern, cross-platform, distributed IRC program,
where multiple clients can attach to and detach from a central core.
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

The recommended way to run this container looks like this:

```bash
$ docker run -d --link vb1:MyComputer -p 80:80 clue/phpvirtualbox
```
