include_recipe 'cookbook/update/recipe.rb'
node[:packages].each do |package|
  package package
end

node[:git].each do |url|
  path = url.split('/').last.sub(/\.git$/, '')

  git "/home/ubuntu/#{path}" do
    repository url
  end

  execute "build git" do
    command 'cd /home/ubuntu/fluent-bit/build && cmake .. && make && make install'
    not_if 'test -e /usr/local/fluent-bit'
  end
end
