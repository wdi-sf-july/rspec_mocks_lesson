  
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
