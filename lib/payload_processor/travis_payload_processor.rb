class TravisPayloadProcessor < ProjectPayloadProcessor
  private

  def parse_building_status
    parse_payload!
    building_status = BuildingStatus.new(false)
    building_status.building = payload["state"] == "started" if json
    building_status
  end

  def parse_project_status
    parse_payload!
    status = ProjectStatus.new(:online => false, :success => false)
    status.success = payload["result"].to_i == 0
    status.url = project.feed_url.gsub(".json", "/#{json["id"]}")
    published_at = payload["finished_at"]
    status.published_at = Time.parse(published_at).localtime if published_at.present?
    status
  end

  def parse_payload!
    begin
      self.payload = Array.wrap(JSON.parse(payload.fetch("payload", payload))) if payload
    rescue JSON::ParserError; end
  end
end
