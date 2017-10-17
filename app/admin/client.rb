ActiveAdmin.register Client, as: 'ClientManager' do
  actions :all, except: [:destroy]

  permit_params :first_name, :last_name, :document_type_id, :company_id, :document,
                :birthdate, :address, :country, :state, :city, :lat, :lng, :active,
                #Contact means
                client_contact_means_attributes: [:id, :client_id, :target, :contact_mean_types_id,
                                                  :observations, :_destroy],
                client_products: [:id, :client_id, :_destroy],
                client_collection_history: [:id, :client_id, :client_collection_category_id,
                                            :client_collection_type_id, :user_id, :promise_amount, :promise_date,
                                            :observations, :debt_collector, :_destroy],
                client_products_attributes: [:id, :client_id, :company_product_id, :balance, :arrears, :days_late,
                                             :observations, :_destroy,
                                             client_product_payments_attributes: [:id, :client_id, :client_product_id,
                                                                                  :value, :payment_date, :_destroy]],
                client_references_attributes: [:id, :client_id, :first_name, :last_name, :phone, :observations,
                                               :_destroy]

  menu if: proc {current_user.admin?}, parent: I18n.t('People'), priority: 99, label: I18n.t('Clients_Total_List')

  index title: I18n.t('Clients') do
    selectable_column
    #id_column
    column I18n.t('Name') do |resource|
      link_to resource.full_name, admin_client_manager_path(resource)
    end
    #column I18n.t('Reference_Code'), :ref_code
    column I18n.t('Document_Type'), :document_type
    column I18n.t('Document'), :document
    column I18n.t('Company'), :company
    bool_column I18n.t('Active'), :active
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  show do
    tabs do
      tab I18n.t('Client') do
        attributes_table do
          row I18n.t('Name') do
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
          bool_row I18n.t('Active') do
            resource.active
          end
          row I18n.t('Created_at') do
            resource.created_at
          end
          row I18n.t('Updated_at') do
            resource.updated_at
          end
        end
      end
      # tab I18n.t('Something') do
      #   table_for resource.company_products do
      #     column :id
      #     column I18n.t('Description'), :description
      #     column I18n.t('created_at'), :created_at
      #     column I18n.t('updated_at'), :update_at
      #   end
      # end
    end
    #active_admin_comments
  end

  filter :document_type
  filter :document
  filter :first_name
  filter :last_name
  filter :birthdate
  filter :active
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    tabs do
      tab I18n.t('Client_Details') do
        f.inputs do
          f.input :first_name, required: true, label: I18n.t('First_Name'), input_html: {autofocus: true}
          f.input :last_name, required: true, label: I18n.t('Last_Name')
          f.input :document_type_id, as: :select, label: I18n.t('Document_Type'), collection: DocumentType.all,
                  include_blank: false, input_html: {class: 'select2'}
          f.input :document, required: true, label: I18n.t('Document')
          f.input :address, label: I18n.t('Address')
          f.input :company, as: :select, label: I18n.t('Company'), collection: Company.all, include_blank: false,
                  input_html: {class: 'select2'} #TODO: limit scope by user in the future
          f.input :country, as: :select, include_blank: false, label: I18n.t('Country'), #input_html: {class: 'select2'},
                  collection: Client.countries
          f.input :state, as: :select, include_blank: false, label: I18n.t('Region'), #input_html: {class: 'select2'},
                  collection: CountryStateSelect.states_collection(f, country: :country),
                  options: CountryStateSelect.state_options(form: f, field_names: {country: :country, state: :state})
          f.input :city, as: :select, include_blank: false, label: I18n.t('City'), #input_html: {class: 'select2'},
                  collection: CountryStateSelect.cities_collection(f, country: :country, state: :state),
                  options: CountryStateSelect.city_options(form: f, field_names: {state: :state, city: :city})
          if f.object.new_record?
            f.input :active, label: I18n.t('Active'), input_html: {checked: true}
          else
            f.input :active, label: I18n.t('Active')
          end
        end
      end
      tab I18n.t('Client_Contact_Means') do
        f.inputs do
          f.has_many :client_contact_means, heading: false, new_record: true, allow_destroy: true do |contact_mean|
            contact_mean.inputs do
              contact_mean.input :contact_mean_types_id, as: :select, label: I18n.t('Contact_Mean_Type'),
                                 collection: ContactMeanType.all, include_blank: false, input_html: {class: 'select2'} #TODO: limit scope by user in the future
              contact_mean.input :target, label: I18n.t('Target')
            end
          end
        end
      end
      tab I18n.t('Client_Products') do
        f.inputs do
          f.has_many :client_products, heading: false, new_record: false, allow_destroy: false do |product|
            product.inputs do
              product.input :company_product_id, as: :select, label: I18n.t('Client_Products'),
                            collection: CompanyProduct.all_for_select, include_blank: false, input_html: {class: 'select2', disabled: true} #TODO: limit scope by user in the future
              product.input :balance, label: I18n.t('Balance')
              product.input :arrears, label: I18n.t('Arrears')
              product.input :total_with_arrears, label: I18n.t('Total_With_Arrears'), input_html: {disabled: true}
              product.input :days_late, label: I18n.t('Days_Late')
              product.input :observations, label: I18n.t('Observations')
              product.has_many :client_product_payments, new_record: true, allow_destroy: false do |payment|
                payment.input :value, label: I18n.t('Value')
                if payment.object.new_record?
                  payment.input :payment_date, as: :datepicker, label: I18n.t('Payment_Date'), input_html: {value: Date.today}
                else
                  payment.input :payment_date, as: :datepicker, label: I18n.t('Payment_Date'), datepicker_options: {min_date: Date.today}
                end
                payment.input :observations, label: I18n.t('Observations')
              end
            end
          end
        end
      end
      tab I18n.t('Client_References') do
        f.inputs do
          f.has_many :client_references, heading: false, new_record: true, allow_destroy: true do |product|
            product.inputs do
              product.input :first_name, label: I18n.t('First_Name')
              product.input :last_name, label: I18n.t('Last_Name')
              product.input :phone, label: I18n.t('Phone')
              product.input :observations, label: I18n.t('Observations')
            end
          end
        end
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