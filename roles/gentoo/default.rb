include_recipe "#{__dir__}/../../cookbooks/gentoo/recipe" if node[:packages]
include_recipe "#{__dir__}/../../cookbooks/emacs/recipe" if node[:emacs]
