class TarpsyBatchgrouperQueriesController < ApplicationController

  def index
    redirect_to action: :new
  end

  def new
    @tarpsy_batchgrouper_query = TarpsyBatchgrouperQuery.new
    render 'form'
  end

  def create
    @tarpsy_batchgrouper_query = TarpsyBatchgrouperQuery.create(tarpsy_batchgrouper_query_params)
    if @tarpsy_batchgrouper_query.errors.any?
      render 'form'
    else
      output = @tarpsy_batchgrouper_query.group
      Rails.logger.info(output)
      if File.exists?(@tarpsy_batchgrouper_query.output_file_path)
        send_file(@tarpsy_batchgrouper_query.output_file)
      else
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
