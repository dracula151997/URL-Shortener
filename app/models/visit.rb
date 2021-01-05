# == Schema Information
#
# Table name: visits
#
#  id               :bigint           not null, primary key
#  user_id          :integer          not null
#  shortened_url_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Visit < ApplicationRecord

    validates :shortened_url, presence: true
    
    
    belongs_to :shortened_url, 
    class_name: :ShortenedUrl, 
    foreign_key: :shortened_url_id, 
    primary_key: :id

    belongs_to :visitor, 
    class_name: :User, 
    foreign_key: :user_id, 
    primary_key: :id


    def self.record_visit!(user, shortened_url)
        Visit.create!(
            user_id: user.id,
            shortened_url_id: shortened_url.id
        )
    end

end
