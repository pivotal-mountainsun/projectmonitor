class JenkinsPayloadProcessor < ProjectPayloadProcessor
  private

  def parse_building_status
    building_status = BuildingStatus.new(false)
    if payload && building_payload = payload.last
      document = Nokogiri::XML.parse(building_payload.downcase)
      p_element = document.xpath("//project[@name=\"#{project.project_name.downcase}\"]")
      return building_status if p_element.empty?
      building_status.building = p_element.attribute('activity').value == 'building'
    end
    building_status
  end

  def parse_project_status
    status = ProjectStatus.new(:online => false, :success => false)

    if payload && project_payload = payload.first
      if latest_build = Nokogiri::XML.parse(project_payload.downcase).css('feed entry:first').first
        if title = find(latest_build, 'title')
          status.success = !!(title.first.content.downcase =~ /success|stable|back to normal/)
        end
      end
      if status.url = find(latest_build, 'link')
        status.url = status.url.first.attribute('href').value
        pub_date = Time.parse(find(latest_build, 'published').first.content)
        status.published_at = (pub_date == Time.at(0) ? Clock.now : pub_date).localtime
      end
      status
    end
  end

  def parse_project_status_from_json
    real_payload = JSON.parse(payload.keys.select{|k| k.match(/phase/)}.first)

    status = ProjectStatus.new(:online => false, :success => false)
    status.build_id = real_payload["build"]["number"]
    status.published_at = Time.now
    status.url = real_payload["build"]["url"]
    # use STATUS + PHASE

    status
  end

  def parse_building_status_from_json
    building_status = BuildingStatus.new(false)
    # use STATUS + PHASE
    building_status
  end

  def detect_json?
    payload.keys.select{|k| k.match(/phase/)}.any?
  end
end
