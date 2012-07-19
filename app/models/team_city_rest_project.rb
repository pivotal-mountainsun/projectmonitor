class TeamCityRestProject < Project
  FEED_URL_REGEXP = %r{http://(.*)/app/rest/builds\?locator=running:all,buildType:\(id:(bt\d*)\)}

  attr_accessor :url, :build_type_id
  attr_accessible :url, :build_type_id

  validates_format_of :url, with: /[0-9a-z@.:]+/i, :message => 'must be a valid hostname'
  validates_format_of :build_type_id, with: /bt\d*/, :message => 'must begin with bt'
  validates_presence_of :url, :build_type_id

  before_validation :build_feed_url

  def self.feed_url_fields
    ['URL', 'Build Type ID']
  end

  after_initialize do
    feed_url =~ FEED_URL_REGEXP
    self.url ||= $1
    self.build_type_id ||= $2
  end

  def build_status_url
    feed_url
  end

  def processor
    TeamCityPayloadProcessor
  end

  private

  def build_feed_url
    self.feed_url = "http://#{url}/app/rest/builds?locator=running:all,buildType:(id:#{build_type_id})"
  end

end

