require "rss_together/version"
require "rss_together/engine"

require "email_validator"
require "validate_url"
require "pundit"
require "faraday"
require "addressable"

require "rss_together/test/auth_helpers"

module RssTogether
  class Error < StandardError; end

  class NoFeedAtTargetUrlError < Error; end

  class DocumentParsingError < Error; end
  class XmlDocumentParsingError < DocumentParsingError; end
  class HtmlDocumentParsingError < DocumentParsingError; end
  class RssDocumentParsingError < DocumentParsingError; end
  class AtomDocumentParsingError < XmlDocumentParsingError; end

  mattr_accessor :feed_processing_interval

  mattr_accessor :items_are_unread_if_published_within
  mattr_accessor :unread_system_markers_expire_after
  mattr_accessor :unread_user_markers_expire_after

  mattr_accessor :invitations_expire_after

  mattr_accessor :group_transfers_expire_after

  mattr_accessor :max_links_followed_to_resolve_url

  mattr_accessor :user_agent

  mattr_accessor :error_reporter

  def self.setup
    yield self
  end

  class Engine < ::Rails::Engine
  end
end
