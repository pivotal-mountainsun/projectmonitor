class TravisPayloadProcessor < ProjectPayloadProcessor
  private

  # def fetch_new_statuses
  # parsed_status.online = true
  # project_html = Nokogiri::XML.parse(payload).css('Project').first
  # if !project.status.match?(parsed_status) && project_html.attribute("activity").value != "Building"
  # project.statuses.create(parsed_status.attributes)
  # end
  # end

  def parse_building_status
    building_status = BuildingStatus.new(false)
    project_html = Nokogiri::XML.parse(payload).css('Project').first
    building_status.building = project_html.attribute("activity").value == "Building" if project_html
    building_status
  end

  def parse_project_status
    status = ProjectStatus.new(:online => false, :success => false)
    if project_html = Nokogiri::XML.parse(payload).css('Project').first
      status.success = project_html.attribute("lastBuildStatus").value == "Success"
      status.url = project_html.attribute("webUrl").value
      published_at = project_html.attribute("lastBuildTime").value
      status.published_at = Time.parse(published_at).localtime if published_at.present?
    end
    status
  end
end
