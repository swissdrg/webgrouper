include Java 

DEFAULT_SYSTEM = 12

require 'lib/grouper-0.3.0-jar-with-dependencies.jar'

def spec_folder
  production_spec_folder = File.join('/','home', 'tim', 'grouperspecs')
  development_spec_folder = File.join(Rails.root,'lib', 'grouperspecs')
  if File.directory?(production_spec_folder)
    production_spec_folder
  else
    development_spec_folder
  end
end

GROUPERS = System.all.each_with_object({}) do |s, hash|
  hash[s.system_id] = new XMLWorkspaceReader().readWorkspace(s.workspace)
end

# TODO: Catalogues, need change in grouper first.
CATALOGUES = System.all.each_with_object({}) do |s, hash|
  hash[s.system_id] = new XMLWorkspaceReader().readWorkspace(s.workspace)
end