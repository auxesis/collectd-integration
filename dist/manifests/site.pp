Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Make sure package repositories are up to date before main run

node default {

  # Make sure package repositories are up to date before main run
  #
  Apt::Source <| |> -> Package <| |>

  class {'utils':} ->
  class {'stdlib': } ->
  class {'ruby::common': } ->
  class {'collectd::dev': } ->
  class {'git': } ->
  nginx::reverse_proxy { 'jenkins':
    application_servers => '127.0.0.1:8080',
  } ->
  class {'jenkins': } ->

  jenkins::plugin { [
    'analysis-collector',
    'analysis-core',
    'build-pipeline-plugin',
    'build-blocker-plugin',
    'chucknorris',
    'claim',
    'copy-project-link',
    'dashboard-view',
    'disk-usage',
    'doclinks',
    'embeddable-build-status',
    'favorite',
    'git',
    'git-client',
    'github',
    'github-api',
    'gravatar',
    'greenballs',
    'htmlpublisher',
    'jquery',
    'monitoring',
    'parameterized-trigger',
    'radiatorviewplugin',
    'ruby',
    'sounds',
    'ssh',
    'ssh-agent',
    'systemloadaverage-monitor',
    'warnings',
    'xfpanel',
  ]:
    ensure => present
  } ->

  jenkins::job { 'collectd-pull-request':
    ensure   => present,
    template => 'jenkins/jenkins_collectd_pr.xml',
  } ->

  jently::instance { 'collectd':
    # FIXME(auxesis): look up the credentials with Heira
    github_login      => 'foo',
    github_password   => 'bar',
    github_repository => 'https://github.com/collectd/collectd.git',
    jenkins_url       => 'http://localhost',
    jenkins_login     => 'foo',
    jenkins_password  => 'bar',
    jenkins_job_name  => 'collectd-pull-request',
  }



}
