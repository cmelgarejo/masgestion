class ClientContactMean < ApplicationRecord
  has_paper_trail
  belongs_to :contact_mean_type, optional: true
  belongs_to :client
  validates :target, presence: true

  def contact_mean_type
    ContactMeanType.find(self.contact_mean_types_id).description
  end
end
