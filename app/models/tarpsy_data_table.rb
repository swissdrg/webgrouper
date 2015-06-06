class TarpsyDataTable < GoogleVisualr::DataTable

  def initialize(tarpsy_result)
    super()
    new_columns [{:type => 'number'}, # los
                 {:type => 'number'} # cost weight
                ]
    rows = []
    rows.push [0, 0]
    phase_0 = tarpsy_result.phase(0)
    rows.push [7, phase_0.total_cost_weight]
    phase_1 = tarpsy_result.phase(1)
    if phase_1.nil?
      # TODO
    else
      rows.push [7, phase_0.total_cost_weight + phase_1.lump_sum]
      phase_2 = tarpsy_result.phase(2)
      if phase_2.nil?
        # TODO: Double check how this should be handled.
        los_shown = [7, tarpsy_result.length_of_stay].max + 10
        cw_shown = phase_1.lump_sum + (los_shown - 7) * phase_1.cost_weight_per_day
        rows.push [los_shown, cw_shown]
      else
        total = phase_1.total_cost_weight + phase_2.total_cost_weight
        rows.push [60, total]
        last_los_shown = [60, tarpsy_result.length_of_stay].max + 10
        cw_last_los_shown = total + (last_los_shown - 60)*phase_2.cost_weight_per_day
        rows.push [last_los_shown, cw_last_los_shown]
      end
    end
    add_rows(rows)
  end

  def make_chart
    options = {:width => 475, :height => 170,
               :legend => 'none',
               :interpolateNulls => true,
               :hAxis => {:gridlines => {:count => 10},
                          :title => I18n.t('datetime.distance_in_words.x_days', :count => '')},
               :vAxis => {:title => I18n.t('result.cost-weight.legend')},
               :allowHtml => "true"}
    GoogleVisualr::Interactive::LineChart.new(self, options)
  end

end