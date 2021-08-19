require 'logger'

require 'fileutils'

require 'bolt'
require 'bolt/cli'
require "flask/version"
require 'rspec'
require 'ruby_terraform'

class Flask
  attr_accessor :terraform_modules, :bolt_inventory, :workspace

  def initialize
    logger = Logger.new($stdout)
#    logger.level = Logger::DEBUG

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    ENV['TF_IN_AUTOMATION'] = 'true'
  end

  def init
    FileUtils.mkdir_p(@workspace)
    @statefile = File.join(@workspace, 'terraform.tfstate')

    Dir.chdir(@workspace) do
      if Dir.glob("*.tf").empty?
        RubyTerraform.init(
          from_module: @terraform_modules,
          get: true,
          backend: true
        )
      else
        RubyTerraform.init(
          get: true,
          backend: true
        )
      end
    end
  end

  def provision
    Dir.chdir(@workspace) do
      RubyTerraform.apply(
        input: false,
        no_backup: true,
        auto_approve: true
      )
    end
  end

  def exec(targets, command = "whoami")
    ENV['BOLT_DISABLE_ANALYTICS'] = 'true'

    Dir.chdir(@workspace) do
      argv = ["command", "run"]
      argv << command
      argv.concat(
        [
          "--targets", targets, "--inventoryfile", @bolt_inventory,
          "--debug", "--modulepath", "/Users/josh/.puppetlabs/bolt/modules"
        ]
      )

      cli = Bolt::CLI.new(argv)
      opts = cli.parse
      cli.execute(opts)
    end
  end

  def destroy
    Dir.chdir(@workspace) do
      RubyTerraform.destroy(
        force: true,
      )
    end
    FileUtils.rm_r(@workspace)
  end
end

class RSpecListener
  def initialize
    @failure_count = 0
  end

  def example_failed(failure)
    @failure_count += 1
  end

  def failures?
    @failure_count > 0
  end
end

module DSL
  def on(hosts, command)
    # need to return an array of results, including exit code
    # and raise if there are failure
    flask.exec(hosts, command)
  end
end

flask = Flask.new
shared_context "global context" do
  let(:flask) { flask }
end

RSpec.configure do |config|
  config.include DSL
  config.include_context "global context"
  config.add_setting :terraform_modules
  config.add_setting :bolt_inventory
  config.add_setting(:workspace, default: ".flask")

  listener = RSpecListener.new
  config.reporter.register_listener(listener, :example_failed)

  config.before(:suite) do
    flask.bolt_inventory = config.bolt_inventory
    flask.terraform_modules = config.terraform_modules
    flask.workspace = config.workspace

    flask.init
    flask.provision
  end

  config.after(:suite) do
    unless listener.failures?
      flask.destroy
    end
  end
end
