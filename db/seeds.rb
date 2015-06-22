# Sorry, this is dead slow, but automatically does all stuff necessary like creating indizes etc, so nothing can
# get forgotten. If you just want to seed a single model, execute the appropriate command in the rails console.
# For seeding to the production database, you'll need to open an ssh tunnel, since mongodb is not accessible from
# the outside, eg with:
# ssh sm@webgrouper.swissdrg.org -L 27017:77.95.120.68:27017 -N
start = Time.now
load 'db/seed_tarpsy_systems.rb'
load 'db/seed_systems.rb'
load 'db/seed_icds.rb'
load 'db/seed_chops.rb'
load 'db/seed_drgs.rb'
load 'db/seed_supplements.rb'
load 'db/seed_mdcs.rb'
puts "Took #{(Time.now - start).to_s} seconds"
