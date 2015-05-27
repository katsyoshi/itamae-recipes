package 'epel-release'

execute 'yum update -y' do
  command 'yum update -y'
  command 'yum upgrade -y'
end

package 'nginx'
package 'java-1.8.0-openjdk-headless'

service 'nginx' do
  action [:start, :enable]
end
