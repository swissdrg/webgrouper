# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

load 'db/seed_systems.rb'
load 'db/seed_icds.rb'
load 'db/seed_chops.rb'
load 'db/seed_drgs.rb'
load 'db/seed_supplements.rb'
load 'db/seed_supplement_descriptions.rb'
load 'db/seed_mdcs.rb'
