# == Class consul::config
#
# This class is called from consul
#
class consul::config {

  file { $consul::config_dir:
    ensure => $consul::enable ? {
      true  => 'directory',
      false => 'absent',
    },
    force => true,
  } ->
  file { 'config.json':
    path    => "${consul::config_dir}/config.json",
    content => template('consul/config.json.erb'),
    ensure  => $consul::enable ? {
      true  => 'present',
      false => 'absent',
    }
  }

}
