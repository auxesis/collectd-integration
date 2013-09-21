class nginx::common {
  # nginx conflicts with nginx-full
  package {'nginx':
    ensure => absent,
  }

  # nginx-full and nginx-common belong together
  package { [
    'nginx-common',
    'nginx-full'
  ]:
    ensure  => present,
    require => [
      Package['nginx'],
    ],
  }

  file { '/etc/nginx/nginx.conf':
    content => template('nginx/etc/nginx/nginx.conf.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    require => [
      Package['nginx-full'],
      Package['nginx-common'],
    ],
    notify  => [
      Service['nginx'],
    ]
  }

  file { [
    '/etc/nginx/sites-available/default',
    '/etc/nginx/sites-enabled/default'
  ]:
    ensure  => absent,
    require => [
      Package['nginx-full'],
      Package['nginx-common']
    ],
    notify  => [
      Service['nginx'],
    ]
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => [
      File['/etc/nginx/nginx.conf'],
    ]
  }
}
