require 'virus_scanners/base'
require 'virus_scanners/clam_av'
require 'virus_scanners/meta_scan'

module Services::VirusScanners
  def self.instance(name = nil, args = {})
    "Services::VirusScanners::#{name.classify}".constantize.new(args)
  end
end
