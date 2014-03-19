class Mdc
  include Mongoid::Document
  field :code, type: String
  field :text, type: String, localize: true
  field :version, type: String
  field :prefix, type: String
  
  scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.drg_version) }

  index({code: 1, version: 1}, {:unique => true})


  def self.get_description_for(system_id, search_code)
    begin
      in_system(system_id).where(:code => search_code).first.text
    rescue NoMethodError
      ""
    end
  end
end
