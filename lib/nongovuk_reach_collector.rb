# Collects the weekly visits.
# Run: './bin/collector -t TOKEN print'
#
# To obtain authorisation code please visit:
#
# https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/analytics.readonly&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=70519367703-3j2pb73bd9kjr800coecnt5jv4ntfeso.apps.googleusercontent.com

require "date"
require "json"

module Collectors
  class NongovukReachCollector

    GOOGLE_API_SCOPE = "https://docs.google.com/feeds/ https://docs.googleusercontent.com/ https://spreadsheets.google.com/feeds/"
    GOOGLE_CREDENTIALS = "/etc/govuk/datainsight/google_credentials.yml"
    GOOGLE_TOKEN = "/var/lib/govuk/datainsight/google-drive-token.yml"

    SPREADSHEET_KEY="0Aq4mEanyr9A2dDVyMEpaNV9DbXZuNDV6cnJ5QzVyVVE"

    DATE_TO_ROW = 38

    TYPE_TO_ROW = {
      "businesslink:visits" => 39,
      "directgov:visits" => 40,
      "businesslink:visitors" => 33,
      "directgov:visitors" => 34
    }

    def initialize(site, metric, auth_code = nil)
      @site = site
      @metric = metric
      @auth_code = auth_code
    end

    def response
      @response ||= execute
    end

    def execute
      worksheet = get_worksheet

      create_message_for(worksheet)
    end

    def create_message_for(worksheet)
      type = "#{@site}:#{@metric}"
      row = TYPE_TO_ROW[type] or raise "Unkown type: `#{type}`"

      messages = []
      col = 2
      loop do
        break if get_date(worksheet, col) >= Date.today
        value = (worksheet[row, col] == "" || worksheet[row, col].nil?) ? nil : worksheet[row, col].gsub(",", "").to_i
        messages <<
          create_message(
            value,
            get_date(worksheet, col).strftime,
            (get_date(worksheet, col) + 7).strftime)

        col += 1
      end
      messages
    end

    private

    def get_worksheet
      authenticate.spreadsheet_by_key(SPREADSHEET_KEY).worksheets[0]
    end


    def authenticate
      auth = GoogleAuthenticationBridge::GoogleAuthentication.create_from_config_file(
        GOOGLE_API_SCOPE, GOOGLE_CREDENTIALS, GOOGLE_TOKEN
      )
      GoogleDrive.login_with_oauth(auth.get_oauth2_access_token(@auth_code))
    end

    def create_message(value, start_at, end_at)
      {
        :envelope => {
          :collected_at => DateTime.now,
          :collector => "nongovuk_reach",
        },
        :payload => {
          :start_at => start_at,
          :end_at => end_at,
          :value => {
            @metric.to_sym => value,
            :site => @site
          }
        }
      }
    end

    def get_date(worksheet, col)
      date_string = worksheet[DATE_TO_ROW, col]
      begin
        DateTime.strptime(date_string, "%m/%d/%Y")
      rescue => e
        raise "Error parsing date #{date_string} in Worksheet worksheet[#{DATE_TO_ROW}, #{col}]"
      end
    end
  end
end
