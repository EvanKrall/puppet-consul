# == Class consul::intall
#
class consul::install {

  if $consul::install_method == 'url' {

    ensure_packages(['unzip'])
    staging::file { 'consul.zip':
      source => $consul::download_url
    } ->
    staging::extract { 'consul.zip':
      target  => $consul::bin_dir,
      creates => "${consul::bin_dir}/consul",
    } ->
    file { "${consul::bin_dir}/consul":
      owner => 'root',
      group => 'root',
      mode  => '0555',
    }

  } elsif $consul::install_method == 'package' {

    package { $consul::package_name:
      ensure => pick($consul::package_ensure, $consul::default_package_ensure),
    }

  } else {
    fail("The provided install method ${consul::install_method} is invalid")
  }

  case $consul::init_style {
    'upstart' : {
      file { '/etc/init/consul.conf':
        mode   => '0444',
        owner   => 'root',
        group   => 'root',
        content => template('consul/consul.upstart.erb'),
        ensure  => $consul::enable ? {
          true  => 'present',
          false => 'absent',
        },
      }
    }
    'redhat' : {
      file { '/etc/init.d/consul':
        mode    => '0555',
        owner   => 'root',
        group   => 'root',
        content => template('consul/consul.redhat.erb'),
        ensure  => $consul::enable ? {
          true  => 'present',
          false => 'absent',
        },
      }
    }
    'debian' : {
      file { '/etc/init.d/consul':
        mode    => '0555',
        owner   => 'root',
        group   => 'root',
        content => template('consul/consul.debian.erb'),
        ensure  => $consul::enable ? {
          true  => 'present',
          false => 'absent',
        },
      }
    }
    default : {
      fail("I don't know how to create an init script for style $init_style")
    }
  }

  if $consul::manage_user {
    user { $consul::user:
      ensure => $consul::enable ? {
        true  => 'present',
        false => 'absent',
      },
    }
  }
  if $consul::manage_group {
    group { $consul::group:
      ensure => $consul::enable ? {
        true  => 'present',
        false => 'absent',
      },
    }
  }
}
