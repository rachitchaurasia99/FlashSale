require 'sidekiq-scheduler'

class PublishingDeal
  include Sidekiq::Worker

  def perform
    system('rake publishing_deal')
  end
end
