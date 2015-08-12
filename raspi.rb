include_recipe 'cookbook/update/recipe.rb'
node[:packages].each do |package|
  package package
end
