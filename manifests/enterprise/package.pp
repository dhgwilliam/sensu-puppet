# = Class: sensu::package
#
# Installs the Sensu packages
#
class sensu::enterprise::package {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $::osfamily {

    'Debian': {
      class { '::sensu::enterprise::repo::apt': }
      if $sensu::install_repo {
        include ::apt
        $repo_require = Apt::Source['sensu-enterprise']
      } else {
        $repo_require = undef
      }
    }

    'RedHat': {
      class { '::sensu::enterprise::repo::yum': }
      if $sensu::install_repo {
        $repo_require = Yumrepo['sensu-enterprise']
      } else {
        $repo_require = undef
      }
    }

    default: { fail("${::osfamily} not supported yet") }

  }

  package { 'sensu-enterprise':
    ensure  => $sensu::enterprise::version,
  }

  file { '/etc/default/sensu-enterprise':
    ensure  => file,
    content => template("${module_name}/sensu.erb"),
    owner   => '0',
    group   => '0',
    mode    => '0444',
    require => Package['sensu-enterprise'],
  }

}
