node.sudo&.tap do |nopass|
  template '/etc/sudoers.d/nopass' do
    action :create
    source "templates/etc/sudoers.d/nopass.erb"
    owner "root"
    variables(allows: nopass)
  end
end
