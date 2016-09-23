gentoo = node.dig('platform')
exit 1 if gentoo =~ /gentoo/i

node.dig('packages')&.each do |package|
  config_dir = package.dig('cofig_root') || "/etc/portage"
  name = package.dig('name')
  package.dig('portage')&.each do |type, config|
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
