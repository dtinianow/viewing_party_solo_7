class UserParty < ApplicationRecord
  validates_presence_of :user, :viewing_party
  validates :host, inclusion: { in: [true, false] }

  belongs_to :viewing_party
  belongs_to :user
end
