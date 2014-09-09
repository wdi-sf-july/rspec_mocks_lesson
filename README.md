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


### Stub

A stub is a method in on an object that we wish to have some control over for testing purposes and whose true functionality is of little value to the test be written.

`examples/stub_spec.rb`

```ruby

class Person
  attr_reader :messages
  def initialize
    @messages = []
  end
  
  def send_message(msg)
    if @messages.length < 4
      @message.push(msg)
      true
    else
      false
    end
  end

end

class Greeter
  def say_hello(person)
    # Here  the person object
    #   is not directly under test
    if person.send_message("Hello There!")
      "Sent!"
    else
      "Failed!"
    end
  end
end

# Testing
describe Greeter do
  subject { Greeter.new }

  describe "#say_hello" do
    before (:each) do
      @person = Person.new
    end

    it "should return 'Sent' on success" do
      allow(@person).to receive(:send_message).and_return(true)
      expect(subject.say_hello(@person)).to eq("Sent!")
    end 

    it "should return 'Failed' on success" do
      allow(@person).to receive(:send_message).and_return(false)
      expect(subject.say_hello(@person)).to eq("Failed!")
    end   
  end
end
```


### Double

A test **double** is not unlike a stunt double. It comes into play when we are testing a component of an application that requires interaction with another component **not directly under test**. This avoids problems with the implementation or existence of one component overly effecting the tests of another.

A Quick Example:

`examples/greeter_spec.rb`

```ruby
  
  class Greeter
    def say_hello(person)
      # Here  the person object
      #   is not directly under test
      if person.send_message("Hello There!")
        "Sent!"
      else
        "Failed!"
      end
    end
  end

# Now we can test Greeter

describe Greeter do
  subject { Greeter.new }

  describe "#say_hello" do

    it "should return 'Sent' on success" do
      person = double("some person")
      allow(person).to receive(:send_message).and_return(true)
      expect(subject.say_hello(person)).to eq("Sent!")
    end 

    it "should return 'Failed' on success" do
      person = double("some person")
      allow(person).to receive(:send_message).and_return(false)
      expect(subject.say_hello(person)).to eq("Failed!")
    end   
  end
end

```

### Mocking 

A mock is generally something that is more of a **pattern**. Unlike a `stub` where you simply substituted a method of your own creation and cared very little for how many times it was actually called or used, a mock pattern creates a **double** and sets up particular **expectations** on what the method **should be receiving in the future**, how many **times it is called**, and what it **should return**.



`examples/mocking_spec.rb`

```ruby
  
  class Greeter
    def say_hello(person)
      # Here  the person object
      #   is not directly under test
      if person.send_message("Hello There!")
        "Sent!"
      else
        "Failed!"
      end
    end
  end

# Now we can test Greeter

describe Greeter do
  subject { Greeter.new }

  describe "#say_hello" do

    it "should return 'Sent' on success" do
      person = double("some person")
      expect(person).to receive(:send_message).with("Hello There!").and_return(true)
      expect(subject.say_hello(person)).to eq("Sent!")
    end 

    it "should return 'Failed' on success" do
      person = double("some person")
      expect(person).to receive(:send_message).with("Hello There!").and_return(false)
      expect(subject.say_hello(person)).to eq("Failed!")
    end   
  end
end

```

### Stubbing In Our Rails Application 

The most common thing to go stubbing is the `current_user`, which is something we will not care to test directly. Nevertheless you will still test the `current_user` method in a helper test for example.
require 'rails_helper'


```ruby
RSpec.describe UsersController, :type => :controller do

  before :each do
    @user = FactoryGirl.create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe "Get #index" do
    it "should assign @users" do
     get :index
     expect(assigns(:users)).to eq([@user])
    end
  end
end
```

### Mocking in our Rails Application

Doubling an entire `ActiveRecord` object is no easy task, and so we can utilize `rspec-activemodel-mocks` to stand in during testing.

`Gemfile`

```ruby
group :development, :test do
  gem 'rspec-rails'
  ### Add the following
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails'
  gem 'ffaker'
end
```

The best place to mock out a model would be in a controller spec where taking time to interact with a database is often both costly and unwanted. We want fast tests. We aren't trying to test the true behavior of the model as much as we want to express controller behaviors and attributes.

`spec/controllers/post_controller_spec.rb`

```ruby
RSpec.describe PostsController, :type => :controller do
  describe "Get index" do
    before (:each) do
      @user = mock_model("User")
      @post = mock_model("Post")
    end

    describe "for a particular user" do
      it "should assign @user and @posts" do   
        expect(@user).to receive(:posts).and_return([@post])
        expect(User).to receive(:find_by_id).and_return(@user).with(1).twice()

        # This is an alternative to stubbing
        #   the current_user
        session["user_id"] = 1
        get :index, { user_id: 1}
        expect(assigns(:user)).to be(@user)
        expect(assigns(:posts)).to eq([@post])
      end
    end

  end

end
```





### Resources

- **Rspec Stubs:** https://www.relishapp.com/rspec/rspec-mocks/v/2-3/docs/method-stubs  

- **Rspec Stubs Examples:** http://old.rspec.info/documentation/mocks/stubs.html  

- **Factory Girl:** https://github.com/thoughtbot/factory_girl_rails  

- **Factory Girl Wiki:**  https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md  

- **Factory Girl Wiki:** https://github.com/thoughtbot/factory_girl/wiki/Usage  

- **Factories not Fixtures- Rails Cast:** http://railscasts.com/episodes/158-factories-not-fixtures  

- **Fixtures vs Factories:** https://semaphoreapp.com/blog/2014/01/14/rails-testing-antipatterns-fixtures-and-factories.html  
