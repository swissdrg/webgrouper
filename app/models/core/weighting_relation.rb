# Decorator around weighting relation to add various functionality.
module WeightingRelation
  def has_first_day_discount?
    self.first_day_discount != 0
  end

  def has_first_day_surcharge?
    self.first_day_surcharge != 0
  end
end