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

$names = ['ensure', 'protocol', 'port', 'packagename']

notice("etherpad::params::ensure = ${etherpad::params::ensure}")
notice("etherpad::params::protocol = ${etherpad::params::protocol}")
notice("etherpad::params::port = ${etherpad::params::port}")
notice("etherpad::params::packagename = ${etherpad::params::packagename}")

#each($names) |$v| {
#    $var = "etherpad::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
