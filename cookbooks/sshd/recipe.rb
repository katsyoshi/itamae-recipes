remote_file "/etc/ssh/sshd_config" do
  source "files/etc/ssh/sshd_config"
end

service "ssh" do
  action :restart
end
