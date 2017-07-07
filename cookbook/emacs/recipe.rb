emacs = node.emacs
home = emacs.config_dir || File.expand_path("~/.") + "/.emacs.d"
font = emacs.font
packages = emacs.packages
settings = emacs.settings

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
  variables(packages: packages)
end

template "#{home}/init.el" do
  action :create
  source "templates/dot.emacs.d/init.el.erb"
  variables(home: home, packages: settings)
end
