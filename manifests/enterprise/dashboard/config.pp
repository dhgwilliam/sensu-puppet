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

  sensu_enterprise_dashboard_config { $::fqdn:
    ensure    => $ensure,
    base_path => $::sensu::enterprise_dashboard_base_path,
    host      => $::sensu::enterprise_dashboard_host,
    port      => $::sensu::enterprise_dashboard_port,
    refresh   => $::sensu::enterprise_dashboard_refresh,
    user      => $::sensu::enterprise_dashboard_user,
    pass      => $::sensu::enterprise_dashboard_pass,
    github    => $::sensu::enterprise_dashboard_github,
    ldap      => $::sensu::enterprise_dashboard_ldap,
  }
}
