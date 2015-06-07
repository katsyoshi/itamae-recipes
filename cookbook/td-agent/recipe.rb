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
