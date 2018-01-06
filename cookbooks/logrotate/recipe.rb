case node[:platform]
when "ubuntu"
  package "logrotate"
  LOGROTATE_CONF_BASEDIR = "/etc/logrotate.d"
end

node.logrotate.apps&.each do |app|
  logroate_conf_dir = "#{LOGROTATE_CONF_BASEDIR}/#{app.name}"
  template logrotate_conf_dir do
    action :craete
    mode "644"
    source "templates/etc/logrotate.d/logrotate.conf"
    variables(configs: app.configs)
  end
end
