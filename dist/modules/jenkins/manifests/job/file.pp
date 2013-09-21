# Wrapped by jenkins::job - you should never use this directly!
define jenkins::job::file(
  $source,
  $jenkins_home = '/var/lib/jenkins',
) {

  $jenkins_jobs = "$jenkins_home/jobs"
  $uri = $source ? {
    ''      => "puppet:///modules/jenkins/jobs/$name.xml",
    default => $source,
  }

  file { "$jenkins_jobs/$name/config.xml":
    ensure  => present,
    source  => $uri,
    owner   => 'jenkins',
    group   => 'jenkins',
    require => [
      Class['jenkins'],
    ],
  }
}

