# = Class: sensu::repo::yum
#
# Adds the Sensu YUM repo support
#
class sensu::enterprise::repo::yum {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::install_repo  {
    if $sensu::enterprise {
      $se_user = $sensu::enterprise_user
      $se_pass = $sensu::enterprise_pass

      validate_string($se_user, $se_pass)
      if $se_user == undef or $se_pass == undef {
        fail('The Sensu Enterprise repos require both enterprise_user and enterprise_pass to be set')
      }

      $url = "http://${se_user}:${se_pass}@enterprise.sensuapp.com/yum/noarch/"
    }

    yumrepo { 'sensu-enterprise':
      enabled  => 1,
      baseurl  => $url,
      gpgcheck => 0,
      name     => 'sensu-enterprise',
      descr    => 'sensu-enterprise',
      before   => Package['sensu-enterprise'],
    }
  }
}
