-*- mode: markdown; mode: visual-line;  -*-

# Etherpad Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/etherpad.svg)](https://forge.puppetlabs.com/ULHPC/etherpad)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian-lightgrey.svg)
[![Documentation Status](https://readthedocs.org/projects/ulhpc-puppet-etherpad/badge/?version=latest)](https://readthedocs.org/projects/ulhpc-puppet-etherpad/?badge=latest)

Install and configure etherpad-lite

      Copyright (c) 2018 UL HPC Team <hpc-sysadmins@uni.lu>
      

| [Project Page](https://github.com/ULHPC/puppet-etherpad) | [Sources](https://github.com/ULHPC/puppet-etherpad) | [Documentation](https://ulhpc-puppet-etherpad.readthedocs.org/en/latest/) | [Issues](https://github.com/ULHPC/puppet-etherpad/issues) |

## Synopsis

Install and configure etherpad-lite.

This module implements the following elements: 

* __Puppet classes__:
    - `etherpad` 
    - `etherpad::common` 
    - `etherpad::common::debian` 
    - `etherpad::params` 

* __Puppet definitions__: 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See `docs/contributing.md` for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)

## Overview and Usage

### Class `etherpad`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use it as follows:

    class { 'etherpad':
        pad_title      => 'Etherpad-lite @ uni.lu',
        ip             => '0.0.0.0',
        dbtype         => 'dirty',
        session_key    => 'F98Sjdosz1',
        abiword        => 'present',
        admin_password => 'jhtyd64s8x'
    }

Or with a MySQL database:

    class { 'etherpad':
        pad_title      => 'Etherpad-lite @ csc.uni.lu',
        ip             => '127.0.0.1',
        dbtype         => 'mysql',
        session_key    => 'F98Sjdosz1',
        mysql_user     => 'etherpad',
        mysql_host     => 'localhost',
        mysql_password => '*mysqlPassword*',
        mysql_database => 'etherpad',
        abiword        => 'present',
        admin_password => 'jhtyd64s8x'
    }

See also [`tests/init.pp`](tests/init.pp)

### Class `etherpad::common`

See [`tests/common.pp`](tests/common.pp)
### Class `etherpad::common::debian`

See [`tests/common/debian.pp`](tests/common/debian.pp)
### Class `etherpad::params`

See [`tests/params.pp`](tests/params.pp)


## Librarian-Puppet / R10K Setup

You can of course configure the etherpad module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC-etherpad"

or, if you prefer to work on the git version: 

     mod "ULHPC-etherpad", 
         :git => 'https://github.com/ULHPC/puppet-etherpad',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC-etherpad Puppet Module Tracker](https://github.com/ULHPC/puppet-etherpad/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`docs/contributing.md`](contributing/index.md).

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`docs/vagrant.md`](vagrant.md) for more details. 

## Online Documentation

[Read the Docs](https://readthedocs.org/) aka RTFD hosts documentation for the open source community and the [ULHPC-etherpad](https://github.com/ULHPC/puppet-etherpad) puppet module has its documentation (see the `docs/` directly) hosted on [readthedocs](http://ulhpc-puppet-etherpad.rtfd.org).

See [`docs/rtfd.md`](rtfd.md) for more details.

## Licence

This project and the sources proposed within this repository are released under the terms of the [GPL-3.0](LICENCE) licence.


[![Licence](https://www.gnu.org/graphics/gplv3-88x31.png)](LICENSE)
