# This class is used for creating a data chart containing all the
# length of stay data computed through the grouper.
# This uses a big deal of the google chart API
class LosDataTable < GoogleVisualr::DataTable
  def initialize(actual_los, cost_weight, weighting_relation, factor)
    super()
    new_columns [ {:type => 'number', :label => 'Tage'},
                  {:type => 'number', :label => I18n.t('result.cost-weight.legend')},
                  {:type => 'string', :role => 'annotation'},
                  {:type => 'string', :role => 'annotationText'},
                  #{:type => 'string', :role => 'tooltip'}, #TODO: make a pretty tooltip
                  {:type => 'number', :label => I18n.t('transferred')} ]

    # Values used for populating the rows of the table:
    avg_duration = weighting_relation.avg_duration.to_f/factor
    low_trim_point = weighting_relation.first_day_discount + 1
    high_trim_point = weighting_relation.first_day_surcharge - 1
    base_cost_rate = weighting_relation.cost_weight.to_f/factor
    effective_cost_weight = cost_weight.effective_cost_weight.to_f/factor
    discount_per_day = weighting_relation.discount_per_day.to_f/factor
    surcharge_per_day = weighting_relation.surcharge_per_day.to_f/factor

    one_day_cost_rate = base_cost_rate - discount_per_day*(low_trim_point - 1)
    many_days = [high_trim_point, actual_los].max + 5
    many_days_cost_rate = base_cost_rate + surcharge_per_day*(many_days - high_trim_point)
   
    if cost_weight.case_flag == EffectiveCostWeight::CaseType::TRANSFERRED
      transfer_flatrate = weighting_relation.transfer_flatrate.to_f/factor    
      one_day_transfer_rate = base_cost_rate - transfer_flatrate*(avg_duration-1)
      avg_transfer_rate = base_cost_rate
    end
    
    rows = [
    [1, one_day_cost_rate, '','', one_day_transfer_rate],
    [low_trim_point, base_cost_rate, 'lo', I18n.t('result.length-of-stay.low_trim_point'), nil],
    [avg_duration, base_cost_rate, 'avg',I18n.t('result.length-of-stay.average_los'), avg_transfer_rate],
    [high_trim_point, base_cost_rate, 'hi', I18n.t('result.length-of-stay.high_trim_point'), nil],
    [actual_los, effective_cost_weight, '***', I18n.t('result.length-of-stay.length-of-stay'), nil],
    [many_days, many_days_cost_rate, '','', nil]]
    
    sorted_rows = rows.sort_by { |row| row[0] }
    
    add_rows(sorted_rows)
  end
  
  def make_chart()
    options = { :width => 650, :height => 170,
                :legend => 'none',
                :interpolateNulls => true,
                :hAxis => { :title => 'Tage' },
                :vAxis => { :title => 'Kostengewicht' }}
    GoogleVisualr::Interactive::LineChart.new(self, options)
  end
end