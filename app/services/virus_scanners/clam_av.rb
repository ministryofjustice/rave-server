module Services
  module VirusScanners
    class ClamAv < Base

      def is_safe?(local_file_path)
        output = %x[#{command(local_file_path)}]
        infections(output) == 0
      end

      private

        def command(local_file_path)
          if clamscan_path.blank?
            raise 'Clam AV not found'
          else
            "#{clamscan_path.chomp} #{local_file_path}"
          end
        end


        def infections(output)
          # note the /m - multiline matching, important
          output.gsub(/.*Infected files:\s*([0-9]+)\s+.*/mi, '\1').to_i
        end

        def clamscan_path
          `which clamscan`.chomp
        end
    end
  end
end