## Bonvin Lab VM Repository

This repository contains all the code and images used in our educational VM. It
is intended to serve a fully-functional up-to-date copy of the VM image both for
developers and end-users.

### Requirements
* [VirtualBox 5.0+](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)
* [Git](https://git-scm.com/)
* 2-8 GB of hard disk space, depending on usage
* An active internet connection

### Quick Start
```bash
git clone https://github.com/haddocking/molmod
cd molmod
# Edit the VagrantFile to:
#    * enable GUI: change 'vb.gui' to 'true'
#    * enable/disable specific provisioners
vagrant up
# Wait for all the provisioners to finish
# This might take a while.
vagrant ssh
su -l haddocker # password 'haddock'
# Have fun!
```

### For Users
Download and install both Virtualbox and Vagrant. Make sure to install the Virtualbox Extension Pack as well. Clone this repository to a directory of your liking.

```bash
git clone https://github.com/haddocking/molmod
cd molmod
```

Edit the VagrantFile to enable the GUI and toggle specific provisioners by commenting their lines. Each provisioner installs software for a particular teaching module: Homology Modelling, Molecular Dynamics, or Docking. Edit the number of CPUs and memory available to the VM according to your laptop/desktop specifications. This might have an impact in the performance of the virtual machine. 

If you want to use MODELLER, please head over to the [web page](https://salilab.org/modeller) and obtain a license key. Paste this license key in the `molmod/assets/config/modeller.key` file so that the provisioning scripts can access it.

When you are ready, fire up vagrant, wait for the box to be downloaded (if necessary) and for the provisioners to finish and then login as the haddocker user.

```bash
vagrant up
# Wait
vagrant ssh
su -l haddocker # password haddock
```

If for some reason you need to re-run the provisioning scripts (e.g. you forgot the MODELLER key the first time), just run `vagrant provision` on your host machine, i.e., not in the virtual machine terminal session. To run only a particular provisioning script (e.g. homology modelling) try `vagrant provision --provision-with Module_HM`.

### For Developers
#### Installation
The recommended usage is to download and install [Vagrant]((https://www.vagrantup.com/)),
clone this repository, and run `vagrant up`. The provisioning scripts will setup the
environment and download all the required software & data. Once completed, you can login
to the machine using `vagrant ssh`. The default user and password is 'vagrant'. Do not change
it if you intend to re-use vagrant. This user also has administrator rights. To make use of the
course content and its settings, login as the 'haddocker' user (password: haddock).

Since the entire provisioning process takes ~20 minutes (mostly to compile GROMACS), the
machine will start a user session before all the software is installed. Take a break, go
for a coffee, or go for a walk. When all the provisioning is done, you can start using the machine.

```bash
git clone https://github.com/haddocking/molmod
cd molmod
vagrant up
```

By default, the VM GUI is turned off. To enable it, change the `vb.gui` setting on the
VagrantFile (~ line 48) to `true` *before* running `vagrant up`. You can also edit other
VM settings on the VagrantFile, namely the available memory and number of CPUs. Do __not__
activate 3D acceleration: PyMOL will stop working properly. If you want to speed up the
provisioning, comment whatever provisioners you are willing to sacrifice. We recommend you
leave always the _main_ provisioner active as this sets up a number of things for the haddocker
user and generally takes care of the image (updates, etc).

#### Shared Folders
Vagrant automatically sets up the folder containing the VagrantFile as a shared folder and
mounts it under `/vagrant` inside the image. This is extremely handy to develop scripts and
whatnot, so use it and abuse it. If you need more shared folders, read the VagrantFile and
the Documentation; there is also an easy way of setting them up automatically.

#### Usage
For a complete list of the available commands and their descriptions, read the [Vagrant Documentation](http://docs.vagrantup.com/v2/).

This VM works just like any other VirtualBox image. Opening the VirtualBox application after
running `vagrant up` will show the newly created machine. Starting with version 5.0, VirtualBox
allows connections to a running (headless) machine, but any version will allow any sort of
control over the machine, e.g. stopping, deleting, exporting.

Importantly, when running `vagrant up` for the first time, what is called the Vagrant box,
the machine image and hard drive, will be downloaded to specific folder. This will be copied
to wherever necessary to create a new machine. So, even if all machines are destroyed, there
will still be a copy of this image lying around.

Nonetheless, if you prefer to use Vagrant to manage the machine:
* `vagrant ssh`: connects to the machine via SSH.
* `vagrant reload (--provision)`: restarts the machine (and re-runs the provisioners).
* `vagrant suspend`: saves the current machine state and stops execution.
* `vagrant resume`: restarts a machine from the last saved state.
* `vagrant halt`: shutdown the machine.
* `vagrant destroy`: shutdown and _delete_ the machine.
* `vagrant box list`: list all the installed boxes (e.g. courseVM).
* `vagrant box remove <box name>`: removes a particular box permanently.

#### Technical details
The virtual image is built on a Lubuntu 10.04 GNU/Linux system. The system is old
and __needs to be old__ because Pymol, VirtualBox, and OpenGL do not play well with each
other in newer versions of Ubuntu (more specifically, the mesa libraries). PyMOL is
installed by default in the base box to keep it at a certain version as well. Newer
versions likely use other OpenGL calls and cause problems. As of (XL)Ubuntu 15.10
and VirtualBox 5.0, these problems remain.
