class ClientContactMean < ApplicationRecord
  has_paper_trail
  belongs_to :contact_mean_type, optional: true
  belongs_to :client
  validates :target, presence: true

end
