package 'epel-release' if node[:platform] =~ /(redhat)|(centos)/
include_recipe 'cookbook/update/recipe.rb'
include_recipe 'rbenv::system'

package 'nginx'
package 'jenkins'

service 'nginx' do
  action [:start, :enable]
end

service 'jenkins' do
  action [:start, :enable]
end
