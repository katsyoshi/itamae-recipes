emacs = node.emacs
home = emacs.config_dir || File.expand_path("~/.") + "/.emacs.d"
font = emacs.font
packages = emacs.packages

git "#{home}" do
  action :sync
  repository "https://github.com/katsyoshi/dot.emacs.d"
  not_if "test -d #{home}"
end

template "#{home}/settings/font.el" do
  action :create
  source "templates/dot.emacs.d/settings/font.el.erb"
  variables(family: font.family, height: font.height, os: node.platform)
end

template "#{home}/settings/package.el" do
  action :create
  source "templates/dot.emacs.d/settings/package.el.erb"
end

template "#{home}/init.el" do
  action :create
  source "templates/dot.emacs.d/settings/init.el.erb"
  variables(home: home, packages: packages)
end
