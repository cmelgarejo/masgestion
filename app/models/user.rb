class User < ApplicationRecord
  ROLES = %w[admin moderator author banned].freeze
  #has_secure_password
  has_paper_trail
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company, optional: true
  after_initialize :set_default_role, if: :new_record?
  #after_initialize :set_default_company, if: :new_record?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :user_companies, dependent: :destroy
  has_many :companies, through: :user_companies

  def has_role?(name)
    roles.pluck(:name).member?(name.to_s)
  end

  def my_roles
    self.roles.map(&:name)
  end

  def my_companies
    self.companies.map(&:name)
  end

  def set_default_role
    self.roles ||= []
    role = Role.find_by(name: 'external_user') || 'external_user'
    ap "ROLE => #{role} == #{roles.include? role}"
    #self.roles << role unless roles.include? role
  end

  def set_default_company
    self.company ||= Company.first
  end

  def admin?
    self.my_roles.include? 'admin'
  end

  def self.roles_for_select
    Role.all.map do |role|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.i18n.roles.#{role.name}"), role.id]
    end.to_h
  end

end