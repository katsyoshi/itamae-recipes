execute "install opam" do
  command "wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin"
  not_if "test -e /usr/local/bin/opam"
end

execute "install ocaml" do
  command "opam switch 4.06.0"
end

