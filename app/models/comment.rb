class Comment < ApplicationRecord
    belongs_to :micropost, foreign_key: "post_id"
    belongs_to :user, foreign_key: "user_id"
    validates :text, presence: true, length: { maximum: 140 }

end
