emacs = node.emacs
home = emacs.config_dir || File.expand_path("~/.") + "/.emacs.d"

execute "reset emacs config" do
  command "git checkout -f && git fetch && git rebase origin/master --force"
  cwd home
  only_if "test -d #{home}"
end

git "#{home}" do
  action :sync
  repository "https://github.com/katsyoshi/dot.emacs.d"
  not_if "test -d #{home}"
end

emacs.font&.tap do |font|
  template "#{home}/settings/font.el" do
    action :create
    source "templates/dot.emacs.d/settings/font.el.erb"
    variables(family: font.family, height: font.height, os: node.platform)
  end
end

emacs.packages&.tap do |packages|
  template "#{home}/settings/package.el" do
    action :create
    source "templates/dot.emacs.d/settings/package.el.erb"
    variables(packages: packages)
  end
end

emacs.settings&.tap do |settings|
  template "#{home}/init.el" do
    action :create
    source "templates/dot.emacs.d/init.el.erb"
    variables(home: home, packages: settings)
  end
end

emacs.user&.tap do |user|
  execute "change owner of #{user}" do
    command "chown -R #{user.name}:#{user.group} #{home}"
  end
end
