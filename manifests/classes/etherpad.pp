# File::      <tt>etherpad.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: etherpad
#
# Configure and manage etherpad
# This class is inspired by Robert Helmer work on "etherpad-vagrant"
# https://github.com/rhelmer/etherpad-vagrant
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of etherpad
#
# == Actions:
#
# Install and configure etherpad
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import etherpad
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'etherpad':
#             pad_title      => 'Etherpad-lite @ csc.uni.lu',
#             ip             => '127.0.0.1',
#             dbtype         => 'mysql',
#             mysql_user     => 'etherpad',
#             mysql_host     => 'localhost',
#             mysql_password => '53CUrep4ssW0rD',
#             mysql_database => 'etherpad',
#             abiword        => 'present',
#             admin_password => 'V3ry53CUrep4ssW0rD'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class etherpad(
    $ensure         = $etherpad::params::ensure,
    $pad_title      = $etherpad::params::title,
    $ip             = $etherpad::params::ip,
    $port           = $etherpad::params::port,
    $session_key    = $etherpad::params::session_key,
    $dbtype         = $etherpad::params::dbtype,
    $filename       = $etherpad::params::filename,
    $mysql_user     = $etherpad::params::mysql_user,
    $mysql_host     = $etherpad::params::mysql_host,
    $mysql_password = $etherpad::params::mysql_password,
    $mysql_database = $etherpad::params::mysql_database,
    $defaultpadtext = $etherpad::params::defaultpadtext,
    $minify         = $etherpad::params::minify,
    $maxage         = $etherpad::params::maxage,
    $abiword        = $etherpad::params::abiword,
    $admin_password = $etherpad::params::admin_password
)
inherits etherpad::params
{
    info ("Configuring etherpad (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("etherpad 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($abiword in [ 'present', 'absent' ]) {
        fail("etherpad 'abiword' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($dbtype in [ 'dirty', 'mysql' ]) {
        fail("etherpad 'abiword' parameter must be set to either 'dirty' or 'mysql'. sqlite and postgres are not yet supported")
    }

    if ! ($minify in [ true, false ]) {
        fail("etherpad 'minify' parameter must be set to either 'true' or 'false'")
    }



    case $::operatingsystem {
        debian, ubuntu: { include etherpad::debian }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}

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


# ------------------------------------------------------------------------------
# = Class: etherpad::debian
#
# Specialization class for Debian systems
class etherpad::debian inherits etherpad::common { }

