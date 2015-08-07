class sensu::enterprise::dashboard::package {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::sensu::install_repo and $::sensu::enterprise_dashboard {
    $ensure = 'present'

    $se_user = $sensu::enterprise_user
    $se_pass = $sensu::enterprise_pass

    validate_string($se_user, $se_pass)
    if $se_user == undef or $se_pass == undef {
      fail('The Sensu Enterprise repos require both enterprise_user and enterprise_pass to be set')
    }

    $url = "http://${se_user}:${se_pass}@enterprise.sensuapp.com/yum/\$basearch/"

    yumrepo { 'sensu-enterprise-dashboard':
      enabled  => 1,
      baseurl  => $url,
      gpgcheck => 0,
      name     => 'sensu-enterprise-dashboard',
      descr    => 'sensu-enterprise-dashboard',
      before   => Package['sensu-enterprise-dashboard'],
    }

  } else {
    $ensure = 'absent'
  }


  package { 'sensu-enterprise-dashboard':
    ensure => $ensure,
  }

}
