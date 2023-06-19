desc "Publish Deal Everyday at 10 am"
task :publish_deal => :environment do
  @publishing_deal = Deal.to_publish
  @unpublishing_deal = Deal.to_unpublish
  count = 0
  @publishing_deal.each do |deal|
    if count < 2 && deal.update(published_at: Time.current)
      count += 1
    else
      deal.update_column(:publish_at, Time.current + TWENTY_FOUR_HOURS)
    end
  end
  @unpublishing_deal.each do |deal|
    deal.update_column(:publishable, false)
  end
end
