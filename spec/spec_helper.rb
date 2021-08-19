require 'flask'

# These belong in the spec_helper for the project using flask,
# so it can define what the topology should be.

RSpec.shared_context "demo context" do
  let(:hosts) { 'nodes' }
  # let(:agents) { collect agents nodes from inventory }
end

BASEDIR = File.expand_path("~/work/terraform-bolt").freeze
RSpec.configure do |config|
  config.terraform_modules = File.join(BASEDIR, 'terraform')
  config.bolt_inventory = File.join(BASEDIR, 'Boltdir', 'inventory.yaml')
end
