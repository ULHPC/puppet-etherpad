# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#
#
# You can execute this manifest as follows in your vagrant box:
#
#      sudo puppet apply -t /vagrant/tests/init.pp
#
node default {

    class { 'etherpad':
        pad_title      => 'Etherpad-lite @ uni.lu',
        ip             => '0.0.0.0',
        dbtype         => 'dirty',
        session_key    => 'F98Sjdosz1',
        abiword        => 'present',
        admin_password => 'jhtyd64s8x'
    }

}
