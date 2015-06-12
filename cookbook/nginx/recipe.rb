def config_dir(type)
  "/etc/nginx/sites-#{type}"
end

case node[:platform]
when 'debian', 'ubuntu'
  if node[:nginx] && node[:nginx][:config]
    node[:nginx][:config].each do |conf|
      name = conf[:name]
      available = "#{config_dir('available')}/#{name}.conf"
      remote_file available do
        source "config/#{name}.conf"
      end

      if conf[:enabled]
        enable = "#{config_dir('enabled')}/#{name}.conf"
        link enable do
          to available
          not_if enable
        end
      end
    end
  end
end

service 'nginx' do
  action :restart
end
