i3wm = node.i3wm
home = i3wm.config_dir || Fil.join(File.expand_path("~/"), "/.config", "i3")

template "#{home}/config" do
  action :create
  source "templates/i3wm/config"
  variables(i3wm: i3wm)
end
