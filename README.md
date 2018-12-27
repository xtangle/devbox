# devbox

This repository contains the Vagrant configuration to set up a local Ubuntu-based development Virtual Machine.
The guest machine runs on [Ubuntu 18.04.1 LTS (Bionic Beaver)](http://releases.ubuntu.com/18.04.1/) with a core minimal
[Lubuntu](https://lubuntu.net/) desktop environment. It uses the official [ubuntu/bionic64](https://app.vagrantup.com/ubuntu/boxes/bionic64) box 
from Ubuntu Cloud Images as the base image.

## What's Installed?

In addition to the default software bundled with Ubuntu, the provisioning process installs the latest versions of the following:

Software:

- [Lubuntu Desktop Core](https://packages.ubuntu.com/bionic/lubuntu-core)
- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Input Fonts](http://input.fontbureau.com/)
- [Tilda](https://github.com/lanoxx/tilda)
- [Postman](https://www.getpostman.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [Sublime Text](https://www.sublimetext.com/)
- [IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/)
- [Visual Studio Code](https://code.visualstudio.com/)

Programming Languages:

- [OpenJDK](https://openjdk.java.net/)
- [Maven](https://maven.apache.org/)
- [Nvm](https://github.com/creationix/nvm)
- [Ruby](https://www.ruby-lang.org/en/)
- [Scala (Sbt)](https://www.scala-sbt.org/)
- [Kotlin](https://kotlinlang.org/)
- [Go](https://golang.org/)
- [Haskell](https://www.haskell.org/)

## Prerequisites

- A host machine running on Windows.
- [Vagrant 2.0.0+](https://www.vagrantup.com/downloads.html) installed.
- [VirtualBox 5.2.0+](https://www.virtualbox.org/wiki/Downloads) with the Extension Pack installed.
- VBoxManage.exe exists in the folder `C:\Program Files\Oracle\VirtualBox`.
   - This should already be the case if VirtualBox is installed using the default settings.
- Ability to create symbolic links inside shared folders, see [instructions](#Enable creation of symlinks on shared folders) below.

## Getting Started

1. Ensure all prerequisites have been met (see previous section).
1. Clone this repo to a directory where you store all your coding projects. 
   - A shared folder will be created linking this directory from the host machine to `${HOME}/Projects` in the guest machine. 
1. Run the command `vagrant up` from the directory of the cloned repository and answer the questions to the interactive prompts.
   - Your answers will be saved in the `.vm-config.yaml` file. They will be used in future Vagrant commands unless the configuration file is outdated or deleted.
   - One of the questions asks to provide a user-specific provisioning script. This is an optional shell script that runs on the guest machine after all other provisioning is finished. 
   - To force to re-configure your VM, either rename or delete the `.vm-config.yaml` file.

## Enable creation of symlinks on shared folders

By default, only administrators on Windows machines are able to create symbolic links. To add your user, follow these steps:

1. Download the tool [Polsedit](http://www.southsoftware.com/) and extract it locally.
1. Open the .exe file in the extracted folder, and add your user to the policy named 'Create symbolic links'.
1. Restart your computer.
