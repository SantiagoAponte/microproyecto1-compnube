# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin? "vagrant-vbguest"
    config.vbguest.no_install  = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote   = true
  end

  config.vm.define :nodo1 do |nodo1|
    nodo1.vm.box = "bento/ubuntu-22.04"
    nodo1.vm.network :private_network, ip: "192.168.100.5"
    nodo1.vm.hostname = "nodo1"
	nodo1.vm.provision "shell", path: "provision-consul-node1.sh"
    # Configuración de Directorio Sincronizado para el Servidor
    # nodo1.vm.synced_folder "C:\\Users\\SkeltonPC\\Documents\\CURSOS 2024 ESP IA\\Vagrant's Files\\Actividad 1\\directorioSincronizadoWindows", "/home/vagrant/directorioSincronizado"
  end

  config.vm.define :nodo2 do |nodo2|
    nodo2.vm.box = "bento/ubuntu-22.04"
    nodo2.vm.network :private_network, ip: "192.168.100.6"
    nodo2.vm.hostname = "nodo2"
	nodo2.vm.boot_timeout = 300 # Añadir tiempo de espera
	nodo2.vm.provision "shell", path: "provision-consul-node2.sh"
    # Configuración de Directorio Sincronizado para el servidor
    # nodo2.vm.synced_folder "C:\\Users\\SkeltonPC\\Documents\\CURSOS 2024 ESP IA\\Vagrant's Files\\Actividad 1\\directorioSincronizadoWindows", "/home/vagrant/directorioSincronizado"
  end
  
  config.vm.define :balanceadorCarga do |balanceadorCarga|
    balanceadorCarga.vm.box = "bento/ubuntu-22.04"
    balanceadorCarga.vm.network :private_network, ip: "192.168.100.7"
    balanceadorCarga.vm.hostname = "balanceadorCarga"
	balanceadorCarga.vm.provision "shell", path: "provision-balanceadorCarga.sh"
    # Configuración de Directorio Sincronizado para el servidor
    # balanceadorCarga.vm.synced_folder "C:\\Users\\SkeltonPC\\Documents\\CURSOS 2024 ESP IA\\Vagrant's Files\\Actividad 1\\directorioSincronizadoWindows", "/home/vagrant/directorioSincronizado"
  end
  
end