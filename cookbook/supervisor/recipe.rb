package 'supervisor'

if node[:supervisor] && node[:supervisor][:config]
  node[:supervisor][:config].each do |conf|
    remote_file "/etc/supervisor/conf.d/#{conf}.conf" do
      source "conf/#{conf}.conf"
    end
  end
end

service 'supervisor' do
  action :restart
end
