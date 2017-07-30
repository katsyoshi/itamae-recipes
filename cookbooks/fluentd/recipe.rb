if node[:fluentd]
  config = node[:fluentd][:config]
  type = node[:fluentd][:type] || 'td-agent'

  config_dir = "/etc/#{type}/config.d"
  directory config_dir

  remote_file "/etc/#{type}/#{type}.conf" do
    source 'conf/fluentd.conf'
  end

  config.each do |conf|
    remote_file "/etc/#{type}/config.d/#{conf}.conf" do
      source "conf/#{conf}.conf"
    end
  end

  case type
  when 'td-agent'
    service 'td-agent' do
      action :restart
    end
  end
end
