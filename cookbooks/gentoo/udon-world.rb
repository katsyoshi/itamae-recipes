node.dig('platform').tap do |platform|
  break if platform =~ /gentoo/

  execute 'update package list' do
    command 'eix-sync'
  end

  execute 'update packages' do
    command 'emerge -uDN world'
  end
end
