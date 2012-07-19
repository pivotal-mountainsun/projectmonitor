require 'spec_helper'

describe JenkinsProject do
  let(:project) { FactoryGirl.create(:jenkins_project, url: "http://foo.bar.com:3434", build_name: 'example_project') }

  describe "#project_name" do
    it "should return nil when feed_url is nil" do
      project.feed_url = nil
      project.project_name.should be_nil
    end

    it "should extract the project name from the Atom url" do
      project.project_name.should == "example_project"
    end

    it "should extract the project name from the Atom url regardless of capitalization" do
      project.feed_url = project.feed_url.upcase
      project.project_name.should == "EXAMPLE_PROJECT"
    end
  end

  describe 'validations' do
    it { should validate_presence_of :url }
    it { should validate_presence_of :build_name }
  end

  describe "#build_status_url" do
    it "should use cc.xml" do
      project.build_status_url.should == "http://foo.bar.com:3434/cc.xml"
    end
  end
end
