class LosDataTable < GoogleVisualr::DataTable
  def initialize()
    super()
    new_column('string', 'label')
    new_column('number', 'Tage')
    new_column('number', I18n.t('result.cost-weight.legend'))
    add_rows([
    ['blub',10,10],
    ['asdf',15,15]]) 
  end
  
  def make_chart()
    options = {:width => 600, :height => 170, :title => 'Diagramm'}
    GoogleVisualr::Interactive::AreaChart.new(self, options)
  end
end