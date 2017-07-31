require "itamae-plugin-resource-portage"

node.packages.each do |package|
  name = package.name
  version = package&.version
  slot = package&.slot
  use = package&.use || []
  keywords = package&.keywords || []

  portage name do
    version version if version
    slot slot if slot
    flags use if !use.empty?
    keywords keywords if !keywords.empty?
  end
end
