class BatchgrouperQueriesController < ApplicationController
  def tos
    @link = new_batchgrouper_query_path
    render 'static_pages/tos'
  end

  def index
    redirect_to new_batchgrouper_query_path
  end

  def new
    @batchgrouper_query = BatchgrouperQuery.new
    render 'form'
  end

  def create
    @batchgrouper_query = BatchgrouperQuery.create(batchgrouper_query_params.merge(ip: request.remote_ip,
                                                                                   client: request.env['HTTP_USER_AGENT']))
    unless @batchgrouper_query.errors.any?
      @batchgrouper_query.group
      cookies[:download_finished] = true
      return send_file @batchgrouper_query.output_file_path
    end
    render 'form'
  end

  private

  def batchgrouper_query_params
    params[:batchgrouper_query].permit(:input, :system_id, :house)
  end
end
