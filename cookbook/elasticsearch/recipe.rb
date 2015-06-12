case node[:platform]
when 'debian', 'ubuntu'
  remote_file '/etc/apt/sources.list.d/elasticsearch.list' do
    source 'repo_files/elasticsearch.list'
  end

  execute 'add repository key' do
    command 'wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -'
    not_if 'test "$(apt-key list | grep Elasticsearch)" != ""'
  end
when 'centos', 'redhat'
  remote_file '/etc/yum.repos.d/elasticsearch.repo' do
    source 'repo_files/elasticsearch.repo'
  end

  execute 'add repository key' do
    command 'sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch'
  end
end

if node[:elasticsearch] && node[:elasticsearch][:plugin]
  proxy = node[:elasticsearch][:proxy] if node[:elasticsearch][:proxy]
  node[:elasticsearch][:plugin].each do |plugin|
    url = plugin[:url]
    name = plugin[:name]
    package = name.split('/').last
    plugin = "/usr/share/elasticsearch/bin/plugin -i #{name}"
    plugin << " -u #{url}" unless url.nil?
    plugin << " -DproxyHost=#{proxy[:host]} -DproxyPort=#{proxy[:port]}" unless proxy.nil?

    execute 'install kibana' do
      command plugin
      not_if "test -e /usr/share/elasticsearch/plugins/#{package}"
    end
  end
  service 'elasticsearch' do
    action :restart
  end
end
