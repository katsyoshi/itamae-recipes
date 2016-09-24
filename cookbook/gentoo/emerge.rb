gentoo = node.platform

exit 1 unless gentoo.match(/gentoo/i)

node.packages&.each do |package|
  config_dir = package.cofig_root || "/etc/portage"
  name = package.name
  package.portage&.each do |type, config|
    remote_file "set #{type}" do
      source [type, config].join('/')
      path [config_dir, "package.#{type}", config].join('/')
    end
  end

  execute "install #{name}" do
    command "emerge #{name}"
    not_if "grep #{name} /var/lib/portage/world"
  end
end
