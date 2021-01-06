# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShortenedUrl < ApplicationRecord
    validates :long_url, :short_url, presence: true
    validates :short_url, uniqueness: true 

    belongs_to :submitter, 
    class_name: :User, 
    foreign_key: :user_id, 
    primary_key: :id

    has_many :visits, 
    class_name: :Visit, 
    foreign_key: :shortened_url_id, 
    primary_key: :id,
    dependent: :destroy

    has_many :visitors, 
    through: :visits, 
    source: :visitor

    has_many :tag_topics, class_name: :TagTopic, foreign_key: "reference_id"


    def self.random_code
        loop do
            random_code = SecureRandom.urlsafe_base64(16)
            return random_code unless ShortenedUrl.exists?(random_code)
        end
    end

    def self.create_for_user_and_long_url!(user, long_url)
        ShortenedUrl.create!(
            user_id: user.id,
            long_url: long_url,
            short_url: ShortenedUrl.random_code
        )
    end

    def num_clicks
        visits.count
    end

    def num_uniques
        visits.select('user_id').distinct.count
    end

    def num_recent_uniques
        visits.select('user_id')
            .where('created_at > ?', 10.minutes.ago)
            .distinct
            .count
    end

    private

    def no_spamming
        urls_in_last_minute = ShortenedUrl
            .where('created_at >= ?', 1.minute.ago)
            .where(user_id: user_id)
            .length

            errors[:maximux] << 'of five short urls per minute' if urls_in_last_minute >= 5
    end

    def nonpremium_max
        return if User.find(self.user_id).premium

        number_of_urls = ShortenedUrl
            .where(user_id: user_id)
            .length

        if number_of_urls >= 5
            errors[:Only] << 'premium members can create more than 5 short urls.' 
        end
    end
end
