require 'spec_helper'

describe ProjectContentFetcher do
  describe "#fetch" do
    context "when the project only has a feed_url" do

      it "retrieves content using the feed_url"
      it "does not retrieve content using the build_status_url"

      context "and retrieving on feed_url causes HTTPError" do
        it "adds an error status"
      end

      # context "project status can not be retrieved from remote source" do
        # let(:project_status) { double('project_status') }
        # before do
          # project.stub(:fetch_new_statuses).and_raise Net::HTTPError.new("can't do it", 500)
          # project.stub(:status).and_return project_status
        # end

        # context "a status does not exist with the error that is returned" do
          # before do
            # project_status.stub(:error).and_return "another error"
          # end

          # it "creates a status with the error message" do
            # project.statuses.should_receive(:create)
            # StatusFetcher.retrieve_status_for(project)
          # end
        # end

        # context "a status exists with the error that is returned" do
          # before do
            # project_status.stub(:error).and_return "HTTP Error retrieving status for project '##{project.id}': can't do it"
          # end

          # it "does not create a duplicate status" do
            # project.statuses.should_not_receive(:create)
            # StatusFetcher.retrieve_status_for(project)
          # end
        # end
      # end
    end

    context "when the project has a feed_url and a build_status_url" do

      it "retrieves content using the feed_url"
      it "retrieves content using the build_status_url"
      it "combines the content from both urls"

      context "and retrieving on build status url causes HTTPError" do
        it "forces the building status to false"
      end

      # describe "#retrieve_building_status_for" do
        # let(:project) { Project.new }
        # let(:content) { double(:content) }
        # let(:building_status) { [true, false].sample }
        # let(:status) { double(:status, :building? => building_status )}

        # subject do
          # project.building
        # end

        # context "project status can be retrieved from the remote source" do
          # before do
            # project.stub(:fetch_building_status).and_return status
            # StatusFetcher.retrieve_building_status_for project
          # end

          # it { should == building_status }
        # end

        # context "project status can not be retrieved" do
          # before do
            # project.stub(:fetch_building_status).and_raise Net::HTTPError.new("can't do it", 500)
            # StatusFetcher.retrieve_building_status_for project
          # end

          # it { should be_false }
        # end
      # end
    end
  end
end
