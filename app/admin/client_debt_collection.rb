require 'remote_table'
ActiveAdmin.register Client, as: 'ClientDebtCollection' do
  config.clear_action_items!

  actions :all, except: [:destroy, :show, :new]

  permit_params :first_name, :last_name, :document_type_id, :company_id, :document,
                :birthdate, :address, :country, :state, :city, :lat, :lng, :active, :client_contact_means_id,
                #Contact means
                client_contact_means_attributes: [:id, :client_id, :target, :contact_mean_types_id,
                                                  :observations, :_destroy],
                client_products: [:id, :client_id],
                history_types: [:id, :description],
                client_collection_history_attributes: [:id, :client_id, :client_collection_category_id, :client_product_id,
                                                       :client_collection_type_id, :user_id, :client_contact_means_id, :history_type_id,
                                                       :promise_amount, :promise_date, :observations, :debt_collector],
                client_products_attributes: [:id, :client_id, :company_product_id, :balance, :arrears, :days_late,
                                             :observations],
                client_references_attributes: [:id, :client_id, :first_name, :last_name, :phone, :observations]

  menu parent: "#{I18n.t('People')}", priority: 3, label: I18n.t('Client_Collection_History')

  action_item(:index) do
    link_to I18n.t('Import_For_Campaign'), action: :upload
  end

  collection_action :upload do
    render 'admin/clients/upload'
  end

  collection_action :import, :method => :post do
    dt_ci = DocumentType.where(description: 'CI').first
    p "IMPORT...file://#{params[:upload][:file].tempfile.path}"
    gestiones = RemoteTable.new "file://#{params[:upload][:file].tempfile.path}", glob: '/Gestiones*.xls'
    #numero_cedula	nombre_completo	direccion	telefono1_titular	telefono2_titular	telefono_celular_titular	telefono_laboral_titular	numero_clave	numero_socio	numero_cuota	fecha_desembolso	fecha_ultimo_pago	fecha_vencimiento	monto_desembolso	monto_cuota	monto_saldo	cantidad_cuota_vencida	monto_vencido	monto_interes_corriente	monto_interes_moratorio	monto_gasto_gestion	debito_automatico	formula	cantidad_cuota_pagada	tasa_interes1	tasa_interes2	dias_de_mora	ci_garante1	nombre_garante1	telefono1_garante1	telefono2_garante1	telefono3_garante1	ci_garante2	nombre_garante2	telefono1_garante2	telefono2_garante2	telefono3_garante2	fecha_ultimo_contacto	respuesta_ultimo_contacto
    #first_name, last_name, document_type_id, document, birthdate, address, country, state, city, lat, lng, active, company_id, ref_code
    gestiones.rows.each do |row|
      fullname = row['nombre_completo'].split(',').map(&:strip).reverse
      document = row['numero_cedula'].to_s.strip.gsub(/\.0*$/, '')
      address = row['direccion'].to_s.strip
      first_name = fullname.first
      last_name = fullname.last
      if Client.where(document_type: dt_ci, document: document).length < 1
        Client.create first_name: first_name, last_name: last_name, document_type: dt_ci, document: document.to_s.strip, address: address, original_data: row
      end
    end
    cuotas = RemoteTable.new "file://#{params[:upload][:file].tempfile.path}", glob: '/Cuotas*.xls'
    pagos = RemoteTable.new "file://#{params[:upload][:file].tempfile.path}", glob: '/Pagos*.xls'
    referencias = RemoteTable.new "file://#{params[:upload][:file].tempfile.path}", glob: '/Referencias*.xls'
    p "FILE => #{cuotas.rows.length} - #{cuotas.rows.inspect}"
    p "FILE => #{gestiones.rows.length} - #{gestiones.rows.inspect}"
    p "FILE => #{pagos.rows.length} - #{pagos.rows.inspect}"
    p "FILE => #{referencias.rows.length} - #{referencias.rows.inspect}"

    #do stuff here
    redirect_to admin_client_debt_collections_path, alert: "#{I18n.t('Import_Success')}"
  end

  filter :document_type
  filter :document
  filter :first_name
  filter :last_name
  filter :birthdate
  filter :active
  filter :created_at
  filter :updated_at

  index title: I18n.t('Client_Collection_History') do
    selectable_column
    #id_column
    column I18n.t('Name') do |resource|
      link_to resource.full_name, edit_admin_client_debt_collection_path(resource)
    end
    column I18n.t('Document_Type'), :document_type
    column I18n.t('Document'), :document
    column I18n.t('Company'), :company
    bool_column I18n.t('Active'), :active
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
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
        state = resource.country ? CountryStateSelect.collect_states(resource.country).select {|state| state.last.to_s == resource.state}.last.first : nil
        country = resource.country ? CountryStateSelect.countries_collection.select {|country| country.last.to_s == resource.country}.last.first : nil
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
          table_for resource.client_collection_history.order(
              (params[:order] ? params[:order] : 'created_at_desc').gsub('_asc', ' asc').gsub('_desc', ' desc')
          ), sortable: true do
            column(:history_type, sortable: :history_type_id) {|r| r.history_type}
            column(:client_contact_means, sortable: :client_contact_means_id) {|r| ClientContactMean.find(r.client_contact_means_id)}
            column(:client_collection_category, sortable: :client_collection_category_id) {|r| r.client_collection_category}
            column(:client_collection_type, sortable: :client_collection_type_id) {|r| r.client_collection_type}
            column(:client_products, sortable: :client_product_id) {|r| r.client_product}
            column :promise_amount
            column :promise_date
            column :observations
            column :debt_collector
            column :created_at
          end
          f.has_many :client_collection_history, heading: false, new_record: true, allow_destroy: false do |history|
            history.inputs do
              history.input :history_type_id, as: :select, label: I18n.t('History_Type'),
                            collection: HistoryType.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: false} #TODO: limit scope by user in the future
              history.input :client_product_id, as: :select, label: I18n.t('Client_Products'),
                            collection: ClientProduct.products_for_client(params[:id]), include_blank: false, input_html: {class: 'select2', disabled: false} #TODO: limit scope by user in the future
              history.input :client_contact_means_id, as: :select, label: I18n.t('Client_Contact_Means'), required: false,
                            collection: ClientContactMean.contacts_for_client(params[:id]), include_blank: false, input_html: {class: 'select2', disabled: false} #TODO: limit scope by user in the future
              history.input :client_collection_category_id, as: :select, label: I18n.t('Category_Action'),
                            collection: ClientCollectionCategory.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: false} #TODO: limit scope by user in the future
              history.input :client_collection_type_id, as: :select, label: I18n.t('Contact_Type'),
                            collection: ClientCollectionType.all, include_blank: false, input_html: {class: 'select2', disabled: false} #TODO: limit scope by user in the future
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
        end
      end
      tab I18n.t('Client_Products') do
        panel I18n.t('Details') do
          table_for resource.client_products do
            # column :company_product_id, as: :select, label: I18n.t('Client_Products'),
            #        collection: CompanyProduct.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: true} #TODO: limit scope by user in the future
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
      # tab I18n.t('Client_Details') do
      #   f.inputs do
      #     f.input :first_name, required: true, label: I18n.t('First_Name'), input_html: {autofocus: true}
      #     f.input :last_name, required: true, label: I18n.t('Last_Name')
      #     f.input :document_type_id, as: :select, label: I18n.t('Document_Type'), collection: DocumentType.all,
      #             include_blank: false, input_html: {class: 'select2'}
      #     f.input :document, required: true, label: I18n.t('Document')
      #     f.input :address, label: I18n.t('Address')
      #     f.input :company, as: :select, label: I18n.t('Company'), collection: Company.all, include_blank: false,
      #             input_html: {class: 'select2'} #TODO: limit scope by user in the future
      #     f.input :country, as: :select, include_blank: false, label: I18n.t('Country'), #input_html: {class: 'select2'},
      #             collection: Client.countries
      #     f.input :state, as: :select, include_blank: false, label: I18n.t('Region'), #input_html: {class: 'select2'},
      #             collection: CountryStateSelect.states_collection(f, country: :country),
      #             options: CountryStateSelect.state_options(form: f, field_names: {country: :country, state: :state})
      #     f.input :city, as: :select, include_blank: false, label: I18n.t('City'), #input_html: {class: 'select2'},
      #             collection: CountryStateSelect.cities_collection(f, country: :country, state: :state),
      #             options: CountryStateSelect.city_options(form: f, field_names: {state: :state, city: :city})
      #     if f.object.new_record?
      #       f.input :active, label: I18n.t('Active'), input_html: {checked: true}
      #     else
      #       f.input :active, label: I18n.t('Active')
      #     end
      #   end
      # end
      # tab I18n.t('Client_Contact_Means') do
      #   f.inputs do
      #     f.has_many :client_contact_means, heading: false, new_record: true, allow_destroy: true do |contact_mean|
      #       contact_mean.inputs do
      #         contact_mean.input :contact_mean_types_id, as: :select, label: I18n.t('Contact_Mean_Type'),
      #                            collection: ContactMeanType.all, include_blank: false, input_html: {class: 'select2'} #TODO: limit scope by user in the future
      #         contact_mean.input :target, label: I18n.t('Target')
      #       end
      #     end
      #   end
      # end
      # tab I18n.t('Client_Products') do
      #   f.inputs do
      #     f.has_many :client_products, heading: false, new_record: false, allow_destroy: false do |product|
      #       product.inputs do
      #         product.input :company_product_id, as: :select, label: I18n.t('Client_Products'),
      #                       collection: CompanyProduct.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: true} #TODO: limit scope by user in the future
      #         product.input :balance, label: I18n.t('Balance')
      #         product.input :arrears, label: I18n.t('Arrears')
      #         product.input :total_with_arrears, label: I18n.t('Total_With_Arrears'), input_html: {disabled: true}
      #         product.input :days_late, label: I18n.t('Days_Late')
      #         product.input :observations, label: I18n.t('Observations')
      #       end
      #     end
      #   end
      # end
      # tab I18n.t('Client_References') do
      #   f.inputs do
      #     f.has_many :client_references, heading: false, new_record: true, allow_destroy: true do |product|
      #       product.inputs do
      #         product.input :first_name, label: I18n.t('First_Name')
      #         product.input :last_name, label: I18n.t('Last_Name')
      #         product.input :last_name, label: I18n.t('Phone')
      #         product.input :observations, label: I18n.t('Observations')
      #       end
      #     end
      #   end
      # end
    end
  end

  controller do
    def permitted_params
      params.permit!
    end

    def update
      super do |format|
        redirect_to edit_admin_client_debt_collection_path(resource.id), alert: "#{I18n.t('History_Added')}" and return if resource.valid?
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