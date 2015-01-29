class StatisticsController < ApplicationController

  before_filter :default_params, :authenticate

  def batchgrouper
    params[:binned] ||= '1'
    @bg_queries = BatchgrouperQuery.where(:time.gt => @from, :time.lt => @to)
    @bg_system_chart = make_system_chart(BatchgrouperQuery)
    @bg_house_chart = make_house_chart(@bg_queries)
    bins = 100 if params[:binned] == '1'
    @bg_size_chart = make_size_chart(BatchgrouperQuery, :line_count, bins)
  end

  def webapi
    @wa_queries = WebapiQuery.where(:start_time.gt => @from, :start_time.lt => @to)
    bins = 100 if params[:binned]
    @wa_size_chart = make_size_chart(WebapiQuery, :nr_cases, bins)

    @agg = WebapiQuery.collection.aggregate([{'$match' => {start_time: {'$gt' => @from, '$lt' => @to}}},
                                             {'$project' => {ip: 1,
                                                             nr_cases: 1,
                                                             input_format: 1,
                                                             output_format: 1,
                                                             error: 1,
                                                             start_time: 1,
                                                             full_duration: {'$subtract' => ['$end_time', '$start_time']},
                                                             parse_duration: {'$subtract' => ['$finished_parsing_time', '$start_time']}}},
                                             {'$sort' => {full_duration: -1}},
                                             {'$limit' => 10}])
  end

  def webgrouper
    @queries = Query.where(:time.gt => @from, :time.lt => @to)
    @system_chart = make_system_chart(Query)
    @house_chart = make_house_chart(@queries)
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' and Digest::SHA512.hexdigest('MeinSalzy' + password) ==
          '6945495f4d245f16989e2bc3d79a68f202235007bb96d6594ef65a6e58df8f9f0dc7e0f44237ed701e9c981793d44d80b97f9b40655a37b1ae28acd690387e8c'
    end
  end

  def default_params
    params[:last_n_months] ||= 3
    @from = params[:last_n_months].to_i.months.ago
    @to = Time.now
  end

  def make_system_chart(model)
    system_data = GoogleVisualr::DataTable.new
    system_data.new_column('string', 'System')
    system_data.new_column('number', 'Groupings')
    agg = model.collection.aggregate([{'$match' => {time: {'$gt' => @from, '$lt' => @to}}},
                                      {'$group' => {_id: "$system_id", count: {'$sum' => 1}}},
                                      {'$sort' => {_id: 1}}])
    rows = agg.inject([]) { |list, hash| list << [System.find_by(system_id: hash['_id']).description, hash['count']] }
    system_data.add_rows(rows)
    options = {title: 'Used systems'}
    GoogleVisualr::Interactive::PieChart.new(system_data, options)
  end

  def make_house_chart(queries)
    house_data = GoogleVisualr::DataTable.new
    house_data.new_column('string', 'House')
    house_data.new_column('number', 'Groupings')
    house_data.add_rows([['Hospital', queries.where(house: '1').count],
                         ['Birthhouse', queries.where(house: '2').count]])
    options = {title: 'Hospital vs Birthhouse'}
    GoogleVisualr::Interactive::PieChart.new(house_data, options)
  end

  # Ignores queries that only occurred once
  def make_size_chart(model, attribute, bins=nil)
    data_table = GoogleVisualr::DataTable.new
    rows = if bins.nil?
             data_table.new_column('number', 'Patient cases')
             agg = BatchgrouperQuery.collection.aggregate([{'$match' => {time: {'$gt' => @from, '$lt' => @to}}},
                                                           {'$group' => {_id: "$#{attribute}", count: {'$sum' => 1}}},
                                                           {'$sort' => {_id: 1}}])
             agg.inject([]) { | list, hash| list << [hash['_id'], hash['count']] }
           else
             data_table.new_column('number', 'Patient cases')
             max_line_count = model.where(:time.gt => @from, :time.lt => @to).max(attribute)
             step_size = 10**Math::log10(max_line_count/bins).round
             agg = model.collection.aggregate([{'$match' => {time: {'$gt' => @from, '$lt' => @to}}},
                                               {'$project' => {step: {'$divide' => ["$#{attribute}", step_size]}}},
                                               {'$project' => {bin: {'$subtract' => ["$step", '$mod' => ['$step', 1]]}}},
                                               {'$group' => {_id: '$bin', count: {'$sum' => 1}}},
                                               {'$sort' => {_id: 1}}])
             agg.inject([]) do |list, hash|
               min = hash[:_id] * step_size
               list << [min, hash['count']]
             end
           end
    data_table.new_column('number', 'Number of queries')
    data_table.add_rows(rows)
    opts = {title: 'Size', hAxis: {title: 'Number of patient cases in query'},
            vAxis: {title: 'Number of queries', logScale: true}, legend: {position: 'none'}}
    GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
  end
end
