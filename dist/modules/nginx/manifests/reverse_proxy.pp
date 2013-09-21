define nginx::reverse_proxy ($application_servers=[], $template_path='nginx/etc/nginx/sites-available/reverse_proxy.erb') {
  include nginx::common

  file { '/etc/nginx/sites-available/reverse_proxy':
    content => template($template_path),
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => [
      Service['nginx'],
    ],
    require => [
      Package['nginx'],
    ]
  }

  file { '/etc/nginx/sites-enabled/reverse_proxy':
    ensure  => link,
    target  => '/etc/nginx/sites-available/reverse_proxy',
    require => [
      File['/etc/nginx/sites-available/reverse_proxy']
    ],
    notify  => [
      Service['nginx']
    ],
  }

  file { '/etc/nginx/conf.d/proxy_cache.conf':
    content => template('nginx/etc/nginx/conf.d/proxy_cache.conf.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => [
      Service['nginx']
    ],
    require => [
      Package['nginx']
    ]
  }

  file { '/srv/www':
    ensure => directory,
    before => [
      Package['nginx-common'],
    ]
  }

  file { '/srv/www/reverse_proxy':
    ensure  => directory,
    require => File['/srv/www']
  }

  file { '/srv/www/reverse_proxy/log':
    ensure  => directory,
    require => File['/srv/www/reverse_proxy']
  }

  file { '/srv/www/reverse_proxy/root':
    ensure  => directory,
    require => File['/srv/www/reverse_proxy']
  }
}
