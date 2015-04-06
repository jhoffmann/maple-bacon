# SugarCRM
## Internal Applications Development Setup

This guide assumes you know how to install unix programs and configure things like PHP.  Google and Stack Overflow are awesome if you have questions.

### First steps on the sauce

Install [Homebrew](http://brew.sh).  It's going to require things like XCode from the Apple Store, I'm not going to repeat the instructions here, but get it running.

### [Virtual boxes](http://virtualbox.org) with [Vagrant](http://vagrantup.com)

Vagrant will setup and manage our virtual machines, while [Chef](https://www.chef.io) will provision them according to a set of configurable rules.  The rules in chef are called `recipes`, and they're organized into packages called `cookbooks`.  We'll use a variety of [community cookbooks](https://supermarket.chef.io) as well as define our own application specific ones.

Vagrant can deploy to a multitude of [providers](https://docs.vagrantup.com/v2/providers/index.html), but for our purposes we'll use [Virtual Box](https://www.virtualbox.org) since it's free, easy to install, and well supported.

```
$ brew install caskroom/cask/brew-cask
$ brew cask install vagrant virtualbox chefdk
```

##### Cask

[Cask](http://caskroom.io) is an extension to [Homebrew](http://brew.sh) which handles Applications and Package installers, like Chrome, Hipchat, etc.  It installs them in the normal brew locations and then manages symlinks to your Applications folder.

##### Vagrant plugins

[Berkshelf](http://berkshelf.com) is the part of Chef that manages all the dependencies between the various cookbooks. Ermagherd, berks!  Hostmanager is nice because it will automatically manage our `/etc/hosts` for us as we bring or or tear down boxes.
```
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-hostmanager
$ vagrant plugin install vagrant-omnibus
```

You can optionally install the Sahara plugin, which allows you to rollback your virtual machine; useful for things like testing module installs since it saves a lot of time 'resetting' your dev environment, messing up `git clean`, and losing your config files, etc.

```
$ vagrant plugin install sahara
$ vagrant help sandbox
```

I strongly recommend the following tools; you'll find your productivity dramatically increasing if you learn to love them.  A properly setup `ag` (silver searcher) blows the pants off of `grep` or `ack`.  Boris is an interactive PHP shell.  Tig is an ncurses shell for Git, no more paging git log to `less`.  Hub is a wrapper around Git that makes things like cloning and pull-requests so much easier, straight from the command line.

```
$ brew install php54 git tig hub boris gistit the_silver_searcher jq
```

##### Getting your ssh keys forwarded

If you want to do any git operations on the VM, you want it to use your SSH key's from your host operating system, so you don't have to worry about copying `id_rsa` files around.

List the keys that ssh-agent will handle
```
$ ssh-add -L
```

If it responds with *"The agent has no identities."*, then you need to add your key (`-K` tells it to use the OS X Keychain):
```
$ ssh add -K ~/.ssh/id_rsa # Or whichever key you have uploaded to github.com
```

Now, when you're on the virtual machine, you can make sure it's working by:
```
$ ssh -T git@github.com
Hi jhoffmann! You've successfully authenticated, but GitHub does not provide shell access.
```

##### Kicking it off

Before we start up our VM, we should talk a little about directory structure.  Everone has a preference, my personals are `~/src` for public repos or code, and `~/sugar` for any work related repositories.  This shouldn't matter, as long as the folders are all organized in the following method.
```
   <path>/
         /si              # git clone sugarcrm/sugarinternal
         /si_uploads      # Empty directory for compatability with production SI
         /bacon           # This repository
         /stock           # Download your package of choice from http://honey-b/release_archive/ent/

         /store           # Create an empty directory to have the Apache vhosts setup automatically
         /internal        # If you already have clones, just move them to the correct place
         /partners        # If the directories don't exist, you can always create them later and
         /gatekeeper      # Just `vagrant provision` to have the vhosts setup
```
The reason for this, is when you run the Vagrant commands within the `bacon` folder, it's going to mount `..` as `/var/www/htdocs` within your virtual machine and setup Apache virtual hosts for each application we have defined.

Now that we're all set, we should be able to start Vagrant.  It will download the OS image, configure the virtual machine, setup Chef inside it, configure the networking, install and configure all of our packages like PHP and the web services, and a few minutes later ... we can login!
```
$ vagrant up
$ vagrant ssh
```

##### Verify the install using [stock](http://stock.dev.vm)

Download a released version of SugarCRM from either the store or honey-b, unzip it in your `Downloads` folder, and then move it to the `stock` folder in your code root (i.e. you should have `~/<path>/stock/install.php`).

### Things to note

- The hostmanager plugin will edit your `/etc/hosts` to add all of the *.dev.vm entries, so our Apache vhosts can bind to them.  If you have cruft in there, you might have conflicts, but I took steps to avoid that.
- The virtual machine will be stored inside the `.vagrant` folder inside this repo, and you get a bunch of stuff installed into `~/.berkshelf`, just be aware in case like me, you backup your home folder to Dropbox and don't want SCM repos stored there.
- This process is designed to create *volatile* virtual machines.  Try not to make any changes inside it that you wan't to keep, like installing new packages or making sweeping changes to configuration files.  Fork this repo, update the cookbooks, and submit a pull request.
- I've installed the elasticsearch browser, it can be reached by going to http://dev.vm:9200/_plugin/head/

### Customizing Your Environment

Create a `cookbooks/dev-applications/attributes/local.rb` file, and add attributes to the `override` node.  These files are excluded from git, so make sure you backup any copies.  For example:
```
override['dev']['database'] = {
  'hostname' => 'my database ip',
  'username' => 'username',
  'password' => 'password'
}

override['stock']['config']['setup_license_key'] = 'copied from sugarinternal'
```
You will either need to `vagrant provision` or `vagrant destroy;vagrant up` your sandbox after making changes.

## Additional reading

- http://google.com
- https://supermarket.chef.io/cookbooks

## Cleanup

If you need to wipe out everything and start over, here's a list of places to start.
```
$ vagrant destroy --force
$ rm -rf bacon/.vagrant
$ rm -rf ~/.berkshelf
$ rm -rf ~/.vagrant.d         # You'll need to re-install the plugins listed above
$ rm -rf ~/Library/VirtualBox
$ rm -rf ~/VirtualBox\ VMs
```

## Todo

- https://docs.chef.io/environments.html
  - https://github.com/mitchellh/vagrant/issues/1899
- http://code.tutsplus.com/tutorials/setting-up-a-local-mirror-for-composer-packages-with-satis--net-36726
- recipe for getting a zipfile from honey-b and extracing into stock
