case node[:platform]
when 'redhat', 'centos'
  execute 'yum update -y' do
    command 'yum update -y'
  end

  execute 'installed packages upgrade' do
    command 'yum upgrade -y'
  end
when 'debian', 'ubuntu'
  execute 'apt update' do
    command 'apt update'
  end

  execute 'installed packages upgrade' do
    command 'apt upgrade -y'
  end
end
