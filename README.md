# salesforceable

[![Build Status](https://travis-ci.org/murilloflores/salesforceable.svg)](https://travis-ci.org/murilloflores/salesforceable)

Salesforceable is a ruby gem that add 'save on salesforce' and 'remove from salesforce' functionality to Active Record's objects.
It's first purpose is to help Rails developers to integrate with Salesforce by providing a easy to setup and use interface. Note that salesforceable does not provide any way to get the Salesforce user authentication OAuth information to use Salesforce API (refresh_token and instance_url) although this is needed to use the gem. Obtaining this information is up to the developer. We recommend using the 'omniauth-salesforce' ruby gem to do so. To learn more about Salesforce Omniauth authentication process visit [Digging Deeper into OAuth 2.0 on Force.com](https://developer.salesforce.com/page/Digging_Deeper_into_OAuth_2.0_on_Force.com).

## Getting Started

First you need to add salesforceable to your Gemfile.
```ruby
gem 'salesforceable', :git => 'https://github.com/murilloflores/salesforceable.git'
```

Then run the bundle command to install it.

## Using it

After installing it you must add a field called 'salesforce_id' to the desired ActiveRecord model. 

```ruby
rails g migration AddSalesforceColumnsToContacts salesforce_id
```

Then you can configure the model to be 'salesforceable' calling ```salesforceable_as``` in the class declaration.

```ruby
class Contact < ActiveRecord::Base

  salesforceable_as 'Lead', 
    client_id: 'YOUR_CLIENT_ID', 
    client_secret: 'YOUR_SECRET',
    fields_mapping: {
      'name' => 'FirstName',
      'email' => 'Email',
    }
  
end
```

- The first argument of ```salesforceable_as``` defines the name of the Salesforce Object in which the data will be saved. Here, we are using 'Lead'.
- 'client_id' and 'client_secret' are the credentials of your 'Salesforce Connected App' being used. To learn more about Salesforce's connected apps visit [Creating a connected App](https://help.salesforce.com/apex/HTViewHelpDoc?id=connected_app_create.htm).
- 'fields_mapping' is a hash that map ActiveRecord's properties to Salesforce Object properties. In our example the 'name' property of ActiveRecord object will be saved in the 'FirstName' property of the Salesforce object.

After configuring your ActiveRecord model, you can save any instance by calling ```save_on_salesforce!```.

```ruby
@contact.save_on_salesforce!(refresh_token, instance_url)
```

- 'refresh_token' and 'instance_url' must be obtained through OAuth authentication and they relate to the account where data will be saved on Salesforce. Note that this token must give permission to your 'Connected App' to save data on the user's behalf.
To learn more on how to obtain this token, visit [this heroku guide](https://devcenter.heroku.com/articles/integrating-force-com-and-heroku-apps), [the omniauth-salesforce manpage](https://github.com/realdoug/omniauth-salesforce) and [the Devise OmniAuth Overview](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)

You can also remove a previously saved object from Salesforce.
```ruby
@contact.remove_from_salesforce!(refresh_token, instance_url)
```

## Dependency

Salesforceable depends and is heavily based on the amazing [restforce](https://github.com/ejholmes/restforce) ruby gem.


