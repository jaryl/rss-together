module RssTogether
  module Account
    extend ActiveSupport::Concern

    class_methods do
      def rss_together
        # has_and_belongs_to_many :streams, class_name: 'RssTogether::Stream'
        # has_many :bookmarks, class_name: 'RssTogether::Bookmark'
        # has_many :comments, class_name: 'RssTogether::Comment'
        # has_many :reactions, class_name: 'RssTogether::Reaction'
      end
    end
  end
end
