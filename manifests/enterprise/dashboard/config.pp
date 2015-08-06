class sensu::enterprise::dashboard::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::purge_config and !$sensu::enterprise_dashboard {
    $ensure = 'absent'
  } else {
    $ensure = 'present'
  }

  file { '/etc/sensu/dashboard.json':
    ensure => file,
    owner  => 'sensu',
    group  => 'sensu',
    mode   => '0440',
  }
}
