template "/etc/network/interfaces" do
  action :create
  source "templates/etc/network/interfaces.erb"
  variables(networks: node.networks)
end

hostname = node&.hostname
hostname&.tap do |hn|
  template "/etc/hostname" do
    action :create
    source  "templates/etc/hostname.erb"
    variables(hostname: hn)
  end

  template "/etc/hosts" do
    action :create
    source "templates/etc/hosts.erb"
    variables(hostname: hn)
  end
end

