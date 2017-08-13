class CreateCompanyService
  def call
    Company.find_or_create_by!(name:Rails.application.secrets.admin_company, description: Rails.application.secrets.admin_company_description, enabled: true)
  end
end
