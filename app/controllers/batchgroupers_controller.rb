class BatchgroupersController < ApplicationController
  respond_to :html, :json
  
  def index
    @title = 'Batchgrouper'
    @batchgrouper = Batchgrouper.new()
  end
  
  def group
    @title = 'Batchgrouper'
    @batchgrouper = Batchgrouper.new(params[:batchgrouper])
    if params[:batchgrouper][:file]
      begin
        send_file @batchgrouper.group 
      rescue
        flash.now[:error] = @batchgrouper.errors.full_messages
        render 'index'
      end
    else
      @single_group_result = @batchgrouper.group_line(@batchgrouper.single_group) rescue t('batchgrouper.invalid_format')
      render 'index'
    end
  end
end
