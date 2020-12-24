# devbox

[![Build Status](https://img.shields.io/travis/com/xtangle/devbox.svg)](https://travis-ci.com/xtangle/devbox)

This repository contains Vagrantfile and scripts to set up a local development Virtual Machine running in Linux.
The machine runs on a clean install of [System76 Pop!_OS 20.10](https://pop.system76.com/).
Many commonly used developer tools are installed as part of provisioning.

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
- [Typora](https://typora.io/)

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

If you do not want to install a particular software, you can comment it out in the [steps.rb](src/steps.rb) file.

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
    such as `extra_mounts` and `extra_steps`. You have the option to configure them now by editing the file directly. They are covered in detail in the [VM Configs](#vm-configs) section.
1. Run the command `vagrant up --provision` again. This time, you will not be asked to provide the configuration again.
    - Provisioning will now begin. A summary of the each step will be printed to the console. More detailed output information such as logs are available in the `out` directory.
1. (Optional) Create a taskbar item to update provisioning repositories and run `vagrant reload` when executed. 
    This can be done by running the batch file `taskbar/CreateTaskbarItems.cmd` and pinning the link created in `taskbar/tmp` to the taskbar.

## VM Configs

The `.vm-config.yaml` file stores configuration for your provisioned VM. This file is updated every time you've
answered questions during initial setup on provisioning. In this section, we will describe additional properties
you can manually add to this file. These are listed below:

- `extra_mounts` - An object with mount names as keys and mount paths as values. Mounts created this way will automatically be configured so that the `vagrant` 
    user have full permission (read, write, execute) to the contents in the mount.
    - The mount name is a unique identifier of the mount and specifies the mount point in the guest machine (mount points will be created on `${HOME}/<name>`).
    - The mount path is a directory on the host machine. It can be an absolute path or a path relative to the directory containing the `Vagrantfile`.
    
- `extra_steps` - An object with keys containig module names and values containing paths (on the host machine) to additional ruby files defining extra provisioning steps.
    The ruby file *must* define a nested module under the `Provision` module, where the sub-module name is the same key of the key-value pair in the config object.
    The paths can be an absolute path or a path relative to the directory containing the `Vagrantfile`. 
    - Steps should be defined as instance methods named: `pre_<stage>`, `<stage>`, or `post_<stage>`, where `<stage>` can be one of: 
        - `prepare`, `install`, `configure`, or `cleanup`
    - The Vagrant config is passed to these methods as the first argument, and a hash containing provisioning variables is passed as the second argument.
    - The `super` keyword should be called in these methods so that the existing tasks in the step are not lost (unless you want to overwrite the step entirely).
    - For examples, see source codes for the default steps [here](src/steps.rb) and sample extra steps [here](https://github.com/xtangle/my-configs/blob/master/src/steps.rb).

An example of these 'extra' configs is shown below:

```yaml
extra_mounts:
  Projects: ".."
  C_Drive: "C:/"
  D_Drive: "D:/"
extra_steps:
  MySteps: "../my-configs/src/steps.rb"
```

The contents of the file `"../my-configs/src/steps.rb"` can be for example:

```ruby
module Provision
  module MySteps
    def pre_prepare(config, provision_vars)  
      super
      config.vm.provision "shell", inline: "echo 'runs before the `prepare` step'"
    end

    def post_install(config, provision_vars)
      super
      config.vm.provision "shell", inline: "echo 'runs after the `install` step'"
    end

    def configure(config, provision_vars)
      super
      config.vm.provision "shell", inline: "echo 'overrides the `configure` step, executes the existing `configure` step before this'"
    end

    def cleanup(config, provision_vars)
      config.vm.provision "shell", inline: "echo 'overrides the `cleanup` step, executes the existing `cleanup` step after this'"
      super
    end
  end
end
```

## Enable creation of symlinks in shared folders

By default, only administrators on Windows machines are able to create symbolic links. To add your user, follow these steps:

1. Download the tool [Polsedit](http://www.southsoftware.com/) and extract it locally.
1. Open the .exe file in the extracted folder, and add your user to the policy named 'Create symbolic links'.
1. Log out and log back in to your host machine.
