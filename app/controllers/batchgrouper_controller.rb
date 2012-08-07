class BatchgrouperController < ApplicationController
  def index
    @batchgrouper = Batchgrouper.new()
  end
  
  def group
    @batchgrouper = Batchgrouper.new(params[:batchgrouper])
    puts @batchgrouper.single_group
    if @batchgrouper.single_group.blank?
      send_file @batchgrouper.group
    else
      render :json => @batchgrouper.group_line(@batchgrouper.single_group)
    end
    
  end
  
  def single_group
    
  end
end
