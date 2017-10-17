ActiveAdmin.register CampaignDetail do
  permit_params :campaign_id, :client_id, :user_id, :observations, :order
  actions :all, except: [:show]
  menu parent: I18n.t('Companies'), priority: 5, label: I18n.t('Campaign_Details')

  index title: I18n.t('Campaign_Details') do
    #selectable_column
    column I18n.t('Campaign') do |resource|
      Campaign.find(resource.campaign_id).name
    end
    column I18n.t('Client') do |resource|
      Client.find(resource.client_id).full_name
    end
    column I18n.t('User') do |resource|
      User.find(resource.user_id).name
    end
    column I18n.t('Order'), :order
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  filter :campaign
  filter :client
  filter :user
  filter :observations
  filter :order
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    f.inputs I18n.t('Campaign_Details') do
      f.input :campaign_id, as: :select, collection: Campaign.all, include_blank: false, input_html: {class: 'select2'}, label: I18n.t('Campaign')
      f.input :client_id, as: :select, collection: Client.all, include_blank: false, input_html: {class: 'select2'}, label: I18n.t('Client')
      f.input :user_id, as: :select, collection: User.all, include_blank: false, input_html: {class: 'select2'}, label: I18n.t('User')
      f.input :observations, label: I18n.t('Observations')
      f.input :order, as: :number, label: I18n.t('Order')
    end
  end

end