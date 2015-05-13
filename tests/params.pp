# File::      <tt>params.pp</tt>
# Author::    UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'etherpad::params'

$names = ['ensure', 'pad_title', 'ip', 'port', 'session_key', 'dbtype', 'filename', 'mysql_user', 'mysql_host', 'mysql_password', 'mysql_database', 'defaultpadtext', 'minify', 'maxage', 'abiword', 'admin_password', 'node_version', 'install_base', 'source_base', 'install_user', 'install_group', 'install_mode', 'abiword_path', 'abiword_pkg', 'configfile_mode', 'configfile_owner', 'configfile_group', 'initscript_path', 'initscript_mode', 'initscript_owner', 'initscript_group', 'logdir', 'logdir_mode', 'logdir_owner', 'logdir_group']

notice("etherpad::params::ensure = ${etherpad::params::ensure}")
notice("etherpad::params::pad_title = ${etherpad::params::pad_title}")
notice("etherpad::params::ip = ${etherpad::params::ip}")
notice("etherpad::params::port = ${etherpad::params::port}")
notice("etherpad::params::session_key = ${etherpad::params::session_key}")
notice("etherpad::params::dbtype = ${etherpad::params::dbtype}")
notice("etherpad::params::filename = ${etherpad::params::filename}")
notice("etherpad::params::mysql_user = ${etherpad::params::mysql_user}")
notice("etherpad::params::mysql_host = ${etherpad::params::mysql_host}")
notice("etherpad::params::mysql_password = ${etherpad::params::mysql_password}")
notice("etherpad::params::mysql_database = ${etherpad::params::mysql_database}")
notice("etherpad::params::defaultpadtext = ${etherpad::params::defaultpadtext}")
notice("etherpad::params::minify = ${etherpad::params::minify}")
notice("etherpad::params::maxage = ${etherpad::params::maxage}")
notice("etherpad::params::abiword = ${etherpad::params::abiword}")
notice("etherpad::params::admin_password = ${etherpad::params::admin_password}")
notice("etherpad::params::node_version = ${etherpad::params::node_version}")
notice("etherpad::params::install_base = ${etherpad::params::install_base}")
notice("etherpad::params::source_base = ${etherpad::params::source_base}")
notice("etherpad::params::install_user = ${etherpad::params::install_user}")
notice("etherpad::params::install_group = ${etherpad::params::install_group}")
notice("etherpad::params::install_mode = ${etherpad::params::install_mode}")
notice("etherpad::params::abiword_path = ${etherpad::params::abiword_path}")
notice("etherpad::params::abiword_pkg = ${etherpad::params::abiword_pkg}")
notice("etherpad::params::configfile_mode = ${etherpad::params::configfile_mode}")
notice("etherpad::params::configfile_owner = ${etherpad::params::configfile_owner}")
notice("etherpad::params::configfile_group = ${etherpad::params::configfile_group}")
notice("etherpad::params::initscript_path = ${etherpad::params::initscript_path}")
notice("etherpad::params::initscript_mode = ${etherpad::params::initscript_mode}")
notice("etherpad::params::initscript_owner = ${etherpad::params::initscript_owner}")
notice("etherpad::params::initscript_group = ${etherpad::params::initscript_group}")
notice("etherpad::params::logdir = ${etherpad::params::logdir}")
notice("etherpad::params::logdir_mode = ${etherpad::params::logdir_mode}")
notice("etherpad::params::logdir_owner = ${etherpad::params::logdir_owner}")
notice("etherpad::params::logdir_group = ${etherpad::params::logdir_group}")

#each($names) |$v| {
#    $var = "etherpad::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
