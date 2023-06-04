require 'sidekiq-scheduler'

class PublishDeal
  include Sidekiq::Worker

  def perform
    system('rake publish_deal')
  end
end
