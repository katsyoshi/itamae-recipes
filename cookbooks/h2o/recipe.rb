h2o = node.h2o

dirctory "/etc/h2o" do
  action :create
end

direcotry h2o.logdir do
  action :create
end

execute "chmod #{h2o.user}" do
  command "chown #{h2o.user} #{h2o.logdir}"
end

execute "touch #{h2o.pid}" do
  command "touch #{h2o.pid}"
end

execute "chown #{h2o.pid}" do
  command "chown #{h2o.user} #{h2o.pid}"
end

template "/etc/h2o/h2o.conf" do
  action :create
  source "templates/etc/h2o.conf.erb"
  variables(h2o: h2o)
end

remote_file "/etc/systemd/system/h2o.service" do
  action :create
  source "templates/etc/systemd/system/h2o.service"
end
