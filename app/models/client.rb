class Client < ApplicationRecord
  alias_attribute :contact_means, :client_contact_means
  alias_attribute :references, :client_references
  alias_attribute :collection_histories, :client_collection_histories
  alias_attribute :products, :client_products
  alias_attribute :product_payments, :client_product_payments
  belongs_to :company, optional: true
  belongs_to :document_type
  has_many :client_contact_means
  has_many :client_references
  has_many :client_collection_history
  has_many :client_products
  has_many :client_product_payments
  has_many :client_imports
  has_many :campaign_details
  accepts_nested_attributes_for :client_contact_means, allow_destroy: true
  accepts_nested_attributes_for :client_references, allow_destroy: true
  accepts_nested_attributes_for :client_collection_history, allow_destroy: true
  accepts_nested_attributes_for :client_products, allow_destroy: true
  accepts_nested_attributes_for :client_product_payments, allow_destroy: true
  attr_accessor :full_name

  # validates :first_name, presence: true
  # validates :last_name, presence: true
  validates :document, presence: true

  def self.full_name
    "#{self.first_name} #{self.last_name}"
  end

  def to_s
    full_name
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def contacts_for_client
    self.client_contact_means
  end

  def self.countries
    countries = [['Paraguay', 'PY'], ['Argentina', 'AR'], ['Brasil', 'BR']]
    countries.map do |_, index|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.i18n.countries.#{index}"), index ]
    end
  end
end
