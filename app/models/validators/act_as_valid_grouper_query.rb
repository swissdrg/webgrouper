# This module validates the attributes submitted by the form.
# The names of the attributes are given by the underlying java-wrapper, which can be
# found in the directory /lib including source & javadoc.
module ActAsValidGrouperQuery
  def self.included(base)
    base.extend ActiveModel::Naming
    base.extend ActiveModel::Translation
    base.send :include, ActiveModel::Validations
    base.send :include, ActiveModel::Conversion
    
    base.validates      :sex,             :presence => true
    base.validates_date :entry_date,      :on_or_before => :today, :allow_blank => true
    base.validates_date :exit_date,       :on_or_before => :today, :on_or_after => :entry_date, :allow_blank => true
    base.validates_date :birth_date,      :on_or_before => :entry_date, :allow_blank => true
    base.validates      :leave_days,      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
    base.validates      :age,             :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 125}, :unless => :age_mode_days?
    base.validates      :age,             :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 367}, :if => :age_mode_days?
    # Admission weight
    base.validates      :adm_weight,      :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 125, :less_than_or_equal_to => 20000 }, :if => :age_mode_days?
    # Admission mode
    base.validates      :adm,             :presence => true
    # Separation mode
    base.validates      :sep,             :presence => true
    # Length of stay
    base.validates      :los,             :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
    # Artificial respiration time
    base.validates      :hmv,             :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
    # Main diagnosis
    base.validates      :pdx,             :presence => true, :existing_icd => true, :if => lambda{ |wpc| wpc.manual_submission || !wpc.pdx.blank? || !wpc.diagnoses.blank? || !wpc.procedures.blank? }
    base.validates      :diagnoses,       :existing_icd => true
    base.validates      :procedures,      :existing_chop => true
  end

end
