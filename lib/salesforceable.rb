class Salesforceable

    require 'restforce'

    CLIENT_ID = "3MVG9sG9Z3Q1RlbdYs9verSsP3ozsVYS7iinnYoPX_wY7odwR6_c2w1FOwmavvcE_86G6ZKGOuNl9TWMrbxd."
    CLIENT_SECRET = "8612542553551939632"

    FIELDS_MAPPING = {
        'name' => 'FirstName',
        'last_name' => 'LastName',
        'email' => 'Email',
        'company' => 'Company',
        'job_title' => 'Title',
        'phone' => 'Phone'
    }

    def self.save_on_salesforce(object_name, model_object, refresh_token, instance_url)

        connection_params = { 
          :refresh_token => refresh_token, 
          :instance_url  => instance_url, 
          :client_id => CLIENT_ID, 
          :client_secret => CLIENT_SECRET
        }

        salesforce_client = Restforce.new connection_params
        salesforce_object_fields = {}

        FIELDS_MAPPING.each do |model_field, salesforce_field|
            salesforce_object_fields[salesforce_field] = model_object[model_field]
        end

        salesfoce_object_id = salesforce_client.create!(object_name, salesforce_object_fields)
        return salesfoce_object_id

    end

    def self.remove_from_salesforce(object_name, object_id, refresh_token, instance_url)

        connection_params = { 
          :refresh_token => refresh_token, 
          :instance_url  => instance_url, 
          :client_id => CLIENT_ID, 
          :client_secret => CLIENT_SECRET
        }

        salesforce_client = Restforce.new connection_params

        salesforce_client.destroy!('Lead', object_id)

    end
    
end