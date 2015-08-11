class sensu::enterprise::service (
  $hasrestart = true,
) {

  validate_bool($hasrestart)

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::manage_services and $sensu::enterprise {
    case $sensu::enterprise {
      true: {
        $ensure = 'running'
        $enable = true
      }
      default: {
        $ensure = 'stopped'
        $enable = false
      }
    }

    service { 'sensu-enterprise':
      ensure     => $ensure,
      enable     => $enable,
      hasrestart => $hasrestart,
      subscribe  => [
        Class['sensu::enterprise::package'],
        Class['sensu::api::config'],
        Class['sensu::redis::config'],
        Class['sensu::rabbitmq::config'],
      ],
    }
  }
}
