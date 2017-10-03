class ClientContactMean < ApplicationRecord
  has_paper_trail
  belongs_to :contact_mean_type, optional: true
  belongs_to :client
  validates :target, presence: true

  def name
    self.contact_mean_type
  end

  def contact_mean_type
    ContactMeanType.find(self.contact_mean_types_id).description
  end

  def contacts_for_client(client_id)
    ClientContactMean.where(client_id: client_id).map {|contact|
      ["#{contact.contact_mean_type} - #{contact.target}", contact.id]}.to_h
  end


end
