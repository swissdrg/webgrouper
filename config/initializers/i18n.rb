# Configuring fallbacks:
# This is only for demos and should be deactivated again afterwards
# DEACTIVATED FOR DEBUGING

require "i18n/backend/fallbacks" 
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
# fallback language is always german
I18n.fallbacks.map(:en => :de, :fr => :de, :it => :de)
