# File::      <tt>init.pp</tt>
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
        debian, ubuntu: { include etherpad::common::debian }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}
