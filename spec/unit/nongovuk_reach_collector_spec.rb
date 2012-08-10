# encoding: utf-8
require_relative "../spec_helper"
require_relative "../../lib/nongovuk_reach_collector"

describe "Nongovuk Reach Collector" do
  before(:each) do
    @pipe = stub
    @collector = Collectors::NongovukReachCollector.new(@pipe)
    @worksheet = WorksheetStub.from_CSV(File.dirname(__FILE__) + "/../fixtures/weekly_reach_worksheet.csv")
  end

  it "should load all available business link visits data points" do
    messages = @collector.create_messages(@worksheet, "business_link", "visits")

    message = messages[0]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 128229
    response[:source].should == "Google Drive"
    response[:type].should == "business_link:visits"
    response[:start_at].should == "2011-03-28T00:00:00+00:00"
    response[:end_at].should == "2011-04-04T00:00:00+00:00"
    response[:unit].should == "visits"
    response[:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 379401
    response[:source].should == "Google Drive"
    response[:type].should == "business_link:visits"
    response[:start_at].should == "2012-07-02T00:00:00+00:00"
    response[:end_at].should == "2012-07-09T00:00:00+00:00"
    response[:unit].should == "visits"
    response[:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end
  it "should load all available directgov visits data points" do
    messages = @collector.create_messages(@worksheet, "directgov", "visits")

    message = messages[0]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 4638888
    response[:source].should == "Google Drive"
    response[:type].should == "directgov:visits"
    response[:start_at].should == "2011-03-28T00:00:00+00:00"
    response[:end_at].should == "2011-04-04T00:00:00+00:00"
    response[:unit].should == "visits"
    response[:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 4801934
    response[:source].should == "Google Drive"
    response[:type].should == "directgov:visits"
    response[:start_at].should == "2012-07-02T00:00:00+00:00"
    response[:end_at].should == "2012-07-09T00:00:00+00:00"
    response[:unit].should == "visits"
    response[:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end

  it "should load all available business link visitors data points" do
    messages = @collector.create_messages(@worksheet, "business_link", "visitors")

    message = messages[0]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 106884
    response[:source].should == "Google Drive"
    response[:type].should == "business_link:visitors"
    response[:start_at].should == "2011-03-28T00:00:00+00:00"
    response[:end_at].should == "2011-04-04T00:00:00+00:00"
    response[:unit].should == "visitors"
    response[:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 400589
    response[:source].should == "Google Drive"
    response[:type].should == "business_link:visitors"
    response[:start_at].should == "2012-07-02T00:00:00+00:00"
    response[:end_at].should == "2012-07-09T00:00:00+00:00"
    response[:unit].should == "visitors"
    response[:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end
  it "should load all available directgov visitors data points" do
    messages = @collector.create_messages(@worksheet, "directgov", "visitors")

    message = messages[0]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 3730422
    response[:source].should == "Google Drive"
    response[:type].should == "directgov:visitors"
    response[:start_at].should == "2011-03-28T00:00:00+00:00"
    response[:end_at].should == "2011-04-04T00:00:00+00:00"
    response[:unit].should == "visitors"
    response[:collected_at].should be_within(3).of(DateTime.now)

    message = messages[-1]
    message[:status][:code].should == "OK"
    response = message[:response]
    response[:value].should == 3801934
    response[:source].should == "Google Drive"
    response[:type].should == "directgov:visitors"
    response[:start_at].should == "2012-07-02T00:00:00+00:00"
    response[:end_at].should == "2012-07-09T00:00:00+00:00"
    response[:unit].should == "visitors"
    response[:collected_at].should be_within(3).of(DateTime.now)

    messages.length.should == 67
  end

  it "should create all possible messages" do
    all_messages = @collector.create_all_messages(@worksheet)

    messages  = @collector.create_messages(@worksheet, "business_link", "visits")
    messages += @collector.create_messages(@worksheet, "directgov", "visits")
    messages += @collector.create_messages(@worksheet, "business_link", "visitors")
    messages += @collector.create_messages(@worksheet, "directgov", "visitors")

    messages.length.should == all_messages.length
    messages[0][:response][:value].should == all_messages[0][:response][:value]
    messages[-1][:response][:value].should == all_messages[-1][:response][:value]
  end

  it "should create a valid exception message" do
    messages = @collector.create_exception_messages("an exception message")

    message = messages[0]
    message[:status][:code].should == "FAIL"

    response = message[:response]
    response[:source].should == "Google Drive"
    response[:type].should == "business_link:visits"
    response[:start_at].should == nil
    response[:end_at].should == nil
    response[:value].should == nil
    response[:unit].should == "visits"
    response[:collected_at].should be_within(3).of(DateTime.now)

    messages[1][:response][:type].should == "directgov:visits"
    messages[2][:response][:type].should == "business_link:visitors"
    messages[3][:response][:type].should == "directgov:visitors"
  end
end