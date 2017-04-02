template '/etc/network/interfaces' do
  action :create
  source "templates/etc/network/interfaces.erb"
  variables(networks: node.networks)
end
