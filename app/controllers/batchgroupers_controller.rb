class BatchgroupersController < ApplicationController
  def tos
    @link = batchgrouper_path
    render 'static_pages/tos'
  end
  
  def index
    @batchgrouper = Batchgrouper.new()
  end
  
  def group
    @batchgrouper = Batchgrouper.new(params[:batchgrouper])
    if @batchgrouper.file
      begin
        @batchgrouper.preprocess_file
        BatchgrouperQuery.create(:ip => request.remote_ip, 
                      :filename => @batchgrouper.file.original_filename,
                      :second_line => @batchgrouper.second_line, 
                      :line_count => @batchgrouper.line_count,
                      :time => Time.now,
                      :system_id => @batchgrouper.system_id,
                      :house => @batchgrouper.house,
                      :client => request.env['HTTP_USER_AGENT'])
        output_file = @batchgrouper.group
        cookies[:download_finished] = true
        return send_file output_file
      rescue *[ActionController::MissingFile, Encoding::UndefinedConversionError] => e
        Rails.logger.info(e)
        flash[:error] = 'Could not parse file. Only use text files in the swissdrg format, not .doc or .xls'
      rescue ArgumentError => e
        Rails.logger.info(e)
        flash[:error] = e.message + " " + view_context.link_to("Online Converter", "https://apps.swissdrg.org/converter")
      end
    elsif not @batchgrouper.single_group.blank?
      begin
        @single_group_result = @batchgrouper.group_line(@batchgrouper.single_group)
      rescue Java::JavaLang::IllegalArgumentException => e
        @single_group_result = "#{t'batchgrouper.invalid_format'} #{e}"
      end
    end
    render 'index'
  end

end
