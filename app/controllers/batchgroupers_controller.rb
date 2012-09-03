class BatchgroupersController < ApplicationController
  respond_to :html, :json
  
  def index
    @batchgrouper = Batchgrouper.new()
  end
  
  def group
    @batchgrouper = Batchgrouper.new(params[:batchgrouper])
    if params[:batchgrouper][:file]
      send_file @batchgrouper.group
    else
      @single_group_result = @batchgrouper.group_line(@batchgrouper.single_group)
      render 'index'
    end
  end
end
