# WebgrouperPatientCase holds all input variables for a certain patiant case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
# autors team1
class WebgrouperPatientCase < PatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  
  attr_accessor :age,
                :age_mode
                
  #TODO: Add more validations
  #   8. Falls Geburtsdatum und Aufnahmedatum angegegeben, wird das Alter errechnet.
  
  #   DONE- 1. Aufnahme- und Entlassdatum sind gültige Daten im Format 12.03.2012.
  #   DONE- 2. Aufnahme- und Entlassdatum liegen nicht in der Zukunft.
  #   DONE- 3. Urlaubstage ist positive Ganzzahl, leer oder 0.
  #   DONE- 4. Verweildauer ist grösser gleich 1 und ganzzahlig.
  #   DONE- 5. Falls Aufnahme- und Entlassdaten angegegeben sind, wird die Verweildauer berechnet (inklusive Abzug von Urlaub)
  #   DONE- 6. Geburtstag ist gültiges Datum im Format 12.03.2012 und liegt nicht in der Zukunft.
  #   DONE- 7. Alter: Wertbereich für Alter in Jahren: 1-124, Wetbereich für Alter in Tagen: 1-366.
  #   DONE- 9. Aufnahmegeichtsfeld wird nur angezeigt, falls Alter in Tagen.
  #   DONE- 10. Aufnahmegewicht Wertebereich: 250 - 19'999
  #   DONE- 11. Beatmungszeit: positive Ganzzahl
  
  
  validates :sex,             :presence => true
  validates_date :entry_date,      :on_or_before => :today
  validates_date :exit_date,       :on_or_before => :today, :after => :entry_date
  validates_date :birth_date,      :on_or_before => :today
  validates :leave_days,      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  validates :age,             :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 125}, :unless => :age_mode_days?
  validates :age,             :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 367}, :if => :age_mode_days?
  validates :age_years,       :presence => true
  validates :age_days,        :presence => true
  validates :adm_weight,      :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 250, :less_than_or_equal_to => 20000}, :if => :age_mode_days?
  validates :adm,             :presence => true
  validates :sep,             :presence => true
  validates :los,             :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  # validates :sdf,             :presence => true
  validates :hmv,             :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  # validates :pdx,             :presence => true
  # validates :diagnoses,       :presence => true
  # validates :procedures,      :presence => true
  
  # invokes superconstructor of java class PatientCase
	# prepares values of attribute hash for the ruby patient class.
  def initialize(attributes = {})
    super()
    if age_mode_days?
      self.age_days = self.age
    else
      self.age_years = self.age
    end
    
    self.age = 40
    self.los = 10
    self.birth_date = (today - 10.days).strftime("%d%m%Y")
    self.entry_date = (today - 10.days).strftime("%d%m%Y")
    self.exit_date = today.strftime("%d%m%Y")
    self.pdx = ""
    
    attributes.each do |name, value|
      if send(name).is_a? Fixnum
        value = value.to_i 
      end
      if name == "diagnoses" || name == "procedures"
        temp = []
        name == "procedures" ? length = 100 : length = 99
        length.times {temp << nil}
        tmp1 = temp.to_java(:string)
        tmp = [value].to_java(:string)
        (0..(tmp.size-1)).each {|i| tmp1[i] = tmp[i]}
        send("set_#{name}", tmp1)
      end
      send("#{name}=", value) unless name == "diagnoses" || name == "procedures"
    end
  end
  
  def persisted?
    false
  end
  
  private
  
  def age_mode_days?
    age_mode == 'days'
  end
  
  def today
    Time.now
  end
end
