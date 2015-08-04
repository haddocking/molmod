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
clone this repository, and run `vagrant up`. The provisioning scripts will setup the
environment and download all the required software & data. Feel free to edit the VM settings
on the VagrantFile, namely memory and number of CPUs, to increase overall performance.

Since the entire provisioning process takes ~20 minutes (mostly to compile GROMACS), the
machine will start a user session before all the software is installed. Take a break, go
for a coffee or for a walk. When all the provisioning is done, you can start using the machine.

```bash
git clone https://github.com/haddocking/haddockVM
cd haddockVM
vagrant up
```

By default, the VM GUI is turned off. To enable it, change the `vb.gui` setting on the
VagrantFile (~ line 48) to `true` *before* running `vagrant up`:

```ruby
  vb.gui = true
```

### Technical details
The virtual image is built on a Lubuntu 10.04 GNU/Linux system. The system is old
and __needs to be old__ because Pymol, VirtualBox, and OpenGL do not play well with each
other in newer versions of Ubuntu (more specifically, the mesa libraries). PyMOL is
installed by default in the base box to keep it at a certain version as well. Newer
versions likely use other OpenGL calls and cause problems. As of (XL)Ubuntu 15.10
and VirtualBox 5.0, the mesa problems remain.
