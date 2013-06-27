# File::      <tt>etherpad-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: etherpad::params
#
# In this class are defined as variables values that are used in other
# etherpad classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class etherpad::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of etherpad
    $ensure = $::etherpad_ensure ? {
        ''      => 'present',
        default => $::etherpad_ensure
    }

    $pad_title      = 'Etherpad-lite'
    $ip             = '0.0.0.0'
    $port           = '9001'
    $session_key    = 'Ch4ng3*M3****'
    $dbtype         = 'dirty'
    $filename       = 'var/dirty.db'
    $mysql_user     = 'root'
    $mysql_host     = 'localhost'
    $mysql_password = ''
    $mysql_database = 'store'
    $defaultpadtext = 'Welcome to Etherpad Lite!\n\nThis pad text is synchronized as you type, so that everyone viewing this page sees the same text. This allows you to collaborate seamlessly on documents!\n\nEtherpad Lite on Github: http:\/\/j.mp/ep-lite\n'
    $minify         = 'true'
    $maxage         = '21600'
    $abiword        = 'absent'
    $admin_password = '!!!changethisdefaultpassword!!!'

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################

    $node_version  = 'v0.10.12'
    $install_base  = '/home/etherpad'
    $source_base   = '/home/etherpad/dev'
    $install_user  = 'etherpad'
    $install_group = 'etherpad'
    $install_mode  = '0755'

    $abiword_path   = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '/usr/bin/abiword',
        default                 => '/usr/bin/abiword'
    }
    $abiword_pkg   = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'abiword',
        default                 => 'abiword'
    }

    $configfile_mode = $::operatingsystem ? {
        default => '0600',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'etherpad',
    }
    $configfile_group = $::operatingsystem ? {
        default => 'etherpad',
    }


    $initscript_path = $::operatingsystem ? {
        default => '/etc/init.d/etherpad',
    }
    $initscript_mode = $::operatingsystem ? {
        default => '0755',
    }
    $initscript_owner = $::operatingsystem ? {
        default => 'root',
    }
    $initscript_group = $::operatingsystem ? {
        default => 'root',
    }

    $logdir = $::operatingsystem ? {
        default => '/var/log/etherpad',
    }
    $logdir_mode = $::operatingsystem ? {
        default => '0755',
    }
    $logdir_owner = $::operatingsystem ? {
        default => 'etherpad',
    }
    $logdir_group = $::operatingsystem ? {
        default => 'adm',
    }

}

