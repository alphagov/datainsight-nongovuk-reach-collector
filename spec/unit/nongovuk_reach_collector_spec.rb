# encoding: utf-8
require_relative "../spec_helper"
require_relative "../../lib/nongovuk_reach_collector"
require_relative "../worksheet"

describe "Nongovuk Reach Collector" do
  before(:each) do
    @worksheet = WorksheetStub.from_CSV(File.dirname(__FILE__) + "/../fixtures/weekly_reach_worksheet.csv")
  end

  class NongovukReachCollector < Collectors::NongovukReachCollector
    def get_worksheet
      @worksheet
    end
  end

  it "should load all available business link visits data points" do
    collector = NongovukReachCollector.new("businesslink", "visits")
    messages = collector.create_message_for(@worksheet)

    message = messages[0]
    message[:payload][:value].should == 128229
    message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
    message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:payload][:value].should == 379401
    message[:payload][:start_at].should == "2012-07-02T00:00:00+00:00"
    message[:payload][:end_at].should == "2012-07-09T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end

  it "should load all available directgov visits data points" do
    collector = NongovukReachCollector.new("directgov", "visits")
    messages = collector.create_message_for(@worksheet)

    message = messages[0]
    message[:payload][:value].should == 4638888
    message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
    message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:payload][:value].should == 4801934
    message[:payload][:start_at].should == "2012-07-02T00:00:00+00:00"
    message[:payload][:end_at].should == "2012-07-09T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)


    messages.length.should == 67
  end

  it "should load all available business link visitors data points" do
    collector = NongovukReachCollector.new("businesslink", "visitors")
    messages = collector.create_message_for(@worksheet)

    message = messages[0]
    message[:payload][:value].should == 106884
    message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
    message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:payload][:value].should == 400589
    message[:payload][:start_at].should == "2012-07-02T00:00:00+00:00"
    message[:payload][:end_at].should == "2012-07-09T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end

  it "should load all available directgov visitors data points" do
    collector = NongovukReachCollector.new("directgov", "visitors")
    messages = collector.create_message_for(@worksheet)

    message = messages[0]
    message[:payload][:value].should == 3730422
    message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
    message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:payload][:value].should == 3801934
    message[:payload][:start_at].should == "2012-07-02T00:00:00+00:00"
    message[:payload][:end_at].should == "2012-07-09T00:00:00+00:00"
    message[:envelope][:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end

  it "should " do
    collector = NongovukReachCollector.new("foo", "bar")
    messages = collector.execute

    message = messages[0]
    message[:payload][:error].should == "Unkown type: `foo:bar`"
  end
end
