# frozen_string_literal: true

require 'spec_helper'

describe 'etherpad' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'etherpad class without any parameters' do
        let(:pre_condition) do
          "package { 'nodejs' : ensure => present }"
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_vcsrepo('/opt/etherpad') }
        it { is_expected.to contain_file('/lib/systemd/system/etherpad.service') }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').with_content(%r{check the documentation}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{ldapauth}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{ep_button_link}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').without_content(%r{"ssl" :}) }
        it { is_expected.to contain_service('etherpad') }
        it { is_expected.to contain_user('etherpad') }
        it { is_expected.to contain_group('etherpad') }
      end

      context 'etherpad class with plugins_list enabled' do
        let(:params) do
          {
            plugins_list: {
              'ep_ldapauth'    => true,
              'ep_button_link' => :undef,
              'ep_align'       => false
            },
            ldapauth: {
              'url'                => 'ldap://ldap.foobar.com',
              'accountBase'        => 'o=staff,o=foo,dc=bar,dc=com',
              'groupAttributeIsDN' => false
            }
          }
        end

        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"ldapauth": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"url": "ldap://ldap.foobar.com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"accountBase": "o=staff,o=foo,dc=bar,dc=com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"groupAttributeIsDN": false,$}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{test_user}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"users": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"admin": {$|) }
        it { is_expected.not_to contain_file('/opt/etherpad/node_modules/ep_align') }
      end

      context 'etherpad class with button_link set and ssl enabled' do
        let(:params) do
          {
            plugins_list: {
              'ep_button_link' => true
            },
            button_link: {
              'text'   => 'Link Button',
              'link'   => 'https://example.com/pad-lister',
              'before' => "li[data-key='showTimeSlider']"
            },
            ssl: 'enable',
            ssl_key: '/yourpath/etherpad.key',
            ssl_cert: '/yourpath/etherpad.crt'
          }
        end

        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"ssl" :}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"key"  : "/yourpath/etherpad.key"}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"cert" : "/yourpath/etherpad.crt"}) }
        it { is_expected.to contain_concat_fragment('ep_button_link').with_content(%r/^\s*"ep_button_link": {$/) }
        it { is_expected.to contain_concat_fragment('ep_button_link').with_content(%r{^\s*"text": "Link Button",$}) }
        it { is_expected.to contain_concat_fragment('ep_button_link').with_content(%r{^\s*"link": "https://example.com/pad-lister",$}) }
      end

      context 'etherpad class with ep_ldapauth set' do
        let(:params) do
          {
            plugins_list: {
              'ep_ldapauth' => true
            },
            ldapauth: {
              'url'                => 'ldap://ldap.foobar.com',
              'accountBase'        => 'o=staff,o=foo,dc=bar,dc=com',
              'groupAttributeIsDN' => false
            }
          }
        end

        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"users": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"ldapauth": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"url": "ldap://ldap.foobar.com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"accountBase": "o=staff,o=foo,dc=bar,dc=com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"groupAttributeIsDN": false,$}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{test_user}) }
      end

      context 'etherpad class with ep_mypads set' do
        let(:params) do
          {
            plugins_list: {
              'ep_mypads' => true
            },
            mypads: {
              'url'        => 'ldap://ldap.foobar.com',
              'searchBase' => 'o=staff,o=foo,dc=bar,dc=com'
            }
          }
        end

        it { is_expected.to contain_concat_fragment('ep_mypads').with_content(%r|^\s*"ep_mypads": {$|) }
        it { is_expected.to contain_concat_fragment('ep_mypads').with_content(%r{^\s*"url": "ldap://ldap.foobar.com",$}) }
        it { is_expected.to contain_concat_fragment('ep_mypads').with_content(%r{^\s*"searchBase": "o=staff,o=foo,dc=bar,dc=com"$}) }
      end

      context 'etherpad class with ldapauth set' do
        let(:params) do
          {
            plugins_list: {
              'ep_ldapauth' => true
            },
            ldapauth: {
              'url'                => 'ldap://ldap.foobar.com',
              'accountBase'        => 'o=staff,o=foo,dc=bar,dc=com',
              'groupAttributeIsDN' => false
            },
            users: {
              'test_user' => {
                'password' => 's3cr3t',
                'is_admin' => true
              }
            }
          }
        end

        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"users": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"ldapauth": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"url": "ldap://ldap.foobar.com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"accountBase": "o=staff,o=foo,dc=bar,dc=com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"groupAttributeIsDN": false,$}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{test_user}) }
      end

      context 'etherpad class without default ldapauth' do
        let(:params) do
          {
            use_default_ldapauth: false,
            plugins_list: {
              'ep_ldapauth' => true
            },
            ldapauth: {
              'url'                => 'ldap://ldap.foobar.com',
              'accountBase'        => 'o=staff,o=foo,dc=bar,dc=com',
              'groupAttributeIsDN' => false
            },
            users: {
              'test_user' => {
                'password' => 's3cr3t',
                'is_admin' => true
              }
            }
          }
        end

        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"users": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r|^\s*"ldapauth": {$|) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"url": "ldap://ldap.foobar.com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"accountBase": "o=staff,o=foo,dc=bar,dc=com",$}) }
        it { is_expected.to contain_concat_fragment('ep_ldapauth').with_content(%r{^\s*"groupAttributeIsDN": false$}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{test_user}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{searchPWD}) }
        it { is_expected.to contain_concat_fragment('settings-second.json.epp').without_content(%r{searchDN}) }
      end

      context 'etherpad class with button_link set' do
        let(:params) do
          {
            plugins_list: {
              'ep_button_link' => true
            }
          }
        end

        it { is_expected.to contain_concat_fragment('ep_button_link').with_content(%r/^\s*"ep_button_link": {$/) }
        it { is_expected.to contain_concat_fragment('ep_button_link').with_content(%r{^\s*"text": "Hello world",$}) }
        it { is_expected.to contain_concat_fragment('ep_button_link').with_content(%r{^\s*"link": "http://example.com",$}) }
      end

      context 'etherpad class with users pad options set' do
        let(:pre_condition) do
          "package { 'nodejs' : ensure => present }"
        end
        let(:params) do
          {
            'padoptions' => {
              'noColors' => true,
              'lang'     => 'fr'
            }
          }
        end

        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{^\s*"padOptions":}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{^\s*"noColors": true,}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{^\s*"lang": "fr"}) }
      end

      context 'etherpad class with bad users pad options set' do
        let(:params) do
          {
            'padoptions' => {
              'nocolor' => 'true',
              'Lang' => 'fr'
            }
          }
        end

        it { is_expected.to compile.and_raise_error(%r{Error while evaluating a Resource Statement}) }
      end

      context 'etherpad class with all parameters set and ssl enabled' do
        let(:pre_condition) do
          "package { 'nodejs' : ensure => present }"
        end
        let(:params) do
          {
            ensure: 'present',
            service_name: 'etherpad',
            service_ensure: 'running',
            service_provider: facts[:service_provider],
            manage_user: true,
            manage_abiword: false,
            abiword_path: '/usr/bin/abiword',
            manage_tidy: false,
            tidy_path: '/usr/bin/tidy',
            user: 'etherpad',
            group: 'etherpad',
            root_dir: '/opt/etherpad',
            source: 'https://github.com/ether/etherpad-lite.git',

            # Db
            database_type: 'dirty',
            database_host: 'localhost',
            database_user: 'etherpad',
            database_name: 'etherpad',
            database_password: 'etherpad',

            # Network
            ip: '*',
            port: 9001,
            trust_proxy: false,

            # Performance
            max_age: 21_600,
            minify: true,

            # Config
            button_link: {
              'text'   => 'Link Button',
              'link'   => 'http://example.com/pad-lister',
              'before' => "li[data-key='showTimeSlider']"
            },
            ldapauth: {
              'url' => 'ldap://ldap.foobar.com',
              'groupAttributeIsDN' => true
            },
            require_session: false,
            edit_only: false,
            require_authentication: false,
            require_authorization: false,
            pad_title: :undef,
            default_pad_text: 'Welcome to etherpad!',

            # Users
            'users' => {
              'admin' => {
                'password' => 's3cr3t',
                'is_admin' => true
              },
              'user' => {
                'password' => 'secret',
                'is_admin' => false
              }
            },

            # Ssl
            ssl: 'enable',
            ssl_key: '/yourpath/etherpad.key',
            ssl_cert: '/yourpath/etherpad.crt',

            # Logging
            logconfig_file: true,
            logconfig_file_filename: '/var/log/etherpad.log',
            logconfig_file_max_log_size: 1024,
            logconfig_file_backups: 3,
            logconfig_file_category: 'etherpad'

          }
        end

        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"ssl" :}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"key"  : "/yourpath/etherpad.key"}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"cert" : "/yourpath/etherpad.crt"}) }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/var/log/etherpad.log') }
      end

      context 'etherpad class with all parameters set' do
        let(:params) do
          {
            ensure: 'present',
            service_name: 'etherpad',
            service_ensure: 'running',
            service_provider: facts[:service_provider],
            manage_user: true,
            manage_abiword: false,
            abiword_path: '/usr/bin/abiword',
            manage_tidy: false,
            tidy_path: '/usr/bin/tidy',
            user: 'etherpad',
            group: 'etherpad',
            root_dir: '/opt/etherpad',
            source: 'https://github.com/ether/etherpad-lite.git',

            # Db
            database_type: 'dirty',
            database_host: 'localhost',
            database_user: 'etherpad',
            database_name: 'etherpad',
            database_password: 'etherpad',

            # Network
            ip: '*',
            port: 9001,
            trust_proxy: false,

            # Performance
            max_age: 21_600,
            minify: true,

            # Config
            plugins_list: {
              'ep_button_link' => true,
              'ep_ldapauth' => true
            },
            button_link: {
              'text'   => 'Link Button',
              'link'   => 'http://example.com/pad-lister',
              'before' => "li[data-key='showTimeSlider']"
            },
            ldapauth: {
              'url'                => 'ldap://ldap.foobar.com',
              'groupAttributeIsDN' => true
            },
            use_default_ldapauth: false,
            require_session: false,
            edit_only: false,
            require_authentication: false,
            require_authorization: false,
            pad_title: :undef,
            default_pad_text: 'Welcome to etherpad!',

            # Users
            'users' => {
              'admin' => {
                'password' => 's3cr3t',
                'is_admin' => true
              },
              'user' => {
                'password' => 'secret',
                'is_admin' => false
              }
            },

            # Ssl
            ssl: 'disable',
            ssl_key: '/yourpath/foobar/etherpad.key',
            ssl_cert: '/yourpath/foobar/etherpad.crt',

            # Logging
            logconfig_file: true,
            logconfig_file_filename: '/var/log/etherpad.log',
            logconfig_file_max_log_size: 1024,
            logconfig_file_backups: 3,
            logconfig_file_category: 'etherpad'
          }
        end

        it { is_expected.to contain_concat_fragment('settings-first.json.epp').without_content(%r{"ssl" :}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').without_content(%r{"key"  : "/yourpath/etherpad.key"}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').without_content(%r{"cert" : "/yourpath/etherpad.crt"}) }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/var/log/etherpad.log') }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"padOptions":}) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"noColors": false,\n }) }
        it { is_expected.to contain_concat_fragment('settings-first.json.epp').with_content(%r{"lang": "en-gb"}) }
      end
    end
  end
end
