#! /usr/bin/env python
# -*- coding: UTF-8 -*-

# This script was added to keep all translation files synchronized. It is assumed that german is
# the most completed language. The missing keys in otherlanguages are added either with the value
# "Translation missing" or the value provided by the old grouper translations.
import yaml
import os
import codecs

swissdrg_dict = {}

def addMissingKeys(keys_de, keys_other, lang):
	if type(keys_other) is str:
		return
	for key, value in keys_de.items():
		if not key in keys_other:
			if type(value) is dict:
				keys_other[key] = {}
			else:
				swissdrg_key = get_swissdrg_key(value)
				if swissdrg_key != None:
					keys_other[key] = swissdrg_dict[lang][swissdrg_key]
				else:
					keys_other[key] = "Translation missing"
		if type(value) is dict:
			addMissingKeys(keys_de[key], keys_other[key], lang)
			
# Returns the key if the given value has a matching swissdrg key
def get_swissdrg_key(search_value):
	if type(search_value) is str:
		search_value_without = search_value.replace(":", "")
		print search_value_without
	else:
		search_value_without = search_value
	for key, value in swissdrg_dict["de"].items():
		if value == search_value or value == search_value_without:
			return key
	return None
			
def main():
	languages = ["fr", "it", "en"]
	files = ["", "simple_form."]
	init_swissdrg_dicts()
	
	for f in files:
		de_file = codecs.open("old_locales/" + f + "de.yml", "r", "utf-8")
		de_yml = yaml.load(de_file)
		for lang in languages:
			lang_yml = yaml.load(codecs.open("old_locales/" + f + lang + ".yml", "r", "utf-8"))
			test_file_path = f + lang + '.yml'
			print "Trying to complete " + test_file_path
			addMissingKeys(de_yml["de"], lang_yml[lang], lang)
			stream = file(test_file_path, 'w')
			yaml.safe_dump(lang_yml, stream, allow_unicode=True, default_flow_style=False)
	print 'Terminated!'

def init_swissdrg_dicts():
	global swissdrg_dict
	for lang in ["de", "en", "it", "fr"]:
		swissdrg_lang = codecs.open("old_locales/" + "messages_" + lang + ".properties.utf", "r", "utf-8")
		dict = {}
		swissdrg_dict[lang] = dict
		for line in swissdrg_lang:
			if not "#" in line:
				key, value = line.split("=", 1)
				dict[key] = sanitizeString(value)

def sanitizeString(string):
	string = string.strip()
	string = string.replace("\u00F6", "ö")
	string = string.replace("\u00DF", "ss")
	string = string.replace("\u00E4", "ä")
	string = string.replace("\u00FC", "ü")
	return string
	
if __name__ == "__main__":
    main()