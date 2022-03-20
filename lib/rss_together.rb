require "rss_together/version"
require "rss_together/engine"

require "email_validator"
require "validate_url"
require "pundit"
require "faraday"

require "rss_together/test/auth_helpers"

module RssTogether
  class Error < StandardError; end

  class NoFeedAtTargetUrlError < Error; end

  class DocumentParsingError < Error; end
  class XmlDocumentParsingError < DocumentParsingError; end
  class HtmlDocumentParsingError < DocumentParsingError; end
  class RssDocumentParsingError < DocumentParsingError; end
  class AtomDocumentParsingError < XmlDocumentParsingError; end

  class Engine < ::Rails::Engine
  end
end
