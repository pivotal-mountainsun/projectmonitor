class JenkinsProject < Project
  FEED_URL_REGEXP = %r{(https?://.*)/job/(.*)/rssAll$}

  attr_accessor :url, :build_name
  attr_accessible :url, :build_name

  validates_format_of :url, with: %r{https?://[0-9a-z@.:]+}i, :message => 'must be a valid hostname'
  validates :build_name, presence: true
  validates_presence_of :url
  validates_presence_of :build_name

  before_validation :build_feed_url

  after_initialize do
    feed_url =~ FEED_URL_REGEXP
    self.url ||= $1
    self.build_name ||= $2
  end

  def self.feed_url_fields
    ['URL', 'Build Name']
  end

  def project_name
    return nil if feed_url.nil?
    URI.parse(feed_url).path.scan(/^.*job\/(.*)/i)[0][0].split('/').first
  end

  def build_status_url
    return nil if feed_url.nil?

    url_components = URI.parse(feed_url)
    ["#{url_components.scheme}://#{url_components.host}"].tap do |url|
      url << ":#{url_components.port}" if url_components.port
      url << "/cc.xml"
    end.join
  end

  def processor
    JenkinsPayloadProcessor
  end

private

  def build_feed_url
    self.feed_url = "#{url}/job/#{build_name}/rssAll"
  end

end
