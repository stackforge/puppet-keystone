# Copyright 2017 Red Hat, Inc.
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: keystone::cron::fernet_rotate
#
# Installs a cron job that rotates fernet keys.
#
# === Parameters
#
#  [*ensure*]
#    (optional) Defaults to present.
#    Valid values are present, absent.
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*maxdelay*]
#    (optional) Seconds. Defaults to 0. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running all
#    cron jobs at the same time on all hosts this job is configured.
#
#  [*user*]
#    (optional) Defaults to 'keystone'.
#    Allow to run the crontab on behalf any user.
#
class keystone::cron::fernet_rotate (
  $ensure      = present,
  $minute      = 1,
  $hour        = 0,
  $monthday    = '*',
  $month       = '*',
  $weekday     = '*',
  $maxdelay    = 0,
  $user        = 'keystone',
) {

  include keystone::deps

  if $maxdelay == 0 {
    $sleep = ''
  } else {
    $sleep = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  cron { 'keystone-manage fernet_rotate':
    ensure      => $ensure,
    command     => "${sleep}keystone-manage fernet_rotate",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['keystone::service::end'],
  }
}
