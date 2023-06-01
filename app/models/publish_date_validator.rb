class PublishDateValidator < ActiveModel::Validator
  def validate(record)
    if record.publishable && record.published_date_was
      unless Time.current - record.published_date_was.to_datetime + 10.hours > 24.hours
        record.errors.add :base, "Cannot update publish_date 24 hours before deal going live"
      end
    end
  end
end

