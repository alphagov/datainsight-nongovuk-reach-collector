require "date"
require "json"

module Collectors
  class NongovukReachCollector

    API_SCOPE = "https://docs.google.com/feeds/ https://docs.googleusercontent.com/ https://spreadsheets.google.com/feeds/"
    SPREADSHEET_KEY="0Aq4mEanyr9A2dDVyMEpaNV9DbXZuNDV6cnJ5QzVyVVE"

    GOOGLE_CLIENT_ID = '1054017153726.apps.googleusercontent.com'
    GOOGLE_CLIENT_SECRET = 'eMFsc8LU3ZGrRFG93WfQCnD3'

    Infinity      = 1.0/0
    TYPE_TO_ROW = {
        "business_link:visits" => 37,
        "directgov:visits" => 38,
        "business_link:visitors" => 31,
        "directgov:visitors" => 32
    }

    def initialize(site, metric, auth_code = nil)
      @site = site
      @metric = metric
      @auth_code = auth_code
    end

    def broadcast
      Bunny.run(ENV['AMQP']) do |client|
        exchange = client.exchange("datainsight", :type => :topic)
        exchange.publish(response.to_json, :key => "google_drive.#{@metric}.weekly")
      end
    end

    def collect_as_json
      response.to_json
    end

    def response
      @response ||= execute
    end

    def execute
      begin
        worksheet = get_worksheet

        create_message_for(worksheet)
      rescue Exception => e
        [create_exception_message(e.message)]
      end
    end

    def create_message_for(worksheet)
      type = "#{@site}:#{@metric}"
      row = TYPE_TO_ROW[type] or raise "Unkown type: `#{type}`"

      messages = []
      (2..Infinity).each do |col|
        break if worksheet[row, col] == "" || worksheet[row, col].nil?
        messages <<
            create_message(
                worksheet[row, col].gsub(",", "").to_i,
                get_date(worksheet, col).strftime,
                (get_date(worksheet, col) + 7).strftime)
      end
      messages
    end

    private

    #ToDO what if spreadsheet is not existing
    def get_worksheet
      session = authenticate
      session.spreadsheet_by_key(SPREADSHEET_KEY).worksheets[0]
    end

    def authenticate
      auth = GoogleAuthenticationBridge::GoogleAuthentication.new(API_SCOPE, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
      token = auth.get_oauth2_access_token(@auth_code)
      session = GoogleDrive.login_with_oauth(token)

      session
    end

    def create_message(value, start_at, end_at)
      {
          :envelope => {
              :collected_at => DateTime.now,
              :collector => "nongovuk_reach",
          },
          :payload => {
              :value => value,
              :start_at => start_at,
              :end_at => end_at
          }
      }
    end

    def create_exception_message(message)
      {
          :envelope => {
              :collected_at => DateTime.now,
              :collector => "nongovuk_reach",
          },
          :payload => {
              :error => message
          }
      }
    end

    def get_date(worksheet, col)
      DateTime.strptime(worksheet[36, col], "%m/%d/%Y")
    end
  end
end