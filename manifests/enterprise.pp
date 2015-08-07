class sensu::enterprise {

  anchor { 'sensu::enterprise::begin': } ->
  class { '::sensu::enterprise::package': } ->
  class { '::sensu::enterprise::config': } ~>
  class { '::sensu::enterprise::service': } ~>
  class { '::sensu::enterprise::dashboard': } ->
  anchor { 'sensu::enterprise::end': }

}
