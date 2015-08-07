class sensu::enterprise::repo::apt {
  if !defined(apt::source) {
    fail('This class requires puppetlabs-apt module')
  }

  if $sensu::enterprise {
    $se_user = $sensu::enterprise_user
    $se_pass = $sensu::enterprise_pass

    validate_string($se_user, $se_pass)
    if $se_user == undef or $se_pass == undef {
      fail('The Sensu Enterprise repos require both enterprise_user and enterprise_pass to be set')
    }

    $url     = "http://${se_user}:${se_pass}@enterprise.sensuapp.com/apt"

    apt::source { 'sensu-enterprise':
      ensure   => $ensure,
      location => $url,
      release  => 'sensu-enterprise',
      repos    => $sensu::repo,
      include  => {
        'src' => false,
      },
      key      => {
        'id'     => $sensu::repo_key_id,
        'source' => $sensu::repo_key_source,
      },
      before   => Package['sensu-enterprise'],
    }
  }
}
