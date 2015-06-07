if node[:fluentd]
  config = node[:fluentd][:config]
  type = node[:fluentd][:type] || "td-agent"

  directory "/etc/#{type}/config.d"

  remote_file "/etc/#{type}/td-agent.conf" do
    source 'conf/fluentd.conf'
  end

  config.each do |conf|
    remote_file "/etc/td-agent/config.d/#{conf}.conf" do
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
