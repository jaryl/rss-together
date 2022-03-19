module RssTogether
  class NullInterface < SimpleDelegator
    def atom?
      false
    end

    def rss?
      false
    end

    def feed
      nil
    end

    def items
      []
    end
  end
end
