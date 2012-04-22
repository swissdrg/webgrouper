# This class is used for creating a data chart containing all the
# length of stay data computed through the grouper.
# This uses a big deal of the google chart API
class LosDataTable < GoogleVisualr::DataTable
  def initialize(actual_los, effective_cost_weight, weighting_relation, factor)
    super()
    new_columns [ {:type => 'number', :label => 'Tage'},
                  {:type => 'number', :label => I18n.t('result.cost-weight.legend')} ]
    new_column('string', nil, nil, 'annotation')
    new_column('string', nil, nil, 'annotationText')
    #new_column :type => 'string', :label => 'Label'
    @avg_duration = weighting_relation.avg_duration.to_f/factor
    @low_trim_point = weighting_relation.first_day_discount + 1
    @high_trim_point = weighting_relation.first_day_surcharge - 1
    @base_cost_rate = weighting_relation.cost_weight.to_f/factor
    @effective_cost_weight = effective_cost_weight.to_f/factor
    discount_per_day = weighting_relation.discount_per_day.to_f/factor
    surcharge_per_day = weighting_relation.surcharge_per_day.to_f/factor
    one_day_cost_rate = @base_cost_rate - discount_per_day*(@low_trim_point - 1)
    many_days = [@high_trim_point, actual_los].max + 5
    many_days_cost_rate = @base_cost_rate + surcharge_per_day*(many_days - @high_trim_point)
    
    add_rows([
    [1, one_day_cost_rate, '',''],
    [@low_trim_point, @base_cost_rate, 'lo', I18n.t('result.length-of-stay.low_trim_point')],
    [@avg_duration, @base_cost_rate, 'mid',I18n.t('result.length-of-stay.average_los')],
    [@high_trim_point, @base_cost_rate, 'hi', I18n.t('result.length-of-stay.high_trim_point')],
    [actual_los, @effective_cost_weight, '***', I18n.t('result.length-of-stay.length-of-stay')],
    [many_days, many_days_cost_rate, '','']]) 
  end
  
  def make_chart()
    options = { :width => 650, :height => 170,
                :legend => 'none',
                :hAxis => { :title => 'Tage' },
                :vAxis => { :title => 'Kostengewicht' }}
    GoogleVisualr::Interactive::LineChart.new(self, options)
  end
end