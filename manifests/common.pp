# File::      <tt>common.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: etherpad::common
#
# Base class to be inherited by the other etherpad classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class etherpad::common {

    # Load the variables used in this module. Check the etherpad-params.pp file
    require etherpad::params

    ###########
    ## COMMON #
    ###########

    package { ['build-essential']:
        ensure => $etherpad::ensure,
    }

    user { $etherpad::params::install_user:
        ensure     => $etherpad::ensure,
        uid        => '10000',
        shell      => '/bin/bash',
        managehome => true,
    }
    group { $etherpad::params::install_group:
        ensure  => $etherpad::ensure,
        require => User[$etherpad::params::install_user],
    }

    file { 'install-base':
        ensure  => directory,
        path    => $etherpad::params::install_base,
        owner   => $etherpad::params::install_user,
        group   => $etherpad::params::install_group,
        mode    => $etherpad::params::install_mode,
        recurse => false,
        require => [
                    User[$etherpad::params::install_user],
                    Group[$etherpad::params::install_group]
                  ],
    }

    file { 'source-base':
        ensure  => directory,
        require => File['install-base'],
        path    => $etherpad::params::source_base,
        owner   => $etherpad::params::install_user,
        group   => $etherpad::params::install_group,
        mode    => $etherpad::params::install_mode,
        recurse => false
    }

    ###########
    ## NODEJS #
    ###########

    exec {
        "/usr/bin/wget -N http://nodejs.org/dist/${etherpad::params::node_version}/node-${etherpad::params::node_version}.tar.gz":
            alias   => 'download-node',
            user    => $etherpad::params::install_user,
            cwd     => $etherpad::params::source_base,
            creates => "${etherpad::params::source_base}/node-${etherpad::params::node_version}.tar.gz",
            require => File['source-base'];

        "/bin/tar zxf node-${etherpad::params::node_version}.tar.gz":
            alias   => 'unpack-node',
            user    => $etherpad::params::install_user,
            cwd     => $etherpad::params::source_base,
            creates => "${etherpad::params::source_base}/node-${etherpad::params::node_version}",
            require => Exec['download-node'];

        "${etherpad::params::source_base}/node-${etherpad::params::node_version}/configure --prefix=${etherpad::params::install_base}/node-${etherpad::params::node_version} && /usr/bin/make install":
            alias       => 'install-node',
            environment => "HOME=${etherpad::params::install_base}",
            user        => $etherpad::params::install_user,
            cwd         => "${etherpad::params::source_base}/node-${etherpad::params::node_version}",
            creates     => "${etherpad::params::install_base}/node-${etherpad::params::node_version}",
            timeout     => 0,
            require     => [Exec['unpack-node'], Package['build-essential']];
    }

    ##################
    ## ETHERPAD-LITE #
    ##################


    git::clone { 'git-etherpad':
        ensure => $etherpad::ensure,
        path   => "${etherpad::params::source_base}/etherpad",
        source => 'https://github.com/ether/etherpad-lite.git',
        user   => $etherpad::params::install_user,
    }

    exec { '/bin/bash bin/installDeps.sh':
        alias       => 'install-etherpad-deps',
        require     => [ Exec['install-node'], Git::Clone['git-etherpad'] ],
        environment => "HOME=${etherpad::params::install_base}",
        cwd         => "${etherpad::params::source_base}/etherpad",
        path        => "/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/ruby/bin/:${etherpad::params::install_base}/node-${etherpad::params::node_version}/bin",
        logoutput   => on_failure,
        user        => $etherpad::params::install_user,
    }


    # Abiword support
    package { $etherpad::params::abiword_pkg :
        ensure => $etherpad::abiword,
    }

    # Create logdir
    file { 'log_directory':
        ensure  => directory,
        require => [
                    User[$etherpad::params::install_user],
                    Group[$etherpad::params::install_group]
                  ],
        path    => $etherpad::params::logdir,
        owner   => $etherpad::params::logdir_owner,
        group   => $etherpad::params::logdir_group,
        mode    => $etherpad::params::logdir_mode,
    }

    file { $etherpad::params::initscript_path:
        ensure  => $etherpad::ensure,
        owner   => $etherpad::params::initscript_owner,
        group   => $etherpad::params::initscript_group,
        mode    => $etherpad::params::initscript_mode,
        content => template('etherpad/rc.etherpad-lite.erb'),
    }
    service { 'etherpad':
        enable  => true,
        require => File[$etherpad::params::initscript_path],
    }


    file { "${etherpad::params::source_base}/etherpad/settings.json":
        ensure  => $etherpad::ensure,
        owner   => $etherpad::params::configfile_owner,
        group   => $etherpad::params::configfile_group,
        mode    => $etherpad::params::configfile_mode,
        content => template('etherpad/settings.json.erb'),
        require => Git::Clone['git-etherpad'],
    }

}
