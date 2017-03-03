require 'itamae-plugin-resource-portage'

node.packages.each do |package|
  name = package.name
  version = package.portage&.version
  slot = package.portage&.slot
  use = package.portage&.use || []
  keywords = package.portage&.keywords || []

  portage name do
    version version if version
    slot slot if slot
    flags use if !use.empty?
    keywords keywords if !keywords.empty?
  end
end
