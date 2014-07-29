class StatisticsController < ApplicationController
  def webgrouper_stats
    params[:last_n_months] ||= 3
    from = params[:last_n_months].to_i.months.ago
    to = Time.now
    @queries = Query.where(:time.gt => from, :time.lt => to)

    system_data = GoogleVisualr::DataTable.new
    system_data.new_column('string', 'System' )
    system_data.new_column('number', 'Webgroupings')
    rows = []
    System.each do |s|
      rows << [s.description, @queries.where(system_id: s.system_id).count]
    end
    system_data.add_rows(rows)
    options = {title: 'Used systems' }
    @system_chart = GoogleVisualr::Interactive::PieChart.new(system_data, options)

    house_data = GoogleVisualr::DataTable.new
    house_data.new_column('string', 'House' )
    house_data.new_column('number', 'Webgroupings')
    house_data.add_rows([ ['Hospital', @queries.where(house: '1').count],
                          ['Birthhouse', @queries.where(house: '2').count]])
    options = {title: 'Hospital vs Birthhouse'}
    @house_chart = GoogleVisualr::Interactive::PieChart.new(house_data, options)
  end

end
