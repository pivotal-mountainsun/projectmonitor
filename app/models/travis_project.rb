class TravisProject < Project
  FEED_URL_REGEXP = %r{^https?://travis-ci.org/([\w-]*)/([\w-]*)/builds\.json$}

  attr_accessor :account, :project
  attr_accessible :account, :project

  validates_format_of :account, with: /[\w-]*/
  validates_format_of :project, with: /[\w-]*/
  validates :account, :project, :presence => true

  before_validation :build_feed_url

  after_initialize do
    feed_url =~ FEED_URL_REGEXP
    self.account ||= $1
    self.project ||= $2
  end

  def self.feed_url_fields
    ['Account', 'Project']
  end

  def project_name
    return nil if feed_url.nil?
    feed_url.split("/").last(2).first
  end

  def build_status_url
    feed_url
  end

  def processor
    TravisPayloadProcessor
  end

private

  def build_feed_url
    self.feed_url = "http://travis-ci.org/#{account}/#{project}/builds.json"
  end

end
