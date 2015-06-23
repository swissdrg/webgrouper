class TarpsyBatchgrouperQueriesController < ApplicationController

  def index
    redirect_to action: :new
  end

  def new
    @tarpsy_batchgrouper_query = TarpsyBatchgrouperQuery.new
    render 'form'
  end

  def create
    @tarpsy_batchgrouper_query = TarpsyBatchgrouperQuery.create(
        tarpsy_batchgrouper_query_params.merge(ip: request.remote_ip))
    if @tarpsy_batchgrouper_query.errors.any?
      render 'form'
    else
      output = @tarpsy_batchgrouper_query.group
      if File.exists?(@tarpsy_batchgrouper_query.output_file_path)
        Rails.logger.debug(output)
        missing_fids = output.scan(/Could not find patient case with FID: (\d+)/).flatten.uniq
        unless missing_fids.blank?
          hint = "Could not find patient cases with following FIDs: #{missing_fids.join(', ')}"
          cookies[:missing_fid] = hint
        end
        cookies[:download_finished] = true
        send_file(@tarpsy_batchgrouper_query.output_file_path, content_type: Mime::CSV)
      else
        Rails.logger.info(output)
        flash[:error] = output
        render 'form'
      end
    end
  end

  def tarpsy_batchgrouper_query_params
    params[:tarpsy_batchgrouper_query].permit(:system_id, :mb_input, :mb_input_cache,
                                              :honos_input, :honos_input_cache)
  end
end
