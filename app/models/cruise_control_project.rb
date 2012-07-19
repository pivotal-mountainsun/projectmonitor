class CruiseControlProject < Project

  alias_attribute :url, :feed_url
  attr_accessible :url

  validates :url, presence: true, format: {with: /https?:\/\/.*\.rss$/i, message: 'should end with ".rss"'}

  def self.feed_url_fields
    ['URL']
  end

  def project_name
    return nil if feed_url.nil?
    URI.parse(feed_url).path.scan(/^.*\/(.*)\.rss/i)[0][0]
  end

  def processor
    CruiseControlPayloadProcessor
  end

end
