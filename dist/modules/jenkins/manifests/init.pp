class jenkins {
  package { 'default-jre':
    ensure => $lsbdistcodename ? {
      'lucid'   => '1.6-34',
      'precise' => '1:1.6-43ubuntu2',
      default   => undef,
    },
  }

  include jenkins::repo
  include jenkins::package
  include jenkins::service

  # FIXME(auxesis): refactor out to jenkins::install class
  user { 'jenkins':
    ensure => present,
    shell  => '/bin/bash',
  }

  group { 'jenkins':
    ensure => present,
  }

  file { '/home/jenkins':
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0755',
    require => [
      Class['jenkins::package'],
      User['jenkins'],
      Group['jenkins'],
    ],
  }

  file { '/home/jenkins/.ssh':
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    require => [
      Class['jenkins::package'],
      User['jenkins'],
      File['/home/jenkins'],
    ],
  }

  file { '/home/jenkins/.ssh/known_hosts':
    ensure  => present,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0600',
    require => [
      File['/home/jenkins/.ssh'],
    ],
  }

  exec { 'install-github-hostkey-for-jenkins':
    command => 'ssh-keyscan -t rsa,dsa github.com | tee -a /home/jenkins/.ssh/known_hosts',
    unless  => 'grep "github.com" /home/jenkins/.ssh/known_hosts',
    user    => 'jenkins',
    require => [
      File['/home/jenkins/.ssh/known_hosts'],
    ],
  }

  Class['jenkins::repo'] ->
  Class['jenkins::package'] ->
  Class['jenkins::service']

}
# vim: ts=2 et sw=2 autoindent
