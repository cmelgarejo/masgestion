ActiveAdmin.register Campaign do
  permit_params :name, :active, :status, :portfolio_id, :start, :end

  menu parent: I18n.t('Companies'), priority: 4, label: I18n.t('Campaign')

  index title: I18n.t('Campaigns') do
    selectable_column
    #id_column
    column I18n.t('Name') do |resource|
      link_to resource.name, admin_campaign_path(resource)
    end

    bool_column I18n.t('Active'), :active
    column I18n.t('Start'), :start
    column I18n.t('End'), :end
    column I18n.t('Status'), :status
    column I18n.t('Portfolio'), :portfolio
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  show do
    tabs do
      tab I18n.t('Campaigns') do
        attributes_table do
          row I18n.t('Name') do
            resource.name
          end
          bool_row I18n.t('Active') do
            resource.active
          end
          row I18n.t('Start') do
            resource.start
          end
          row I18n.t('End') do
            resource.end
          end
          row I18n.t('Status') do
            I18n.t("activerecord.attributes.campaign.i18n.status.#{resource.status}")
          end
          row I18n.t('Created_at') do
            resource.created_at
          end
          row I18n.t('Updated_at') do
            resource.updated_at
          end
        end
      end
      tab I18n.t('Campaign_Details') do
        panel I18n.t('-') do
          table_for resource.campaign_details, sortable: true, class: 'history_table' do |details|
            column I18n.t('Client') do |resource|
              Client.find(resource.client_id).full_name
            end
            column I18n.t('User') do |resource|
              User.find(resource.user_id).name
            end
            column I18n.t('Observations'), :observations
            column I18n.t('created_at'), :created_at
            column I18n.t('updated_at'), :update_at
          end
        end
      end
    end
    #active_admin_comments
  end

  filter :name
  filter :active
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    f.inputs I18n.t('Portfolio_Details') do
      f.input :name, label: I18n.t('Name'), input_html: {autofocus: true}, required: true
      f.input :portfolio_id, as: :select, collection: Portfolio.all, include_blank: false, input_html: {class: 'select2'} #TODO: limit scope by user in the future
      f.input :status, as: :select, collection: Campaign.statuses_for_select, include_blank: false, input_html: {class: 'select2'} #TODO: limit scope by user in the future
      if f.object.new_record?
        f.input :start, as: :datepicker, label: I18n.t('Start'), input_html: {value: Date.today}
        f.input :end, as: :datepicker, label: I18n.t('End'), input_html: {value: Date.today + 1}
        f.input :active, label: I18n.t('Active'), input_html: {checked: true}
      else
        f.input :start, as: :datepicker, label: I18n.t('Start'), datepicker_options: {min_date: Date.today}
        f.input :end, as: :datepicker, label: I18n.t('End'), datepicker_options: {min_date: Date.today + 1}
        f.input :active, label: I18n.t('Active')
      end
    end
  end

end