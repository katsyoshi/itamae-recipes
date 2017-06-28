home = node.emacs.config_dir
font = node.emacs.font

git "~/.gitsrc/dot.emacs.d" do
  action :sync
  repogitory "git@github.com:katsoyshi/dot.emacs.d"
  destination "#{home}/.emacs.d"
end

template "#{home}/settings/font.el" do
  action :create
  source "templates/dot.emacs.d/settings/font.el.erb"
  valiables(font: font.family, size: font.size, os: node.platform)
end
