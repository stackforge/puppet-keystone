# == Class: keystone::endpoint
#
# Creates the auth endpoints for keystone
#
# === Parameters
#
# [*public_url*]
#   (optional) Public url for keystone endpoint.
#   Defaults to 'http://127.0.0.1:5000'
#   This url should *not* contain any version or trailing '/'.
#
# [*internal_url*]
#   (optional) Internal url for keystone endpoint.
#   Defaults to $public_url
#   This url should *not* contain any version or trailing '/'.
#
# [*admin_url*]
#   (optional) Admin url for keystone endpoint.
#   Defaults to 'http://127.0.0.1:35357'
#   This url should *not* contain any version or trailing '/'.
#
# [*region*]
#   (optional) Region for endpoint. (Defaults to 'RegionOne')
#
# [*user_domain*]
#   (Optional) Domain for $auth_name
#   Defaults to undef (use the keystone server default domain)
#
# [*project_domain*]
#   (Optional) Domain for $tenant (project)
#   Defaults to undef (use the keystone server default domain)
#
# [*default_domain*]
#   (Optional) Domain for $auth_name and $tenant (project)
#   If keystone_user_domain is not specified, use $keystone_default_domain
#   If keystone_project_domain is not specified, use $keystone_default_domain
#   Defaults to undef
#
# === DEPRECATED
#
# [*version*]
#   (optional) API version for endpoint.
#   Defaults to 'v2.0'
#   If the version is assigned to null value (forced to undef), then it won't be
#   used. This is the expected behaviour since Keystone V3 handles API versions
#   from the context. If using hiera, setting version to an empty string, '',
#   will have the same affect.
#
# === Examples
#
#  class { 'keystone::endpoint':
#    public_url   => 'https://154.10.10.23:5000',
#    internal_url => 'https://11.0.1.7:5000',
#    admin_url    => 'https://10.0.1.7:35357',
#  }
#
class keystone::endpoint (
  $public_url        = 'http://127.0.0.1:5000',
  $internal_url      = undef,
  $admin_url         = 'http://127.0.0.1:35357',
  $region            = 'RegionOne',
  $user_domain       = undef,
  $project_domain    = undef,
  $default_domain    = undef,
  $version           = 'v2.0', # DEPRECATED
) {

  if empty($version) {
    $admin_url_real =  $admin_url
    $public_url_real = $public_url

    if $internal_url {
      $internal_url_real = $internal_url
    }
    else {
      $internal_url_real = $public_url
    }
  }
  else {
    warning('The version parameter is deprecated in Liberty.')

    $public_url_real = "${public_url}/${version}"
    $admin_url_real = "${admin_url}/${version}"

    if $internal_url {
      $internal_url_real = "${internal_url}/${version}"
    }
    else {
      $internal_url_real = "${public_url}/${version}"
    }
  }

  keystone::resource::service_identity { 'keystone':
    configure_user      => false,
    configure_user_role => false,
    service_type        => 'identity',
    service_description => 'OpenStack Identity Service',
    public_url          => $public_url_real,
    admin_url           => $admin_url_real,
    internal_url        => $internal_url_real,
    region              => $region,
    user_domain         => $user_domain,
    project_domain      => $project_domain,
    default_domain      => $default_domain,
  }
}
