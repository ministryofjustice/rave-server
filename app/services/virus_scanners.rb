require 'virus_scanners/base'
require 'virus_scanners/clam_av'
require 'virus_scanners/meta_scan'

module Services::VirusScanners

  def self.instance(name = nil, args = {})
    raise ArgumentError.new('unknown backend') unless available.include?(name)
    "Services::VirusScanners::#{name.classify}".constantize.new(args)
  end

  def self.available
    ['ClamAv', 'MetaScan']
  end
end
