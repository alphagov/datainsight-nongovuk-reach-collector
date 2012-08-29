# encoding: utf-8
require_relative "../spec_helper"
require_relative "../../lib/nongovuk_reach_collector"
require_relative "../worksheet"

describe "Nongovuk Reach Collector" do
  class NongovukReachCollector < Collectors::NongovukReachCollector
    def get_worksheet
      @worksheet
    end
  end

  a_minute = Rational(1, 24*60)

  it "should log error message" do
    collector = NongovukReachCollector.new("site", "metric")
    Logging.logger[collector].should_receive(:error)

    collector.broadcast
  end

  it "should fail if site and metric are unknown" do
    collector = NongovukReachCollector.new("site", "metric")

    -> { collector.execute }.should raise_error(Exception, "Unkown type: `site:metric`")
  end

  describe "worksheet with gaps" do
    before(:each) do
      @worksheet = WorksheetStub.from_CSV(File.dirname(__FILE__) + "/../fixtures/weekly_reach_worksheet_with_blanks.csv")
    end

    it "should not present future Directgov data points" do
      collector = NongovukReachCollector.new("directgov", "visits")
      messages = collector.create_message_for(@worksheet)

      found = messages.select {|message| message[:payload][:start_at] == "2012-07-02T00:00:00+00:00"}
      found.should have(1).item
      message = found.first
      message[:payload][:value].should == 4801934
      message[:payload][:start_at].should == "2012-07-02T00:00:00+00:00"
      message[:payload][:end_at].should == "2012-07-09T00:00:00+00:00"
      message[:envelope][:collected_at].should be_within(a_minute).of(DateTime.now)

    end

    it "should send nil for Directgov data points that are missing" do
      collector = NongovukReachCollector.new("directgov", "visits")
      messages = collector.create_message_for(@worksheet)

      found = messages.select {|message| message[:payload][:start_at] == "2012-06-25T00:00:00+00:00"}
      found.should have(1).item
      message = found.first
      message[:payload][:value].should be_nil
      message[:payload][:start_at].should == "2012-06-25T00:00:00+00:00"
      message[:payload][:end_at].should == "2012-07-02T00:00:00+00:00"
      message[:envelope][:collected_at].should be_within(a_minute).of(DateTime.now)

    end
  end

  describe "worksheet without gaps" do
    before(:each) do
      @worksheet = WorksheetStub.from_CSV(File.dirname(__FILE__) + "/../fixtures/weekly_reach_worksheet.csv")
    end

    it "should load all available business link visits data points" do
      collector = NongovukReachCollector.new("businesslink", "visits")
      messages = collector.create_message_for(@worksheet)

      message = messages[0]
      message[:payload][:value].should == 128229
      message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
      message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
      message[:envelope][:collected_at].should be_within(a_minute).of(DateTime.now)

    end

    it "should load all available directgov visits data points" do
      collector = NongovukReachCollector.new("directgov", "visits")
      messages = collector.create_message_for(@worksheet)

      message = messages[0]
      message[:payload][:value].should == 4638888
      message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
      message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
      message[:envelope][:collected_at].should be_within(a_minute).of(DateTime.now)

    end

    it "should load all available business link visitors data points" do
      collector = NongovukReachCollector.new("businesslink", "visitors")
      messages = collector.create_message_for(@worksheet)

      message = messages[0]
      message[:payload][:value].should == 106884
      message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
      message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
      message[:envelope][:collected_at].should be_within(a_minute).of(DateTime.now)

    end

    it "should load all available directgov visitors data points" do
      collector = NongovukReachCollector.new("directgov", "visitors")
      messages = collector.create_message_for(@worksheet)

      message = messages[0]
      message[:payload][:value].should == 3730422
      message[:payload][:start_at].should == "2011-03-28T00:00:00+00:00"
      message[:payload][:end_at].should == "2011-04-04T00:00:00+00:00"
      message[:envelope][:collected_at].should be_within(a_minute).of(DateTime.now)

    end
  end
end
