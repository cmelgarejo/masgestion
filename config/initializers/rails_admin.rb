# RailsAdmin.config do |config|
#
#   ### Popular gems integration
#
#   ## == Devise ==
#   config.authenticate_with do
#     warden.authenticate! scope: :user
#   end
#   config.current_user_method(&:current_user)
#
#   ## == Cancan ==
#   # config.authorize_with :cancan
#
#   ## == Pundit ==
#   config.authorize_with :pundit
#
#   ## == PaperTrail ==
#   config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
#
#   ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
#
#   ## == Gravatar integration ==
#   ## To disable Gravatar integration in Navigation Bar set to false
#   # config.show_gravatar true
#
#   config.model 'PaperTrail::Version' do
#     visible true
#   end
#
#   config.model 'PaperTrail::VersionAssociation' do
#     visible true
#   end
#
#   config.authorize_with do
#     redirect_to main_app.root_path unless current_user.admin?
#   end
#
#   config.actions do
#     dashboard                     # mandatory
#     index                         # mandatory
#     new
#     export
#     #bulk_delete
#     show
#     edit
#     delete
#     show_in_app
#     history_index
#     history_show
#
#     ## With an audit adapter, you can add:
#   end
#
#   config.model 'Company' do
#     object_label_method do
#       :custom_label_method
#     end
#   end
#
#   def custom_label_method
#     "Team #{self.name}"
#   end
#
#   ActiveRecord::Base.descendants.each do |imodel|
#     config.model "#{imodel.name}" do
#       list do
#         exclude_fields :created_at, :updated_at
#       end
#     end
#   end
#
# end
