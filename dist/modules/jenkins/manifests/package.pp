class jenkins::package {
  package { 'jenkins' :
    ensure => present,
  }
}
