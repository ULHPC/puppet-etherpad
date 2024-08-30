# == Class etherpad::service
#
# This class is meant to be called from etherpad.
# It ensure the service is running.
#
class etherpad::service {
  $svc_provider = $etherpad::service_provider ? {
    'nil'   => 'base', # software is pain.
    undef   => 'base',
    default => $etherpad::service_provider,
  }

  contain "etherpad::service::${svc_provider}"

  service { $etherpad::service_name:
    ensure   => $etherpad::service_ensure,
    provider => $svc_provider,
  }

  unless $etherpad::ensure == 'absent' {
    Class["etherpad::service::${svc_provider}"]
    -> Service[$etherpad::service_name]
  }
}
