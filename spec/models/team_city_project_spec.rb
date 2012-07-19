require 'spec_helper'

describe TeamCityProject do
  subject { FactoryGirl.build(:team_city_project) }

  describe 'validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:build_type_id) }
  end

  describe "#project_name" do
    it "should return nil when feed_url is nil" do
      subject.feed_url = nil
      subject.project_name.should be_nil
    end

    it "should return the Atom url, since TeamCity does not have the project name in the feed_url" do
      subject.project_name.should == subject.feed_url
    end
  end

  describe "#build_status_url" do
    before do
      subject.url = "foo.bar.com:3434"
      subject.build_type_id = "bt9"
    end

    it "should be the same as feed url" do
      subject.build_status_url.should == "http://foo.bar.com:3434/guestAuth/cradiator.html?buildTypeId=bt9"
    end
  end
end
