require 'spec_helper'

RSpec.describe "when running hosts" do
  include_context "demo context"

  it "collects uptime" do
    on(hosts, 'ping -c 1 server')
  end

  it "has free memory" do
    on(hosts, 'free -m')
  end
end
