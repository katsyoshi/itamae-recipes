env = `opam config env`

execute "register satysfi" do
  command "#{env} opam repository add satysfi-external https://github.com/gfngfn/satysfi-external-repo.git"
  not_if "#{env} opam repository | grep satysfi-external"
end

execute "update satysfi" do
  command "#{env} opam update"
end

repo_dir = File.expand_path "~/.src/satysfi"

git "clone satysfi" do
  repository "https://github.com/gfngfn/SATySFi"
  destination repo_dir
  not_if "test -e #{repo_dir}"
end

execute "pin satysfi" do
  command "#{env} opam pin add -y satysfi #{repo_dir}"
  not_if "#{env} opam pin list | grep satysfi"
end

execute "install satysfi" do
  command "#{env} opam install satysfi"
end
