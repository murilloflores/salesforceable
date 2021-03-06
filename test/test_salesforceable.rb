require 'minitest/autorun'
require 'salesforceable'

class SalesforceableTest < Minitest::Test
  
  class MyClass
    
    attr_accessor :name
    attr_accessor :email
    attr_accessor :salesforce_id
    attr_accessor :save_called

    def save!
      self.save_called = true
    end

    # This mimetize an ActiveRecord specific behavior, that let's you access properties as in a hash
    def [](property)
      if property == 'name'
        return self.name
      end

      if property == 'email'
        return self.email
      end      
    end

    salesforceable_as 'Lead', client_id: 'aa', client_secret: 'bb', fields_mapping: { 'name' => 'salesforce_name', 'email' => 'salesforce_email'}

  end

  def test_methods_injection
    assert MyClass.method_defined?('is_synced_with_salesforce?')
    assert MyClass.method_defined?('save_on_salesforce!')
    assert MyClass.method_defined?('remove_from_salesforce!')
  end

  def test_is_synced_check_field
    obj = MyClass.new()
    obj.salesforce_id = nil

    assert_equal false, obj.is_synced_with_salesforce?

    obj.salesforce_id = 'ASD#$@#$SAD'

    assert_equal true, obj.is_synced_with_salesforce?
  end

  def test_remove_from_salesforce

    obj = MyClass.new()
    obj.salesforce_id = 'AAAA99999000'
    obj.save_called = false
    
    restforce_client_mock = Minitest::Mock.new
    restforce_client_mock.expect(:destroy!, nil, ['Lead', 'AAAA99999000'])

    mock_wrapper = lambda { |connection_params|
      assert_equal 'aa', connection_params[:client_id]
      assert_equal 'bb', connection_params[:client_secret]
      assert_equal '1111111', connection_params[:refresh_token]
      assert_equal '2222222', connection_params[:instance_url]
      restforce_client_mock
    }

    Restforce.stub :new, mock_wrapper do
      obj.remove_from_salesforce!('1111111','2222222')
      assert_equal nil, obj.salesforce_id
      assert restforce_client_mock.verify
      assert_equal true, obj.save_called
    end

  end


  def test_save_on_salesforce

    obj = MyClass.new()
    obj.salesforce_id = nil
    obj.save_called = false
    obj.name = 'Ze da Silva'
    obj.email = 'ze@padaria.com'
    
    restforce_client_mock = Minitest::Mock.new
    restforce_client_mock.expect(:create!, 'SALESFORCEID8888', ['Lead', { 'salesforce_name' => 'Ze da Silva', 'salesforce_email' => 'ze@padaria.com'}])

    mock_wrapper = lambda { |connection_params|
      assert_equal 'aa', connection_params[:client_id]
      assert_equal 'bb', connection_params[:client_secret]
      assert_equal '1111111', connection_params[:refresh_token]
      assert_equal '2222222', connection_params[:instance_url]
      restforce_client_mock
    }

    Restforce.stub :new, mock_wrapper do
      obj.save_on_salesforce!('1111111','2222222')
      assert restforce_client_mock.verify
      assert_equal true, obj.save_called
      assert_equal 'SALESFORCEID8888', obj.salesforce_id
    end

  end


end