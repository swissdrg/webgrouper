class BatchgroupersController < ApplicationController
  respond_to :html, :json
  
  def tos
    @link = batchgrouper_path
    render 'static_pages/tos'
  end
  
  def index
    @title = 'Batchgrouper'
    @batchgrouper = Batchgrouper.new()
  end
  
  def group
    @title = 'Batchgrouper'
    @batchgrouper = Batchgrouper.new(params[:batchgrouper])
    if params[:batchgrouper][:file]
      begin
        @batchgrouper.preprocess_file
        BatchgrouperQuery.create(:ip => request.remote_ip, 
                      :filename => @batchgrouper.file.original_filename,
                      :second_line => @batchgrouper.second_line, 
                      :line_count => @batchgrouper.line_count,
                      :time => Time.now,
                      :client => request.env['HTTP_USER_AGENT'])
        send_file @batchgrouper.group 
      rescue *[ActionController::MissingFile, Encoding::UndefinedConversionError] => e
        @error = "Could not parse file. Only use text files in the swissdrg format, not eg .doc or .xls"
        render 'index'
      end
    else
      @single_group_result = @batchgrouper.group_line(@batchgrouper.single_group) rescue t('batchgrouper.invalid_format')
      render 'index'
    end
  end
end
