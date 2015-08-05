# = Class: sensu::repo::apt
#
# Adds the Sensu repo to Apt
#
# == Parameters
#
class sensu::repo::apt {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if defined(apt::source) {

    $ensure = $sensu::install_repo ? {
      true    => 'present',
      default => 'absent'
    }

    if $sensu::repo_source {
      $url     = $sensu::repo_source
      $release = 'sensu'
    } elsif $sensu::enterprise {
      $se_user = $sensu::enterprise_user
      $se_pass = $sensu::enterprise_pass

      validate_string($se_user, $se_pass)
      if $se_user == undef or $se_pass == undef {
        fail('The Sensu Enterprise repos require both enterprise_user and enterprise_pass to be set')
      }

      $url = "http://${se_user}:${se_pass}@enterprise.sensuapp.com/apt"
      $release = 'sensu-enterprise'
    } else {
      $url     = 'http://repos.sensuapp.org/apt'
      $release = 'sensu'
    }

    $package_name = $::sensu::package::package_name

    apt::source { 'sensu':
      ensure   => $ensure,
      location => $url,
      release  => $release,
      repos    => $sensu::repo,
      include  => {
        'src' => false,
      },
      key      => {
        'id'     => $sensu::repo_key_id,
        'source' => $sensu::repo_key_source,
      },
      before   => Package[$package_name],
    }

  } else {
    fail('This class requires puppetlabs-apt module')
  }

}
