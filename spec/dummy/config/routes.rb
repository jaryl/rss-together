Rails.application.routes.draw do
  mount RssTogether::Engine => "/rss_together"
end
