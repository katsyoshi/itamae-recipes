case node[:platform]
when 'ubuntu'
  execute 'add repository key' do
    command 'wget -qO - https://packages.treasuredata.com/GPG-KEY-td-agent | sudo apt-key add -'
    not_if 'test "$(apt-key list|grep Treasure)" != ""'
  end

  remote_file '/etc/apt/sources.list.d/td-agent.list' do
    source 'repo_files/td-agent.list'
  end
when 'debian'
when 'centos', 'redhat'
end

if node[:'td-agent'][:install] == true
  execute 'update' do
    command 'apt update'
  end

  package 'td-agent'
end

if node[:'td-agent'][:plugins]
  node[:'td-agent'][:plugins].each do |plugin|
    gem_package "install #{plugin} plugin" do
      gem_binary"/opt/td-agent/embedded/bin/gem"
      package_name "fluent-plugin-#{plugin}"
    end
  end
end
