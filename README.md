## Bonvin Lab VM Repository

This repository contains all the code and images used in our educational VM. It
is intended to serve a fully-functional up-to-date copy of the VM image both for
developers and end-users.

### Requirements
* [Vagrant]((https://www.vagrantup.com/))
* [Git](https://git-scm.com/)
* 2-8 GB of hard disk space, depending on usage
* An active internet connection

### Usage
The recommended usage is to download and install [Vagrant]((https://www.vagrantup.com/)),
clone this repository, and run `vagrant up`. The provisioning scripts will
setup the environment and download all the required software & data.

```bash
git clone https://github.com/haddocking/haddockVM
cd haddockVM
vagrant up
```

### Technical details
The virtual image is built on a Lubuntu 10.04 GNU/Linux system. The system is old
and needs to be old because Pymol, VirtualBox, and OpenGL do not play well with each
other in newer versions of Ubuntu (more specifically, libgl1-mesa-dri). PyMOL is
installed by default to keep it at a certain version as well. Newer versions likely
use other OpenGL calls and cause problems.
