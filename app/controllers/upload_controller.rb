class UploadController < ApplicationController
  def index
  end
  def create
    puts file = params[:file_data]
    file_asset = BasicFile.new
    puts "Upload : #{file_asset.add_file(file)}"
    file_asset.save
    render :text => "File has been uploaded successfully"
  end
end