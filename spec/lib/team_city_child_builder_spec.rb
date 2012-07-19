require 'spec_helper'

describe TeamCityChildBuilder do
  let(:parent) { TeamCityChainedProject.new(:url => "localhost:8111", build_type_id: "bt2", :auth_username => "john", :auth_password => "secret") }
  let(:parsed) { TeamCityChildBuilder.parse(parent, content) }
  let(:content) do
    <<-XML
    <buildType id="bt2" webUrl="http://localhost:8111/viewType.html?buildTypeId=bt2">
      <snapshot-dependencies>
        <snapshot-dependency id="bt3" type="snapshot_dependency" />
        <snapshot-dependency id="bt5" type="snapshot_dependency" />
        <snapshot-dependency id="bt9" type="snapshot_dependency" />
      </snapshot-dependencies>
    </buildType>
    XML
  end

  it "assigns the correct feed_url to all children builds" do
    [3,5,9].each do |i|
      parsed.collect(&:feed_url).should(
        include("http://localhost:8111/app/rest/builds?locator=running:all,buildType:(id:bt#{i})")
      )
    end
  end

  it "assigns the correct build_id to all children builds" do
    [3,5,9].each do |i|
      parsed.collect(&:build_id).should(
        include("bt#{i}")
      )
    end
  end

  it "assigns the correct auth_username to all children builds" do
    [3,5,9].each do |i|
      parsed.collect(&:auth_username).should(
        include("john")
      )
    end
  end

  it "assigns the correct auth_username to all children builds" do
    [3,5,9].each do |i|
      parsed.collect(&:auth_password).should(
        include("secret")
      )
    end
  end
end
