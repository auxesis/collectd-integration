define jenkins::job(
  $ensure       = present,
  $template     = undef,
  $file         = undef,
  $port         = 80,
  $jenkins_home = '/var/lib/jenkins',
) {
  include jenkins

  $jenkins_jobs = "$jenkins_home/jobs"

  #####################
  #   Setup the job   #
  #####################
  if $ensure == 'present' {

    file { "$jenkins_jobs/$name":
      ensure  => directory,
      owner   => 'jenkins',
      group   => 'jenkins',
      require => [
        Class['jenkins'],
      ],
    }

    if $template  {
      jenkins::job::template { $name:
        content      => template($template),
        jenkins_home => $jenkins_home,
        require      => [
          File["$jenkins_jobs/$name"],
        ],
        notify       => [
          Service['jenkins'],
        ],
      }
    } elsif $file {
      jenkins::job::file { $name:
        source       => $file,
        jenkins_home => $jenkins_home,
        require      => [
          File["$jenkins_jobs/$name"],
        ],
        notify       => [
          Service['jenkins'],
        ],
      }
    }

  ########################
  #   Teardown the job   #
  ########################
  } elsif $ensure == 'absent' {

    file { "$jenkins_jobs/$name":
      ensure  => absent,
      recurse => true,
      require => [
        Class['jenkins'],
      ],
      notify  => [
        Service['jenkins'],
      ],
    }

  }
}

