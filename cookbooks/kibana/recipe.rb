version = begin node[:kibana][:version] rescue '4.0.3' end
kibana_dir = begin node[:kibana][:dir] rescue '/usr/share/elasticsearch/plugins' end
kibana_file = "kibana-#{version}-linux-x64"
download_path = "#{kibana_dir}/#{kibana_file}.tar.gz"

execute 'download' do
  command "wget -O #{download_path} https://download.elastic.co/kibana/kibana/kibana-#{version}-linux-x64.tar.gz"
  not_if "test -e #{download_path}"
end

execute 'expand file' do
  command "tar xf #{download_path} -C #{kibana_dir}"
  not_if "test -e #{kibana_dir}/#{kibana_file}"
end
