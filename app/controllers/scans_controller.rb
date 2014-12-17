require 'virus_scanners'
require 'local_resource'

class ScansController < ApplicationController
  def create
    file = local_file
    scanner = Services::VirusScanners.instance('ClamAv')
    puts "scanning #{local_file}"
    safe = scanner.is_safe?(file)
    puts "=> #{safe}"

    File.delete(file) if params[:file_url].present?
    render json: safe, status: 200
  end

  private

  def local_file
    if params[:file_url].present?
      puts "downloading local copy of #{params[:file_url]}"
      file = Services::LocalResource.new(URI.parse(params[:file_url])).file.path
    elsif params[:file].present?
      file = params[:file]
    else
      raise 'No file or file_url parameter supplied!'
    end
  end
end
