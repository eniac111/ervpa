Vagrant.configure(2) do |config|
	config.ssh.insert_key = true
	ENV['LC_ALL']="en_US.UTF-8"
	config.vm.provider "virtualbox" do |v|
		v.memory = 2048
	end

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

        config.vm.define "refinery" do |refinery|
                refinery.vm.box = "ubuntu/trusty64"
                refinery.vm.hostname = "refinery.homenet.petrovs.info"
                refinery.vm.network "private_network", ip: "10.22.128.15"
                refinery.vm.network "forwarded_port", guest: 80, host: 8086
                refinery.vm.provision "puppet" do |puppet|
                        puppet.options = "--verbose --debug"
                        puppet.manifests_path = "manifests"
                        puppet.module_path = "modules"
                        puppet.manifest_file = "refinery.pp"
                end
        end



end

