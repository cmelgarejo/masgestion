require 'remote_table'
ActiveAdmin.register Client do
  config.clear_action_items!

  actions :all, except: [:destroy, :show, :new]

  permit_params :first_name, :last_name, :document_type_id, :company_id, :document,
                :birthdate, :address, :country, :state, :city, :lat, :lng, :active, :client_contact_mean_id,
                #Contact means
                client_contact_means_attributes: [:id, :client_id, :target, :contact_mean_types_id,
                                                  :observations, :_destroy],
                client_products: [:id, :client_id],
                history_types: [:id, :description],
                client_collection_history_attributes: [:id, :client_id, :client_collection_category_id, :client_product_id,
                                                       :client_collection_type_id, :user_id, :client_contact_mean_id, :history_type_id,
                                                       :promise_amount, :promise_date, :observations, :debt_collector],
                client_products_attributes: [:id, :client_id, :company_product_id, :balance, :arrears, :days_late,
                                             :observations],
                client_references_attributes: [:id, :client_id, :first_name, :last_name, :phone, :observations]

  menu parent: "#{I18n.t('People')}", priority: 3, label: I18n.t('Client_Manager')
  # scope_to do
  #   Client.where('user _id = ?', current_user.id)
  # end
  scope_to :current_user, if: proc {!current_user.admin?}

  action_item(:index) do
    link_to I18n.t('Import_For_Campaign'), action: :preview if current_user.admin?
  end

  collection_action :preview do
    render 'admin/clients/preview'
  end

  collection_action :upload do
    render 'admin/clients/upload'
  end

  collection_action :preview, method: :post do
    if params[:preview]
      begin
        xls = RemoteTable.new "file://#{params[:preview][:file].tempfile.path}"
        @data = xls.rows.length > 0 ? xls.rows[0].keys : []
        @file_path = "file://#{params[:preview][:file].tempfile.path}"
        render 'admin/clients/upload'
      rescue => e
        redirect_to preview_admin_clients_path, alert: e.to_s
      end
    end
  end

  collection_action :import, method: :post do
    upload_params = params[:upload]
    document_type = DocumentType.find(upload_params[:client_document_type_id])
    file_path = upload_params[:file_path]
    # company = Company.find(upload_params[:company_id])
    campaign = Campaign.find(upload_params[:campaign_id])
    agents = (UserRole.where role: Role.where(name: 'campaign_user').first).select {|ur| ur.user}.map &:user
    # total_rows = export.rows.length
    # agent_quota = total_rows / agents.length
    # agents_balance = agents.each do |agent|
    #   {
    #       "#{agent.id}": agent_quota
    #   }
    # end
    if file_path
      @errors = ''
      CampaignDetail.where(campaign: campaign).delete_all
      export = RemoteTable.new file_path
      export.rows.each do |row|
        begin
          k_first_name = upload_params[:client_first_name]
          k_last_name = upload_params[:client_last_name]
          k_document = upload_params[:client_document]
          k_birthdate = upload_params[:client_birthdate]
          k_address = upload_params[:client_address]
          k_country = upload_params[:client_country]
          k_state = upload_params[:client_state]
          k_city = upload_params[:client_city]
          k_lat = upload_params[:client_lat]
          k_lng = upload_params[:client_lng]
          k_ref_code = upload_params[:client_ref_code]
          first_name = row[k_first_name].to_s.strip
          last_name = row[k_last_name].to_s.strip
          document = row[k_document].to_s.strip.gsub(/\.0*$/, '')
          birthdate = row[k_birthdate].to_s.strip
          address = row[k_address].to_s.strip
          country = row[k_country].to_s.strip
          state = row[k_state].to_s.strip
          city = row[k_city].to_s.strip
          lat = row[k_lat]
          lng = row[k_lng]
          ref_code = row[k_ref_code].to_s.strip
          client = Client.where(document_type: document_type, document: document)
          if Client.exists? client
            client = client.first
            Client.update client.id, first_name: first_name, last_name: last_name, document_type: document_type, document: document.to_s.strip, address: address,
                          birthdate: birthdate, country: country, state: state, city: city, lat: lat, lng: lng, ref_code: ref_code, original_data: row
          else
            client = Client.create! first_name: first_name, last_name: last_name, document_type: document_type, document: document, address: address,
                                    birthdate: birthdate, country: country, state: state, city: city, lat: lat, lng: lng, ref_code: ref_code, original_data: row
          end
          if client.valid?
            ClientImport.create! client: client, original_data: row
            upload_params.select {|k| k[/contact_.*/]}.each do |contact_type_selected|
              contact_mean_type = ContactMeanType.find(contact_type_selected.gsub('contact_', '').to_i)
              k_contact_type = upload_params[contact_type_selected]
              target = row[k_contact_type].to_s.strip.gsub(/\.0*$/, '')
              ClientContactMean.create! client_id: client.id, contact_mean_types_id: contact_mean_type.id, target: target if target && target != ''
            end
            CampaignDetail.create! campaign: campaign, client_id: client.id, user_id: agents.sample.id
          end
        rescue => e
          @errors += "<span class='import_error_header'>#{I18n.t('Error_while_processing')}</span></br>"
          @errors += "<span class='import_error_message'>#{e.to_s} - #{I18n.t('Error_while_processing')}</span></br>"
          @errors += "<span class='import_error_detail'>#{row}</span></br>"
        end
      end
      redirect_to preview_admin_clients_path, alert: "#{I18n.t('Import_Success_first')} #{export.rows.length} #{I18n.t('Import_Success_last')}"
    end
  end


  filter :client_collection_history_user_id, as: :select, collection: User.all, if: proc {current_user.admin?}

  filter :document_type
  filter :document
  filter :full_name
  filter :client_collection_history_client_collection_category_id, as: :select, collection: ClientCollectionCategory.all
  filter :client_collection_history_observations, as: :string
  filter :client_collection_history_updated_at, as: :date_range
  filter :client_collection_history_history_type_id, as: :select, collection: HistoryType.all
  filter :client_collection_history_promise_date, as: :date_range, start_date: Date.today, end_date: Date.today + 30
  filter :client_collection_history_promise_amount, as: :numeric
  filter :client_contact_means_target, as: :string
  # filter :birthdate
  # filter :active
  # filter :created_at
  # filter :updated_at

  index title: I18n.t('Client_Manager') do
    # selectable_column
    # id_column
    column I18n.t('Name') do |resource|
      link_to resource.full_name, edit_admin_client_path(resource)
    end
    column I18n.t('Document_Type'), :document_type
    column I18n.t('Document'), :document
    column I18n.t('Address') do |resource|
      state = resource.country && resource.country != '' ? CountryStateSelect.collect_states(resource.country).select {|state| state.last.to_s == resource.state}.last.first : nil
      country = resource.country && resource.country != '' ? CountryStateSelect.countries_collection.select {|country| country.last.to_s == resource.country}.last.first : nil
      address = "#{resource.address}, #{resource.city}, #{state}, #{country}"
      address == ', , , ' ? '' : address
    end
    # column I18n.t('Created_at'), :created_at
    # column I18n.t('Updated_at'), :updated_at

    actions
  end

  sidebar I18n.t('Client'), only: :edit do
    attributes_table_for :client do
      row I18n.t('Full_Name') do
        resource.full_name
      end
      row "#{resource.document_type.name.upcase}" do
        resource.document
      end
      row I18n.t('Address') do
        state = resource.country && resource.country != '' ? CountryStateSelect.collect_states(resource.country).select {|state| state.last.to_s == resource.state}.last.first : nil
        country = resource.country && resource.country != '' ? CountryStateSelect.countries_collection.select {|country| country.last.to_s == resource.country}.last.first : nil
        "#{resource.address}, #{resource.city}, #{state}, #{country}"
      end
      # row I18n.t('Created_at') do
      #   resource.created_at
      # end
      # row I18n.t('Updated_at') do
      #   resource.updated_at
      # end
    end
    panel I18n.t('Client_Contact_Means') do
      attributes_table_for :client_contact_means do
        resource.client_contact_means.each do |contact|
          row contact.contact_mean_type do
            "#{contact.target}"
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    tabs do
      tab I18n.t('Client_Collection_History') do
        panel I18n.t('-') do
          f.has_many :client_collection_history, heading: false, new_record: true, allow_destroy: false do |history|
            history.inputs do
              history.input :history_type_id, as: :select, label: I18n.t('History_Type'),
                            collection: HistoryType.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: false}
              history.input :client_product_id, as: :select, label: I18n.t('Client_Products'),
                            collection: ClientProduct.products_for_client(params[:id]), include_blank: false, input_html: {class: 'select2', disabled: false}
              history.input :client_contact_mean_id, as: :select, label: I18n.t('Client_Contact_Means'), required: false,
                            collection: resource.contacts_for_client, include_blank: false, input_html: {class: 'select2', disabled: false}
              history.input :client_collection_category_id, as: :select, label: I18n.t('Category_Action'),
                            collection: ClientCollectionCategory.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: false}
              history.input :client_collection_type_id, as: :select, label: I18n.t('Contact_Type'),
                            collection: ClientCollectionType.all, include_blank: false, input_html: {class: 'select2', disabled: false}
              # history.input :balance, label: I18n.t('Balance')
              history.input :promise_amount, label: I18n.t('activerecord.attributes.client_collection_history.promise_amount')
              history.input :promise_date, label: I18n.t('activerecord.attributes.client_collection_history.promise_date')
              # history.input :total_with_arrears, label: I18n.t('Total_With_Arrears'), input_html: {disabled: true}
              # history.input :days_late, label: I18n.t('Days_Late')
              history.input :debt_collector, label: I18n.t('Debt_Collector')
              history.input :observations, label: I18n.t('Observations')
              history.input :user_id, :input_html => {:value => current_user.id}, as: :hidden
            end
          end
          table_for resource.client_collection_history.order(
              (params[:order] ? params[:order] : 'created_at_desc').gsub('_asc', ' asc').gsub('_desc', ' desc')
          ), sortable: true, class: 'history_table' do
            column(:history_type, sortable: :history_type_id) {|r| r.history_type}
            column(:client_contact_mean, sortable: :client_contact_mean_id) {|r| ClientContactMean.find(r.client_contact_mean_id) if r.client_contact_mean_id}
            column(:client_collection_category, sortable: :client_collection_category_id) {|r| r.client_collection_category}
            column(:client_collection_type, sortable: :client_collection_type_id) {|r| r.client_collection_type}
            column(:client_products, sortable: :client_product_id) {|r| r.client_product}
            column :promise_amount
            column :promise_date
            column :observations
            column :debt_collector
            column :created_at
          end
        end
      end
      tab I18n.t('Client_Products') do
        panel I18n.t('Details') do
          table_for resource.client_products do
            # column :company_product_id, as: :select, label: I18n.t('Client_Products'),
            #        collection: CompanyProduct.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: true}
            column I18n.t('Company'), :company_of_product
            column I18n.t('Client_Products'), :company_product
            column I18n.t('Balance'), :balance
            column I18n.t('Arrears'), :arrears
            column I18n.t('Total_With_Arrears'), :total_with_arrears
            column I18n.t('Days_Late'), :days_late
            column I18n.t('Last_Payment_Date'), :last_payment_date
            column I18n.t('Observations'), :observations
          end
        end
      end
    end
  end

  controller do
    def permitted_params
      params.permit!
    end

    def update
      super do |format|
        redirect_to edit_admin_client_path(resource.id), alert: "#{I18n.t('History_Added')}" and return if resource.valid?
      end
    end

  end

  # member_action :pdf, method: :get do
  #   render(pdf: "item-#{resource.id}.pdf")
  # end
  #
  # action_item :view, only: [:show, :edit] do
  #   link_to I18n.t('Print'), "#{admin_item_path(resource)}/pdf", target: '_blank'
  # end
end
