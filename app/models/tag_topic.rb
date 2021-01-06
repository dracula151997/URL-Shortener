# == Schema Information
#
# Table name: tag_topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TagTopic < ApplicationRecord
    has_many :taggings, 
    class_name: :Tagging, 
    foreign_key: :tag_topic_id, 
    dependent: :destroy

    has_many :shortened_urls, 
    through: :taggings, 
    source: :shortened_url

    def popular_links
        shortened_urls.join(:visits)
            .group(:short_url, :long_url)
            .order('COUNT(visits.id) DESC')
            .select('long_url, short_url, COUNT(visits.id) as number_of_visits')
            .limit(5)
    end
end
