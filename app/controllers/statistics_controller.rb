class StatisticsController < ApplicationController
  def index
    params[:last_n_months] ||= 3
    params[:binned] ||= '1'
    from = params[:last_n_months].to_i.months.ago
    to = Time.now
    @queries = Query.where(:time.gt => from, :time.lt => to)

    @system_chart = make_system_chart(@queries)
    @house_chart = make_house_chart(@queries)

    @bg_queries = BatchgrouperQuery.where(:time.gt => from, :time.lt => to)
    @bg_system_chart = make_system_chart(@bg_queries)
    @bg_house_chart = make_house_chart(@bg_queries)
    bins = 100 if params[:binned]
    @bg_size_chart = make_size_chart(@bg_queries, bins)
  end


  private

  def make_system_chart(queries)
    system_data = GoogleVisualr::DataTable.new
    system_data.new_column('string', 'System' )
    system_data.new_column('number', 'Groupings')
    rows = []
    System.each do |s|
      rows << [s.description, queries.where(system_id: s.system_id).count]
    end
    system_data.add_rows(rows)
    options = {title: 'Used systems' }
    GoogleVisualr::Interactive::PieChart.new(system_data, options)
  end

  def make_house_chart(queries)
    house_data = GoogleVisualr::DataTable.new
    house_data.new_column('string', 'House' )
    house_data.new_column('number', 'Groupings')
    house_data.add_rows([ ['Hospital', queries.where(house: '1').count],
                          ['Birthhouse', queries.where(house: '2').count]])
    options = {title: 'Hospital vs Birthhouse'}
    GoogleVisualr::Interactive::PieChart.new(house_data, options)
  end

  # Ignores queries that only occurred once
  def make_size_chart(queries, bins=nil)
    data_table = GoogleVisualr::DataTable.new
    rows = if bins.nil?
             data_table.new_column('number', 'Line Count')
             queries.distinct(:line_count).sort.map do |line_count|
               [line_count, queries.where(line_count: line_count).count]
              end
           else
             data_table.new_column('string', 'Line Count')
             max_line_count = queries.max(:line_count)
             step_size = 10**Math::log10(max_line_count/bins).round
             min = 0
             max = step_size
             r = []
             while max < max_line_count
               r << ["#{min}-#{max}", queries.where(:line_count.gt => min, :line_count.lte => max).count]
               min, max = max, max + step_size
             end
             r
           end
    data_table.new_column('number', 'Number of queries')
    data_table.add_rows(rows)
    opts   = { title: 'Size of batchgroupings', hAxis: {title: 'Line count'},
               vAxis: {title: 'Number of queries', logScale: true}, legend: {position: 'none' } }
    GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
  end
end
