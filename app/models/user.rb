# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  premium    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

    has_many :urls, 
    class_name: :ShortenedUrl, 
    foreign_key: :user_id, 
    primary_key: :id

    has_many :visits, 
    class_name: :Visit, 
    foreign_key: :user_id,
    primary_key: :id

    has_many :visited_urls,
    through: :Visit, 
    source: :ShortenedUrl
end
