# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://docs.vagrantup.com
# https://app.vagrantup.com/boxes/search

Vagrant.configure("2") do |config|
  config.vm.define "talosdev" do |machine|
    machine.vm.box = "efalia/linux-base-server"
    machine.vm.hostname = "talosdev"

    machine.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
    machine.vm.network "forwarded_port", guest: 8081, host: 8081, host_ip: "127.0.0.1"
    # machine.vm.network "forwarded_port", guest: 8083, host: 8083, host_ip: "127.0.0.1"
    # machine.vm.network "forwarded_port", guest: 3306, host: 3306, host_ip: "127.0.0.1"
    # machine.vm.network "forwarded_port", guest: 8086, host: 8086, host_ip: "127.0.0.1"
    # machine.vm.network "forwarded_port", guest: 22, host: 2222
    # machine.vm.network "private_network", ip: "127.0.0.2"

    # https://developer.hashicorp.com/vagrant/docs/provisioning/ansible_local
    machine.vm.provision :ansible_local do |ansible|
      ansible.become = true
      # ansible.config_file = "provision/ansible.cfg"
      ansible.vault_password_file = "/tmp/vault_pass"
      # ansible.ask_vault_pass = true
      ansible.playbook = "run-dev.yml"
      ansible.inventory_path = "hosts.yml"
      ansible.skip_tags = ["file-sharing", "disks"]
      # ansible.tags = ["test"]
      # ansible.start_at_task = "ensure destination for compose file exists"
      ansible.galaxy_role_file = "requirements.yml"
      ansible.galaxy_roles_path = "galaxy_roles"
      ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    end

    # Using WSL's ansible
    # sudo ansible-galaxy install --role-file="requirements.yml" --roles-path=/etc/ansible/roles
    # ansible-playbook -i hosts.yml --skip-tags "file-sharing,disks" run-dev.yml
    # ansible-playbook -i hosts.yml --skip-tags "file-sharing,disks" -t test run-dev.yml

    machine.vm.provider "vmware_workstation" do |v|
      # Display the GUI when booting the machine
      # v.gui = true
      # VM specs
      v.vmx["memsize"] = "2048"
      v.vmx["numvcpus"] = "2"

      # Virtualbox configs
      # v.name = "talosdev"
      # v.memory = "4096"
      # v.cpus = 2
      # v.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
      # v.check_guest_additions = false
    end
  end



  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", id: "ssh", guest: 22, host: 2222
  # config.vm.network "forwarded_port", id: "http", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "127.0.0.2"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
end
