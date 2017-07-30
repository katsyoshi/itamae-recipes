require 'irb'
binding.irb

rustup_default_dir = "#{ENV["HOME"]}/.rustup"

execute 'get install script' do
  command "curl https://sh.rustup.rs -sSf | sh -s -- -y"
  not_if "test -e #{rustup_default_dir}"
  # user node.rustup.user
end

