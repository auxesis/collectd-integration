# Wrapped by jenkins::job - you should never use this directly!
define jenkins::job::template(
  $content,
  $jenkins_home = '/var/lib/jenkins',
) {

  $jenkins_jobs = "$jenkins_home/jobs"
  $string = $content ? {
    ''      => template("jenkins/jobs/$name.erb"),
    default => $content,
  }

  file { "$jenkins_jobs/$name/config.xml":
    ensure  => present,
    content => $string,
    owner   => 'jenkins',
    group   => 'jenkins',
    require => [
      Class['jenkins'],
    ],
  }
}

