# devbox

[![Build Status](https://img.shields.io/travis/com/xtangle/devbox.svg)](https://travis-ci.com/xtangle/devbox)

This repository contains Vagrantfile and scripts to set up a local development Virtual Machine running in Linux.
The machine runs on a bare-bones [Ubuntu 19.10 (Eoan Ermine)](http://releases.ubuntu.com/19.10/) distro with a minimal
[KDE Plasma](https://kde.org/plasma-desktop) desktop environment. It uses the official vagrant box 
from Ubuntu Cloud Images as the base image.

## What's Installed?

In addition to the default software bundled with KDE Plasma desktop, the provisioning process installs the latest versions of the following software:

Applications:

- [Git](https://git-scm.com/)
- [Docker & Docker Compose](https://www.docker.com/)
- [IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Sublime Text](https://www.sublimetext.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/)
- [Confluent Platform](https://www.confluent.io/product/confluent-platform/)
- [Tilda](https://github.com/lanoxx/tilda)
- [Postman](https://www.getpostman.com/)
- [LibreOffice](https://www.libreoffice.org/)
- [Evince](https://wiki.gnome.org/Apps/Evince)
- [Viewnior](http://siyanpanayotov.com/project/viewnior)
- [Meld](http://meldmerge.org/)
- [DBeaver CE](https://dbeaver.io/)
- [TeXstudio](https://www.texstudio.org/)
- [Remmina](https://remmina.org/)
- Additional system fonts: [Input](http://input.fontbureau.com/), 
    [Hack](https://sourcefoundry.org/hack/), and [Roboto](https://fonts.google.com/specimen/Roboto)

Programming languages and tools:

- [Nvm](https://github.com/creationix/nvm) (with latest version of [Node.js](https://nodejs.org) and [npm](https://www.npmjs.com/))
- [Yarn](https://yarnpkg.com/en/)
- [OpenJDK](https://openjdk.java.net/)
- [Maven](https://maven.apache.org/)
- [Clojure](https://clojure.org/) [(Leiningen)](https://leiningen.org/)
- [Python 3](https://www.python.org/)
- [Ruby](https://www.ruby-lang.org/en/)
- [Scala](https://www.scala-lang.org/) [(Sbt)](https://www.scala-sbt.org/)
- [Kotlin](https://kotlinlang.org/)
- [Go](https://golang.org/)
- [Haskell](https://www.haskell.org/) (with [Stack](https://docs.haskellstack.org/en/stable/README/))
- [Rust](https://www.rust-lang.org/)
- [Erlang](https://www.erlang.org/)
- [Elixir](https://elixir-lang.org/)
- [LaTeX](https://www.latex-project.org/) (via [TeX Live](https://www.tug.org/texlive/))

All listed software will be upgraded to their most recent version as part of the provisioning process:
    `vagrant up --provision`

## Prerequisites

- [Vagrant 2.0.0+](https://www.vagrantup.com/downloads.html) installed.
- [VirtualBox 6.0.0+](https://www.virtualbox.org/wiki/Downloads) with the Extension Pack installed.
- VBoxManage is installed
    - This should already be the case if VirtualBox is installed using the default settings.
    - On Windows, the file `C:\Program Files\Oracle\VirtualBox\VBoxManage.exe` should already exist. Otherwise, `VBoxManage.exe` should be part of the PATH.
    - On Linux or Mac, the command `vboxmanage` should to be in your PATH.
- Additionally, the host user should have the ability to create symbolic links inside shared folders, see [instructions](#enable-creation-of-symlinks-in-shared-folders) below. This should only be relevant on a Windows host machine.

## Getting Started

1. Ensure all prerequisites have been met (see previous section).
1. Clone this repo to your host machine.  
1. Run the command `vagrant up --provision` from the directory of the cloned repository. 
    - Answer the interactive questions as they come up.
    - Responses to the answers will be saved in the `.vm-config.yaml` file. This configuration file will be used in future provisions unless it is either outdated or deleted. 
    - Tip: to force prompting the configuration again, either rename or delete the `.vm-config.yaml` file.
1. Review the contents in `.vm-config.yaml` file. You will notice there will be a couple of extra properties there that were not asked, 
    such as `extra_mounts` and `external_steps`. You have the option to configure them now by editing the file directly. They are covered in detail in the [VM Configs](#vm-configs) section.
1. Run the command `vagrant up --provision` again. This time, you will not be asked to provide the configuration again.
    - Provisioning will now begin. A summary of the each step will be printed to the console. More detailed output information such as logs are available in the `out` directory.
1. (Optional) Create a taskbar item to run `vagrant reload` when executed. This can be done by running the batch file `taskbar/CreateTaskbarItem.cmd`.
   - Note: The `CreateTaskbarItem.cmd` script no longer adds a taskbar icon automatically. Once the script is run, you have to select the created file `taskbar/tmp/TaskbarItem.lnk` and pin it to the taskbar manually.

## VM Configs

The `.vm-config.yaml` file stores configuration for your provisioned VM. This file is updated every time you've
answered questions during initial setup on provisioning. In this section, we will describe additional properties
you can manually add to this file. These are listed below:

- `extra_mounts` - An object with mount names as keys and mount paths as values. Mounts created this way will automatically be configured so that the `vagrant` user have full access to the contents in the mount.
    - The mount name is a unique identifier of the mount and specifies the mount point in the guest machine (mount points will be created on `${HOME}/<name>`).
    - The mount path is a directory on the host machine. It can be an absolute path or a path relative to the directory containing the `Vagrantfile`.
    
- `external_steps` - A list of strings containing paths (on the host machine) to additional ruby files containing additional provisioning steps to be run.
    The paths can be an absolute path or a path relative to the directory containing the `Vagrantfile`. 
    - Steps *must* be defined in a nested Ruby module under `Provision.Steps`.
    - Steps may be defined in a method named: `pre_<stage>`, or `post_<stage>`, where `<stage>` is one of: `prepare`, `install`, `configure`, or `cleanup`.
    - The Vagrant config is passed to these methods as the first argument, and a hash containing provisioning variables is passed as the second argument.
    - For examples, see source codes for the default steps [here]() and an sample external steps [here]()

An example of these 'extra' configs is shown below:

```yaml
extra_mounts:
  Projects: ".."
  C_Drive: "C:/"
  D_Drive: "D:/"
extra_scripts:
  - "../my-configs/src/steps.rb"
```

The contents of the file `"../my-configs/src/steps.rb"` can be for example:

```ruby
module Provision
  module Steps
    MY_CONFIGS_SCRIPTS_DIR = '${HOME}/Projects/my-configs/scripts'

    def self.pre_prepare(config, provision_vars)
      Utils::provision_file(config, '~/.some-config', '~/.some-config')
    end

    def self.post_install(config, provision_vars)
      Utils::provision_script(config, 'post_install', "#{MY_CONFIGS_SCRIPTS_DIR}/install/install-utils.sh")
    end

    def self.pre_configure(config, provision_vars)
      Utils::provision_script(config, 'pre_configure', "#{MY_CONFIGS_SCRIPTS_DIR}/configure/configure-desktop.sh")
    end

    def self.post_cleanup(config, provision_vars)
      config.vm.provision "shell", inline: "echo 'Cleaning up' && ${HOME}/cleanup.sh"
    end
  end
end
```

## Enable creation of symlinks in shared folders

By default, only administrators on Windows machines are able to create symbolic links. To add your user, follow these steps:

1. Download the tool [Polsedit](http://www.southsoftware.com/) and extract it locally.
1. Open the .exe file in the extracted folder, and add your user to the policy named 'Create symbolic links'.
1. Log out and log back in to your host machine.
