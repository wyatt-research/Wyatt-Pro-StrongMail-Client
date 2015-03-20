RSpec.describe Strongmail::Member do

  context "readonly properties" do
    describe "#id" do
      data = {:id => 1}
      member = Strongmail::Member.new data

      it "reads the id" do
        expect(member.id).to eq 1
      end

      it "throws error on id write" do
        expect { member.id = 1 }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Member attribute')
      end
    end

    describe "#email" do
      data = {:email => 'test@example.com'}
      member = Strongmail::Member.new data

      it "reads the email" do
        expect(member.email).to eq 'test@example.com'
      end

      it "email write works successfully" do
        member.email = 'abc@example.com'
        expect(member.email).to eq('abc@example.com')
      end
    end

    describe "#date_joined" do
      data = {:date_joined => '2014-10-22 10:00:00'}
      member = Strongmail::Member.new data

      it "reads the date_joined" do
        expect(member.date_joined.class).to eq DateTime
        expect(member.date_joined.strftime("%F %H:%M:%S")).to eq '2014-10-22 10:00:00'
      end

      it "throws error on date_joined write" do
        expect { member.date_joined = 'something else' }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Member attribute')
      end
    end

    describe "#email_status" do
      data = {:email_status => 'valid'}
      member = Strongmail::Member.new data

      it "reads the email_status" do
        expect(member.email_status).to eq 'valid'
      end

      it "throws error on email_status write" do
        expect { member.email_status = 'something else' }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Member attribute')
      end
    end
  end

  context "read and write properties" do
    describe "#first_name" do
      data = {:first_name => 'Charles'}
      member = Strongmail::Member.new data

      it "reads the first_name" do
        expect(member.first_name).to eq 'Charles'
      end

      it "writes the first_name" do
        member.first_name = 'Sally'
        expect(member.first_name).to eq 'Sally'
      end
    end

    describe "#last_name" do
      data = {:last_name => 'Sprayberry'}
      member = Strongmail::Member.new data

      it "reads the last_name" do
        expect(member.last_name).to eq 'Sprayberry'
      end

      it "writes the last_name" do
        member.last_name = 'Smith'
        expect(member.last_name).to eq 'Smith'
      end
    end

    describe "#address1" do
      data = {:address1 => '1234 Main St'}
      member = Strongmail::Member.new data

      it "reads the address1" do
        expect(member.address1).to eq '1234 Main St'
      end

      it "writes the address1" do
        member.address1 = '9876 Nowheresville'
        expect(member.address1).to eq '9876 Nowheresville'
      end
    end

    describe "#address2" do
      data = {:address2 => 'Suite 100'}
      member = Strongmail::Member.new data

      it "reads the address2" do
        expect(member.address2).to eq 'Suite 100'
      end

      it "writes the address2" do
        member.address2 = 'Suite 9000'
        expect(member.address2).to eq 'Suite 9000'
      end
    end

    describe "#city" do
      data = {:city => 'Anywhere'}
      member = Strongmail::Member.new data

      it "reads the city" do
        expect(member.city).to eq 'Anywhere'
      end

      it "writes the city" do
        member.city = 'Human Town'
        expect(member.city).to eq 'Human Town'
      end
    end

    describe "#state" do
      data = {:state => 'VT'}
      member = Strongmail::Member.new data

      it "reads the state" do
        expect(member.state).to eq 'VT'
      end

      it "writes the state" do
        member.state = 'NY'
        expect(member.state).to eq 'NY'
      end
    end

    describe "#zip" do
      data = {:zip => '12345'}
      member = Strongmail::Member.new data

      it "reads the zip" do
        expect(member.zip).to eq '12345'
      end

      it "writes the zip" do
        member.zip = '54321'
        expect(member.zip).to eq '54321'
      end
    end

    describe "#country" do
      data = {:country => 'USA'}
      member = Strongmail::Member.new data

      it "reads the country" do
        expect(member.country).to eq 'USA'
      end

      it "writes the country" do
        member.country = 'MEX'
        expect(member.country).to eq 'MEX'
      end
    end

    describe "#work_phone" do
      data = {:work_phone => '555-555-5555'}
      member = Strongmail::Member.new data

      it "reads the work_phone" do
        expect(member.work_phone).to eq '555-555-5555'
      end

      it "writes the work_phone" do
        member.work_phone = '444-444-4444'
        expect(member.work_phone).to eq '444-444-4444'
      end

    end
  end
end
