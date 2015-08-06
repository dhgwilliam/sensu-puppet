# = Class: sensu::repo::yum
#
# Adds the Sensu YUM repo support
#
class sensu::repo::yum {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::install_repo  {
    if $sensu::repo_source {
      $url     = $sensu::repo_source
    } elsif $sensu::enterprise {
      $se_user = $sensu::enterprise_user
      $se_pass = $sensu::enterprise_pass

      validate_string($se_user, $se_pass)
      if $se_user == undef or $se_pass == undef {
        fail('The Sensu Enterprise repos require both enterprise_user and enterprise_pass to be set')
      }

      $base_url       = "http://${se_user}:${se_pass}@enterprise.sensuapp.com/yum"
      $url            = "${base_url}/noarch/"
      $dashboard_repo = "${base_url}/\$basearch/"
    } else {
      $url = $sensu::repo ? {
        'unstable'  => "http://repos.sensuapp.org/yum-unstable/el/\$basearch/",
        default     => "http://repos.sensuapp.org/yum/el/\$basearch/"
      }
    }

    $package_name = $::sensu::package::package_name
    $repo         = $::sensu::package::repo

    yumrepo { $repo:
      enabled  => 1,
      baseurl  => $url,
      gpgcheck => 0,
      name     => $repo,
      descr    => $repo,
      before   => Package[$package_name],
    }

    if $::sensu::enterprise and $::sensu::enterprise_dashboard {
      yumrepo { 'sensu-enterprise-dashboard':
        enabled  => 1,
        baseurl  => $dashboard_repo,
        gpgcheck => 0,
        name     => 'sensu-enterprise-dashboard',
        descr    => 'sensu-enterprise-dashboard',
        before   => Package['sensu-enterprise-dashboard'],
      }
    }
  }

}
