class CreateAdminService
  def call(roles)
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email, name: Rails.application.secrets.admin_name) do |user|
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
      #ap roles.inspect
      user.roles << roles
    end
    user
  end
end