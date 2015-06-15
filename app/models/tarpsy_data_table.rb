class TarpsyDataTable < GoogleVisualr::DataTable

  def initialize(tarpsy_result)
    super()
    new_columns [{type: 'number', label: I18n.t('result.length-of-stay.length-of-stay')}, # los
                 {type: 'number', label: I18n.t('result.cost-weight.legend') }, # cost weight
                 {type: 'string', role: 'annotation'}
                ]
    rows = []
    # Goes always through zero
    rows.push [0, 0, nil]
    # The effective cost weight on the effective length of stay
    rows.push [tarpsy_result.length_of_stay, tarpsy_result.effective_cost_weight,
               I18n.t('result.length-of-stay.length-of-stay-short')]
    # Phase 0
    phase_0 = tarpsy_result.phase(0)
    rows.push [7, phase_0.total_cost_weight, nil]
    phase_1 = tarpsy_result.phase(1)
    # Phase 1, if available
    unless phase_1.nil?
      rows.push [8, phase_0.total_cost_weight + phase_1.lump_sum + phase_1.cost_weight_per_day, nil]
      phase_2 = tarpsy_result.phase(2)
      # Phase 2, if available
      unless phase_2.nil?
        total = phase_1.total_cost_weight + phase_2.total_cost_weight
        rows.push [60, total, nil]
        last_los_shown = [60, tarpsy_result.length_of_stay].max + 10
        cw_last_los_shown = total + (last_los_shown - 60)*phase_2.cost_weight_per_day
        rows.push [last_los_shown, cw_last_los_shown, nil]
      end
    end
    add_rows(rows.sort_by!(&:first))
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