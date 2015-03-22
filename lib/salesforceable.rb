def salesforceable_as (object_name, client_id: '', client_secret: '', fields_mapping: {})

  send :define_method, 'is_synced_with_salesforce' do 
    # Specific methods to ActiveRecord objects
    self.salesforce_id != nil
  end

  send :define_method, 'save_on_salesforce!' do |refresh_token, instance_url|
    
    connection_params = { 
      :refresh_token => refresh_token, 
      :instance_url  => instance_url, 
      :client_id => client_id, 
      :client_secret => client_secret
    }

    salesforce_client = Restforce.new connection_params
    salesforce_object_fields = {}

    fields_mapping.each do |model_field, salesforce_field|
        salesforce_object_fields[salesforce_field] = self[model_field]
    end

    salesfoce_object_id = salesforce_client.create!(object_name, salesforce_object_fields)
    
    # Specific methods to ActiveRecord objects
    self.salesforce_id = salesfoce_object_id
    self.save!

  end

  send :define_method, 'remove_from_salesforce!' do |refresh_token, instance_url|
    
    connection_params = { 
      :refresh_token => refresh_token, 
      :instance_url  => instance_url, 
      :client_id => client_id, 
      :client_secret => client_secret
    }

    salesforce_client = Restforce.new connection_params

    # Specific methods to ActiveRecord objects
    salesforce_client.destroy!(object_name, self.salesforce_id)
    self.salesforce_id = nil
    self.save!

  end

end

require 'restforce'
