#ActiveAdmin::BaseController.send(:include, ActiveAdmin::ProtectFromForgeryDevise)
ActiveAdmin::Devise::SessionsController.class_eval do
  protect_from_forgery prepend: true, with: :exception #Damn you Rails 5, and prepend: false by default! >:(
end
ActiveadminAddons.setup do |config|
  # Change to "default" if you want to use ActiveAdmin's default select control.
  config.default_select = 'default'
end
