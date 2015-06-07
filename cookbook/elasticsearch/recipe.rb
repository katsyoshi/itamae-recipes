case node[:platform]
when 'debian', 'ubuntu'
  remote_file '/etc/apt/sources.list.d/elasticsearch.list' do
    source 'repo_files/elasticsearch.list'
  end

  execute 'add repository key' do
    command 'wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
    not_if 'test "apt-key list | grep Elasticsearch" != ""'
  end
  package 'openjdk-7-jre-headless'
when 'centos', 'redhat'
  remote_file '/etc/yum.repos.d/elasticsearch.repo' do
    source 'repo_files/elasticsearch.repo'
  end

  execute 'add repository key' do
    command 'sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch'
  end
end
