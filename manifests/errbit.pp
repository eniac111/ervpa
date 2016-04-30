include ::apt
include stdlib

Class['apt::update'] -> Package <| provider == 'apt' |>

$packages = [
	"nginx",
	"mongodb-org",
	"ruby2.1",
	"ruby2.1-dev",
	"build-essential",
	"git",
	"g++",
	"libxml2",
	"libxml2-dev",
	"libxslt-dev",
	"libcurl4-openssl-dev",
]  

apt::source { 'mongodb-ubuntu' :
	comment => 'MongoDB 3.2 official repository',
	location => 'http://repo.mongodb.org/apt/ubuntu',
	release => 'trusty/mongodb-org/3.2',
	repos => 'multiverse',
	key => {
		'id' => '42F3E95A2C4F08279C4960ADD68FA50FEA312927',
		'server' => 'hkp://keyserver.ubuntu.com:80',
	},
	include  => {
		'src' => true,
		'deb' => true,
	}
} ->	

apt::ppa { 'ppa:brightbox/ruby-ng':
} ->


package  { $packages:
    ensure   => installed,
} ->

class { '::mongodb::globals':
        manage_package_repo => 'false',
} ->
class { '::mongodb::server':
        bind_ip  => '0.0.0.0',
        auth => true,
}

