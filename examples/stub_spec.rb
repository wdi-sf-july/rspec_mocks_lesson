
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