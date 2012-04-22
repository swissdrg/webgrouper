class LosDataTable < GoogleVisualr::DataTable
  def initialize(actual_los, weighting_relation, factor)
    super()
    new_columns [ {:type => 'number', :label => 'Tage'},
                  {:type => 'number', :label => I18n.t('result.cost-weight.legend')} ]
    #new_column :type => 'string', :label => 'Label'
    @avg_duration = weighting_relation.avg_duration.to_f/factor
    @low_trim_point = weighting_relation.first_day_discount + 1
    @high_trim_point = weighting_relation.first_day_surcharge - 1
    @base_cost_rate = weighting_relation.cost_weight.to_f/factor
    discount_per_day = weighting_relation.discount_per_day.to_f/factor
    surcharge_per_day = weighting_relation.surcharge_per_day.to_f/factor
    one_day_cost_rate = @base_cost_rate - discount_per_day*(@low_trim_point - 1)
    many_days = [@high_trim_point, actual_los].max + 5
    many_days_cost_rate = @base_cost_rate + surcharge_per_day*(many_days - @high_trim_point)
    add_rows([
    [1, one_day_cost_rate],
    [@low_trim_point, @base_cost_rate],
    #[actual_los, ]
    [@avg_duration, @base_cost_rate],
    [@high_trim_point, @base_cost_rate],
    [many_days, many_days_cost_rate]]) 
  end
  
  def make_chart()
    options = {:width => 600, :height => 170, :hAxis => {:minValue => 0}}
    GoogleVisualr::Interactive::AreaChart.new(self, options)
  end
end