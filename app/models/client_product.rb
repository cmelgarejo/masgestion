class ClientProduct < ApplicationRecord
  has_paper_trail
  belongs_to :client
  belongs_to :company_product
  has_many :client_product_payments
  accepts_nested_attributes_for :client_product_payments, :allow_destroy => true
  before_save :calculate_total_with_arrears

  def name
    self.company_product.name
  end

  def company_product
    CompanyProduct.find(self.company_product_id)
  end

  def company_of_product
    Company.find(CompanyProduct.find(ClientProduct.find(self.id).company_product_id).company_id)
  end

  def last_payment_date
    last_payment = ClientProductPayment.where(client_product_id: self.id)
                       .order('payment_date asc').last(1).first
    last_payment.nil? ? '' : last_payment.payment_date
  end

  def self.products_for_client(client_id)
    ClientProduct.where(client_id: client_id).map {|product|
      ["#{product.company_of_product.name} - #{product.company_product.name}", product.id]}.to_h
  end

  private
  def calculate_total_with_arrears
    self.total_with_arrears = self.balance + self.arrears
  end

end
