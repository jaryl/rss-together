RssTogether.setup do |config|
  config.feed_processing_interval = 12.hours

  config.items_are_unread_if_published_within = 30.days
  config.unread_system_markers_expire_after = 30.days
  config.unread_user_markers_expire_after = 45.days

  config.invitations_expire_after = 2.weeks

  config.group_transfers_expire_after = 48.hours

  config.max_links_followed_to_resolve_url = 3

  config.user_agent = "RssTogether"

  config.error_reporter = ->(error) {}
end
