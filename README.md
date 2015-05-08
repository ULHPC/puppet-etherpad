-*- mode: markdown; mode: visual-line;  -*-

# Etherpad Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/etherpad.svg)](https://forge.puppetlabs.com/ULHPC/etherpad)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian-lightgrey.svg)

Install and configure etherpad-lite

      Copyright (c) 2015 UL HPC Management Team <hpc-sysadmins@uni.lu>
      

* [Online Project Page](https://github.com/ULHPC/puppet-etherpad)  -- [Sources](https://github.com/ULHPC/puppet-etherpad) -- [Issues](https://github.com/ULHPC/puppet-etherpad/issues)

## Synopsis

Install and configure etherpad-lite.

This module implements the following elements: 

* __Puppet classes__:
    - `etherpad` 
    - `etherpad::common` 
    - `etherpad::debian` 
    - `etherpad::params` 

* __Puppet definitions__: 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See [`doc/contributing.md`](doc/contributing.md) for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)

## Overview and Usage

### Class `etherpad`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use is as follows:

     include ' etherpad'

See also [`tests/init.pp`](tests/init.pp)

### Class `etherpad::common`

See [`tests/common.pp`](tests/common.pp)
### Class `etherpad::debian`

See [`tests/debian.pp`](tests/debian.pp)
### Class `etherpad::params`

See [`tests/params.pp`](tests/params.pp)


## Librarian-Puppet / R10K Setup

You can of course configure the etherpad module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC-etherpad"

or, if you prefer to work on the git version: 

     mod "ULHPC-etherpad", 
         :git => https://github.com/ULHPC/puppet-etherpad,
         :ref => production 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC-etherpad Puppet Module Tracker](https://github.com/ULHPC/puppet-etherpad/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`doc/contributing.md`](doc/contributing.md)

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`doc/vagrant.md`](doc/vagrant.md) for more details. 


