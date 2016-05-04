include ::apt
include stdlib

Class['apt::update'] -> Package <| provider == 'apt' |>

$packages = [
  'ruby2.0',
  'ruby2.0-dev',
  'ruby-execjs',
  'sqlite3',
  'libmysqlclient-dev',
  'libsqlite3-dev',
  'libpq-dev',
  'imagemagick',
  'libmagickwand-dev',
  'libmagickcore-dev',
  'build-essential',
  'git',
  'g++',
  'libxml2',
  'libxml2-dev',
  'libxslt-dev',
  'libcurl4-openssl-dev',
]

apt::ppa { 'ppa:brightbox/ruby-ng':
} ->

package { $packages:
  ensure   => installed,
}
