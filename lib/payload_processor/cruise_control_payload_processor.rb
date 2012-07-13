class CruiseControlPayloadProcessor < ProjectPayloadProcessor
  private

  def parse_building_status
    building_status = BuildingStatus.new(false)
    document = Nokogiri::XML(payload.downcase)
    project_element = document.at_xpath("/projects/project[@name='#{project.project_name.downcase}']")
    building_status.building = project_element && project_element['activity'] == "building"
    building_status
  end

  def parse_project_status
    status = ProjectStatus.new(:online => false, :success => false)
    document = Nokogiri::XML(payload.downcase)
    status.success = !!(find(document, 'title').to_s =~ /success/)
    if (pub_date = find(document, 'pubdate')).present?
      pub_date = Time.parse(pub_date.text)
      status.published_at = (pub_date == Time.at(0) ? Clock.now : pub_date).localtime
    end
    if url = find(document, 'item/link')
      status.url = url.text
    end
    status
  end
end





