class ApplicationController < ActionController::Base
  # include Pundit
  protect_from_forgery prepend: true, with: :exception
  #before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :reload_rails_admin, if: :rails_admin_path?
  before_action :set_paper_trail_whodunnit

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def peek_enabled?
    current_user.has_role? 'admin' if current_user
  end

  def set_admin_timezone
    Time.zone = Rails.application.secrets.install_timezone #'Mexico/General'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def user_for_paper_trail
    current_user && current_user.has_role?('admin') ? current_user.try(:id) : 1
  end

  # def reload_rails_admin
  #   models = %W(User UserProfile)
  #   models.each do |m|
  #     RailsAdmin::Config.reset_model(m)
  #   end
  #   RailsAdmin::Config::Actions.reset
  #
  #   load("#{Rails.root}/config/initializers/rails_admin.rb")
  # end
  #
  # def rails_admin_path?
  #   controller_path =~ /rails_admin/ && Rails.env.development?
  # end

end
