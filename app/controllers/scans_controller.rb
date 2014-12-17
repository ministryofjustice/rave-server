require 'virus_scanners'

class ScansController < ApplicationController
  def create
    file = local_file
    scanner = Services::VirusScanners.instance('ClamAv')
    safe = scanner.is_safe?(file)

    render json: safe, status: 200
  end

  private

  def local_file
    if params[:file_url].present?
      file = Services::LocalResource.new(params[:file_url]).file.path
    elsif params[:file].present?
      file = params[:file]
    else
      raise 'No file!'
    end
  end
end
