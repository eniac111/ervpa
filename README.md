# ervpa
RadineryCMS with Errbit, managed with Vagrant, Puppet and Ansible

## Deploying

```bash
$ vagrant up
$ ansible-playbook -vvvv -i lib/vagrant-ansible-inventory.py errbit.yml
$ ansible-playbook -vvvv -i lib/vagrant-ansible-inventory.py -e 'deploy_refinery_errbit_apikey=apikey' refinery.yml
```
