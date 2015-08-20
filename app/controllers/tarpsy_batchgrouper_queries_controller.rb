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
      stdout, stderr, status = @tarpsy_batchgrouper_query.group
      if status.exitstatus == 0
        # TODO: possibly do something with stdout?
        Rails.logger.debug(stdout)
        Rails.logger.debug(stderr)
        missing_fids = stderr.scan(/Could not find patient case with FID: (\d+)/).flatten.uniq
        unless missing_fids.blank?
          hint = "Could not find patient cases with following FIDs: #{missing_fids.join(', ')}"
          cookies[:missing_fid] = hint
        end
        cookies[:download_finished] = true
        send_file(@tarpsy_batchgrouper_query.output_file_path, content_type: Mime::CSV)
      else
        Rails.logger.warn(stdout)
        Rails.logger.warn(stderr)
        flash[:error] = view_context.simple_format(stderr)
        render 'form'
      end
    end
  end

  def tarpsy_batchgrouper_query_params
    params[:tarpsy_batchgrouper_query].permit(:system_id, :mb_input, :mb_input_cache,
                                              :honos_input, :honos_input_cache)
  end
end
