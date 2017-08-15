class ClientProduct < ApplicationRecord
  has_paper_trail
  belongs_to :client
  belongs_to :company_product
  before_save :calculate_total_with_arrears

  private
  def calculate_total_with_arrears
    self.total_with_arrears = self.balance + self.arrears
  end

end
