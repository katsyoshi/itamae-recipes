package 'supervisor'

Dir.entries(__dir__) do |conf|
  remote_file "/etc/supervisor/conf.d/#{conf}" do
    source "conf/#{conf}"
  end
end
