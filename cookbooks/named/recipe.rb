package "dnsmasq" do
  action :install
end

remote_file "/etc/dnsmasq.conf" do
  source "files/etc/dnsmasq.conf"
end

node.hosts&.tap do |hosts|
  template "/etc/dnsmasq.hosts" do
    action :create
    mode '644'
    source "templates/etc/hosts.erb"
    variables(names: hosts.names, domain: hosts.domain)
  end
end

service "dnsmasq" do
  action [:enable, :restart]
end
