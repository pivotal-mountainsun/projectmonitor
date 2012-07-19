class TeamCityProject < Project
  FEED_URL_REGEXP = %r{https?://(.*)/guestAuth/cradiator\.html\?buildTypeId=(.*)$}

  validates :url, presence: true
  validates :build_type_id, presence: true

  attr_accessor :url, :build_type_id
  attr_accessible :url, :build_type_id
  alias_attribute :build_status_url, :feed_url

  def self.feed_url_fields
    ["URL","Build Type ID"]
  end

  def self.generate_feed_url url, build_type_id
    "http://#{url}/app/rest/builds?locator=running:all,buildType:(id:#{build_type_id})"
  end

  before_validation :build_feed_url
  after_initialize do
    feed_url =~ FEED_URL_REGEXP
    self.url ||= $1
    self.build_type_id ||= $2
  end

  def processor
    LegacyTeamCityPayloadProcessor
  end

private

  def build_feed_url
    self.feed_url = generate_feed_url url, build_type_id
  end

end
