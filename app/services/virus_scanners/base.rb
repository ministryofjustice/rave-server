module Services
  module VirusScanners
    class Base
      attr_accessor :auth_hash

      def initialize(auth_hash)
        self.au = local_file_path
      end

      def is_safe?(local_file_path)
        raise NotImplementedError.new('override in subclasses with service-specific implementation')
      end
    end
  end
end