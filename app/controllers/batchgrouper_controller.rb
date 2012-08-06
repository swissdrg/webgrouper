class BatchgrouperController < ApplicationController
  def index
    @batchgrouper = Batchgrouper.new
  end
  
  def group
    @batchgrouper = Batchgrouper.new(params)
    render index
  end
end
