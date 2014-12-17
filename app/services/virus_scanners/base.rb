module Services
  module VirusScanners
    class Base
      attr_accessor :options

      def initialize(opts={})
        self.options = opts
      end

      def is_safe?(local_file_path)
        raise NotImplementedError.new('override in subclasses with service-specific implementation')
      end
    end
  end
end