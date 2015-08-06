# = Class: sensu::enterprise::dashboard
#
# Installs the Sensu Enterprise Dashboard
class sensu::enterprise::dashboard {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::sensu::enterprise and $::sensu::enterprise_dashboard {
    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }

  package { 'sensu-enterprise-dashboard':
    ensure => $ensure,
  }
}
