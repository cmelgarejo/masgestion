module ActiveAdmin
  module ProtectFromForgeryDevise
    extend ActiveSupport::Concern

    included do
      protect_from_forgery prepend: true, with: :exception
      # before_filter :restrict_to_own_site
    end

    private

    # def restrict_to_own_site
    #   unless current_site == current_admin_user.site
    #     render_404
    #   end
    # end
  end
end