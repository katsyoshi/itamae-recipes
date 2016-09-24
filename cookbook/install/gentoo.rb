os = node.os
os.setup&.tap do |setup|
  setup.disk&.tap do |disk|
    device = disk.device

    execute "set gpt label" do
      run_command "echo \"yes\" | parted /dev/sda mklabel #{disk["type"]}", error: false
    end

    partitions = disk.partitions
    partitions.each_with_index do |partition, i|
      name = partition.name
      ptype ||= partition.ptype
      start = partition.start
      stop = partition.end
      filesystem = partition.filesystem

      execute "create partition" do
        command "parted #{device} mkpart #{name} #{ptype} #{start} #{stop}"
        not_if "parted #{device} p | grep '#{name}'"
      end

      index = i + 1
      print filesystem

      if filesystem == "swap"
        execute "create swap" do
          command "mkswap #{device}#{index}"
        end
      else
        execute "initialize filesystem" do
          command "mkfs.#{filesystem} #{device}#{index}"
          not_if "parted #{device} p | grep #{name} | grep #{filesystem}"
        end
      end
    end
  end

  setup.mount-points&.each do |mount_point|
    mp = mount_point.mount
    directory "create mount point" do
      action :create
      path mp
    end

    device = mount_point.device
    execute "mount created directory" do
      command "mount #{device} #{mp}"
      not_if "df | grep #{mp}"
    end
  end

  setup.tarballs&.each do |tarball|
    dest = tarball.dest
    file = tarball.file
    remote_file dest do
      source file
      not_if File.exists? dest
    end

    execute 'untar' do
      command <<-"UNTAR"
      cd #{File.dirname(dest)}
      tar xf #{file}
    UNTAR
      not_if File.exists? tarball.extract
    end
  end

  setup.mount-systems&.each do |mount|
    execute mount do
      command "mount #{mount.join(' ')}"
      not_if "df | grep #{mount[1]}"
    end
  end
end

os.install&.tap do |install|
  _exec = "chroot #{install.root}"

  path_info = [install.root, 'etc', 'portage', 'repos.conf'].join('/')

  directory "create portage dir" do
    action :create
    path path_info
  end

  remote_file File.dirname(path_info) do
    source 'gentoo.conf'
  end

  execute "setup portage" do
    command [_exec, "emerge-webrsync"].join(" ")
  end

  install.packages&.each do |pkg|
    execute "install packages" do
      command [_exec, "emerge #{pkg}"].join(" ")
    end
  end

  directory "kernel directory" do
    action :create
    path [install.root, 'boot', 'efi', 'efi', 'boot'].join('/')
  end

  execute "install kernel" do
    command [_exec, "sh -c", "\"cd /usr/src/linux;", "make -j5;", "make install_modules;", "make install\""].join(" ")
  end

  template "#{install.root}/etc/fstab" do
    source "fstab.erb"
  end

  execute "reboot" do
    command "reboot"
  end
end

os.dig('post-install')&.tap do |install|
  install.users&.each do |user|
    name = user.name
    home_dir = "/home/#{name}"
    user "create user" do
      username name
      gid user.gid
      password user.password
      home home_dir
    end

    ssh_dir = [home_dir, ".ssh"].join("/")
    directory "ssh directory" do
      action :create
      mode "755"
      owner name
      path ssh_dir
    end

    remote_file "copy ssh file" do
      source user.keyfile
      path [ssh_dir, "authorized_keys"].join('/')
      owner name
    end
  end

  install.portage&.tap do |portage|
    portage.configs&.each do |config|
      directory "create repos.conf" do
        action :create
        path "/etc/portage/repos.conf"
      end

      remote_file config.file do
        source config.file
        path config.dest
      end
    end
  end
end
