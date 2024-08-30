# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'etherpad' do
  context 'with options' do
    it 'installs etherpad and plugins idempotently' do
      pp = %(
        class { 'etherpad':
          ensure            => 'present',
          database_type     => 'mysql',
          database_name     => 'etherpaddb',
          database_user     => 'epuserdb',
          database_password => 'secretdb',
          root_dir          => '/var/etherpad.foo.org',
          user              => 'ep',
          port              => 8000,
          pad_title         => 'the foo organisation',
          users             => {
            admin => {
              password => 's3cr3t',
              is_admin => true,
            },
            user  => {
              password => 'secret',
              is_admin => false,
            },
          },
          plugins_list => {
            ep_button_link => true,
            ep_align       => undef,
            ep_ldapauth    => false,
          },
        }
      )

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe port(8080) do
      it {
        sleep(10) # etherpad takes a while to start up
        is_expected.to be_listening
      }
    end

    describe process('node') do
      it { is_expected.to be_running }
      its(:user) { is_expected.to eq 'ep' }
      its(:args) { is_expected.to match %r{/var/etherpad.foo.org/node_modules/ep_etherpad-lite/node/server.js} }
    end

    describe command('curl -L http://localhost:8000') do
      its(:stdout) { is_expected.to match %r{.*the foo organisation.*} }
    end

    describe command('systemctl status etherpad') do
      its(:stdout) { is_expected.not_to match %r{.*Etherpad is running in Development mode.*} }
    end
  end
end
