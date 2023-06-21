desc "Publish Deal Everyday at 10 am"
task :publishing_deal => :environment do
  @publishing_deal = Deal.to_publish
  @unpublishing_deal = Deal.to_unpublish
  published_deal_count = 0
  @publishing_deal.each do |deal|
    if published_deal_count < MAXIMUM_DEALS_TO_SCHEDULE && deal.update(published_at: Time.current)
      published_deal_count += 1
    else
      deal.update_column(:publish_at, Time.current + RESCHEDULE_TIME_GAP)
    end
  end
  @unpublishing_deal.each do |deal|
    deal.update_column(:publishable, false)
  end
end
