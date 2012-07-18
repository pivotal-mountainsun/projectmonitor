class StatusController < ApplicationController
  def create
    # params.delete(:action)
    # params.delete(:controller)
    project = Project.find(params.delete(:project_id))
    ProjectPayloadProcessor.new(project, params).perform
    head :ok
  end
end
