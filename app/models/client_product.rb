class ClientProduct < ApplicationRecord
  has_paper_trail
  belongs_to :client
  belongs_to :company_product
  has_many :client_product_payments
  accepts_nested_attributes_for :client_product_payments, :allow_destroy => true
  before_save :calculate_total_with_arrears

  def company_product
    CompanyProduct.find(self.company_product_id)
  end

  def company_of_product
    Company.find(CompanyProduct.find(self.id).company_id)
  end

  def last_payment_date
    last_payment = ClientProductPayment.where(client_product_id: self.id)
                       .order('payment_date asc').last(1).first
    last_payment.nil? ? '' : last_payment.payment_date
  end

  private
  def calculate_total_with_arrears
    self.total_with_arrears = self.balance + self.arrears
  end

end
