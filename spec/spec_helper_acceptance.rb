require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # Additional modules for soft deps required by puppet-nodejs
  if fact_on(host, 'os.family') == 'Debian'
    install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.4.0 < 9.0.0')
  end

  # needed :
  # * a database and granted user
  # * a php with mysql driver
  # * git command used by vcsrepo

  install_module_from_forge_on(host, 'puppetlabs-mysql', '>= 6.0.0 < 13.0.0')

  pp = %(
    include mysql::server

    package { 'git' :
      ensure => present,
    }

    class {'mysql::bindings':
      java_enable   => false,
      perl_enable   => false,
      php_enable    => true,
      python_enable => false,
      ruby_enable   => false,
    }

    mysql::db { 'etherpaddb':
      user     => 'epuserdb',
      password => 'secretdb',
      host     => 'localhost',
      grant    => ['ALL'],
    }
  )

  apply_manifest_on(host, pp, catch_failures: true)
  apply_manifest_on(host, pp, catch_changes: true)
end
