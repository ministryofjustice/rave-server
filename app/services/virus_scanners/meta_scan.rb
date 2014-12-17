require 'timeout'

module Services
  module VirusScanners
    class MetaScan < Base
      attr_accessor :api_key, :max_wait_seconds

      def initialize(opts={})
        self.api_key = opts[:api_key] || ENV['METASCAN_API_KEY']
        self.max_wait_seconds = opts[:max_wait_seconds] || 30
      end

      def is_safe?(local_file_path)
        request_tracker = parse_scan_response( request_scan(local_file_path) )

        Timeout::timeout(self.max_wait_seconds) do
          progress = 0

          while progress < 100
            sleep(1)
            progress = progress_percentage(request_tracker)
            puts "#{progress}%"
          end 
        end

        report = get_scan_report(request_tracker)
        # 0 means 'Clean' - see https://www.metascan-online.com/public-api#retrieve-scan-report-using-data-id
        # and https://www.metascan-online.com/public-api#definitions
        report['scan_results']['scan_all_result_i'] == 0 
      end

      private
        def get_scan_report(request_tracker)
          url = "https://scan.metascan-online.com/v2/file/#{request_tracker['data_id']}"
          JSON.parse(RestClient.get(url, apikey: self.api_key))
        end

        def request_scan(local_file_path)
          RestClient.post 'https://scan.metascan-online.com/v2/file',
            File.read(local_file_path),
            apikey: self.api_key,
            filename: File.basename(local_file_path)
        end

        def parse_scan_response(response)
          JSON.parse(response)
        end

        def complete?(request_tracker)
          progress_percentage(request_tracker) == 100
        end

        def progress_percentage(request_tracker)
          json = RestClient.get( progress_url(request_tracker), apikey: self.api_key )
          JSON.parse(json)['scan_results']['progress_percentage'].to_i
        end

        def progress_url(request_tracker)
          'https://' + request_tracker['rest_ip'] + '/file/' + request_tracker['data_id']
        end
    end
  end
end