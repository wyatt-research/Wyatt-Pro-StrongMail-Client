RSpec.describe Strongmail::Subscription do

  context "readonly properties" do
    describe "#id" do
      data = {:id => 1}
      subscription = Strongmail::Subscription.new data

      it "reads the id" do
        expect(subscription.id).to eq 1
      end

      it "throw error on id write" do
        expect { subscription.id = 9 }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Subscription attribute')
      end
    end

    describe "#active?" do
      data = {:active => false}
      subscription = Strongmail::Subscription.new data

      it "reads the active status" do
        expect(subscription.active?).to eq false
      end

      it "throws error on active status write" do
        expect { subscription.active = true }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Subscription attribute')
      end
    end

    describe "#member_email" do
      data = {:member_email => 'some_user@example.com'}
      subscription = Strongmail::Subscription.new data

      it "reads the member_email" do
        expect(subscription.member_email).to eq 'some_user@example.com'
      end

      it "throws error on member_email write" do
        expect { subscription.member_email = 'another_user@example.com' }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Subscription attribute')
      end
    end

    describe "#list" do
      data = {:list => 'foo'}
      subscription = Strongmail::Subscription.new data

      it "reads the list" do
        expect(subscription.list).to eq 'foo'
      end

      it "throws error on list write" do
        expect { subscription.list = 'bar' }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Subscription attribute')
      end
    end

    describe "#date_subscribed" do
      data = {:date_subscribed => "1984-02-03 15:33:33"}
      subscription = Strongmail::Subscription.new data

      it "reads the date_subscribed" do
        expect(subscription.date_subscribed.class).to eq DateTime
        expect(subscription.date_subscribed.strftime("%F %H:%M:%S")).to eq '1984-02-03 15:33:33'
      end

      it "throws error on date_subscribed write" do
        expect { subscription.date_subscribed = 'some other date' }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Subscription attribute')
      end
    end

    describe "#date_unsubscribed with date" do
      data = {:date_unsubscribed => "2002-05-22 11:45:22"}
      subscription = Strongmail::Subscription.new data

      it "reads the date_unsubscribed" do
        expect(subscription.date_unsubscribed.class).to eq DateTime
        expect(subscription.date_unsubscribed.strftime("%F %H:%M:%S")).to eq '2002-05-22 11:45:22'
      end

      it "throw error on date_unsubscribed write" do
        expect { subscription.date_unsubscribed = 'some other date' }.to raise_error(Strongmail::ImmutablePropertyError, 'You may not change that Subscription attribute')
      end
    end

    describe "#date_un with no date" do
      data = {:date_unsubscribed => nil}
      subscription = Strongmail::Subscription.new data

      it "reads the date_unsubscribed" do
        expect(subscription.date_unsubscribed).to eq nil
      end
    end
  end

end