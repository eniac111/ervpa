Vagrant.configure(2) do |config|
	config.ssh.insert_key = true

	config.vm.define "errbit" do |errbit|
		errbit.vm.box = "ubuntu/trusty64"
		errbit.vm.hostname = "errbit.homenet.petrovs.info"
		errbit.vm.network "private_network", ip: "10.22.128.10"
		errbit.vm.network "forwarded_port", guest: 80, host: 8087
		errbit.vm.provision "puppet" do |puppet|
			puppet.options = "--verbose --debug"
			puppet.manifests_path = "manifests"
			puppet.module_path = "modules"
			puppet.manifest_file = "errbit.pp"
		end
	end


#	config.vm.define "rafinery" do |rafinery|
#		rafinery.vm.box = "ubuntu/trusty64"
#		rafinery.vm.hostname = "rafinery.homenet.petrovs.info"
#		rafinery.vm.network "private_network", ip: "10.22.128.11"
#		rafinery.vm.network "forwarded_port", guest: 80, host: 8089
#		rafinety.vm.provision "puppet: do |puppet|
#			puppet.options = "--debug --verbose"
#			puppet.manifests_path = "manifests"
#			puppet.module_path = "modules"
#			puppet.manifest_file = "rafinery.pp"
#		end
#	end

end

