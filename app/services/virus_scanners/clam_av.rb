module Services
  module VirusScanners
    class ClamAv < Base
      
      def is_safe?(local_file_path)
        output = %x[#{command(local_file_path)}]
        infections(output) == 0
      end

      private

        def command(local_file_path)
          "`which clamscan`  #{local_file_path}"
        end


        def infections(output)
          # note the /m - multiline matching, important
          output.gsub(/.*Infected files:\s*([0-9]+)\s+.*/m, '\1').to_i
        end
    end
  end
end