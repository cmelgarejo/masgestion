require 'remote_table'
ActiveAdmin.register ClientCollectionHistory, as: 'ClientHistory' do
  config.clear_action_items!

  actions :all, except: [:destroy, :show, :new]

  menu parent: "#{I18n.t('People')}", priority: 3, label: I18n.t('Client_History')

  scope_to :current_user, association_method: :client_collection_histories, if: proc {!current_user.admin?}

  filter :client
  filter :client_collection_category
  # filter :client_contact_mean
  # filter :client_product
  filter :history_type
  filter :user
  filter :promise_amount
  filter :promise_date
  filter :observations
  filter :debt_collector
  filter :updated_at
  filter :created_at

  index title: I18n.t('Client_Collection_History') do
    selectable_column
    column I18n.t('Name') do |resource|
      link_to resource.client.full_name, edit_admin_client_path(resource.client)
    end
    column(:history_type, sortable: :history_type_id) {|r| r.history_type}
    column(:client_contact_mean, sortable: :client_contact_mean_id) {|r| ClientContactMean.find(r.client_contact_mean_id) if r.client_contact_mean_id}
    column(:client_collection_category, sortable: :client_collection_category_id) {|r| r.client_collection_category}
    column(:client_collection_type, sortable: :client_collection_type_id) {|r| r.client_collection_type}
    column(:client_products, sortable: :client_product_id) {|r| r.client_product}
    column :promise_amount
    column :promise_date
    column :observations
    column :debt_collector
    column I18n.t('Updated_at'), :updated_at
  end
end