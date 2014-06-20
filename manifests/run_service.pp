# == Class consul::service
#
# This class is meant to be called from consul
# It ensure the service is running
#
class consul::run_service {

  service { 'consul':
    ensure     => pick($consul::service_ensure, $consul::default_service_ensure),
    enable     => pick($consul::service_enable, $consul::default_service_enable),
  }

}
