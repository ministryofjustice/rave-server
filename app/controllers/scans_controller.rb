require 'virus_scanners'
require 'local_resource'

class ScansController < ApplicationController
  def create
    file = local_file(params)
    scanner = Services::VirusScanners.instance(backend(params))
    puts "scanning #{file}"
    safe = scanner.is_safe?(file)
    puts "=> #{safe}"

    # if we were given a URL, then we will have downloaded a 
    # local copy - so lets clean up after ourselves
    if params[:file_url].present?
      puts "deleting local file #{file}"
      File.delete(file) 
    end

    render json: safe, status: 200
  end

  private

  def local_file(opts={})
    if opts[:file_url].present?
      puts "downloading local copy of #{opts[:file_url]}"
      file = Services::LocalResource.new(URI.parse(opts[:file_url])).file.path
    elsif opts[:file].present?
      file = opts[:file]
    else
      raise 'No file or file_url parameter supplied!'
    end
  end

  def backend(opts={})
    (Services::VirusScanners.available & 
      Array(opts[:backend] || ENV['RAVE_DEFAULT_BACKEND'] || 'ClamAv')
    ).first
  end
end
