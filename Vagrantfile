# vi: set ft=ruby :

RUN_TESTS=ENV['RUN_TESTS'] || false

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "site.yml"
    ansible.extra_vars = {
      run_tests: RUN_TESTS
    }
  end

end
