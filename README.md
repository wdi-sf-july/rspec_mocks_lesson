# Application Testing
## Rspec Rails Part I

| Objectives |
| :---- |
| Identify the **RSpsec** directory structure and the purpose of each folder |
| Identify the purpose and give examples of **Controller Specs** and related structures **mocks**, **stubs**, and **spies** |
| Employ **RSpec** **mocks**, **stubs**, and **spies** to solve common testing problems |

## RSpec Directory 

Typical Spec Folders 

* Model 
* Controller
* Request

### Model Specs

The point of a model spec is to test data validations and expected model behaviors.

###What is a factory?

A factory is a tool that allows us to create objects/data for our database to use for testing. We will stick to using factories to test our models.

*We use to do this with fixtures, but factories are better* 

###How to Install Factory Girl

**Add Factory Girl** 

Add factory girl inside of your development, test group in your gemfile. 

In *Gemfile* 

```ruby
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end
```

In `spec/rspec_helper`

```ruby
require "factory_girl_rails"

RSpec.configure do |config|
  config.include  FactoryGirl::Syntax::Methods
end
```

In *Terminal* 

```
bundle install
```
Now when we create a model a `spec/factories` folder will be created for us, as well as coresponding factory files. 

FactoryGirl likes to create files that look like this... 

```
spec/factories/ingredients.rb
spec/factories/recipes.rb
spec/factories/users.rb
```

### Defining a User Factory

```ruby
FactoryGirl.define do
  sequence :email do |n|
    "user_#{n}@factory.com"
  end

  factory :user do
    email 
    pswrd = "blah"
    password pswrd
    password_confirmation pswrd
  end
end

```

### Using a User Factory In A Spec

Here we will just test that our model passes any validations

```ruby
require 'rails_helper'

RSpec.describe User, :type => :model do
  it "should have a valid factory" do
    user = FactoryGirl.build(:user) 
    expect(user).to be_valid
  end
end
```

or using the more nice subject setter in rspec

```ruby
require 'rails_helper'

RSpec.describe User, :type => :model do

  subject { FactoryGirl.create(:user) }

  it "should have a valid factory" do
    expect(subject).to be_valid
  end
end

```


### Setup FFaker

It would be better if your Factories didn't always create the same kind of objects and had more interesting our more *realistic* test data.

Thus we use a gem called **FFaker** to give us better test data.


### Setup Gemfile

```ruby
  group :development, :test do
    gem 'rspec-rails'
    gem 'factory_girl_rails'
    gem 'ffaker'
  end
```



### Defining a User Factory Using FFaker

```ruby
FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    pswrd = Faker::Lorem.words(4).join("")
    password pswrd
    password_confirmation pswrd
  end
end

```

## Controller Specs

In a controller we might have not yet implemented the model details we would expect to be testing our application, but we still need to write valid tests that describe the behavior of our controller. The helps others focus on reading our specs to work toward implementing the controller.

### Resources

- **Rspec Stubs:** https://www.relishapp.com/rspec/rspec-mocks/v/2-3/docs/method-stubs  

- **Rspec Stubs Examples:** http://old.rspec.info/documentation/mocks/stubs.html  

- **Factory Girl:** https://github.com/thoughtbot/factory_girl_rails  

- **Factory Girl Wiki:**  https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md  

- **Factory Girl Wiki:** https://github.com/thoughtbot/factory_girl/wiki/Usage  

- **Factories not Fixtures- Rails Cast:** http://railscasts.com/episodes/158-factories-not-fixtures  

- **Fixtures vs Factories:** https://semaphoreapp.com/blog/2014/01/14/rails-testing-antipatterns-fixtures-and-factories.html  
