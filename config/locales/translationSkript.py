#! /usr/bin/env python
# -*- coding: UTF-8 -*-

import yaml
import os

swissdrg_dict = {}

def addMissingKeys(keys_de, keys_other, lang):
	if type(keys_other) is str:
		return
	for key, value in keys_de.items():
		if not key in keys_other:
			if type(value) is dict:
				keys_other[key] = {}
			else:
				swissdrg_key = getSwissdrgKey(value)
				if swissdrg_key != None:
					keys_other[key] = getSwissdrgValue(swissdrg_key, lang)
				else:
					keys_other[key] = None
		if type(value) is dict:
			addMissingKeys(keys_de[key], keys_other[key], lang)

def getSwissdrgValue(search_key, lang):
	return swissdrg_dict[lang][key]

def getSwissdrgKey(search_value):
	for key, value in swissdrg_dict["de"].items():
		if value is search_value:
			print "returning " + key
			return key
	return None
			
def main():
	de_file = open("de.yml")
	de_yml = yaml.load(de_file)
	print "loaded german yml file"
	languages = ["fr", "it", "en"]
	initSwissdrgDicts()
	print swissdrg_dict
	for lang in languages:
		lang_yml = yaml.load(open(lang + ".yml"))
		addMissingKeys(de_yml["de"], lang_yml[lang], lang)
		test_file_path = 'test_'+ lang + '.yaml'
		#os.remove(test_file_path)
		stream = file(test_file_path, 'w')
		yaml.dump(lang_yml, stream,  default_flow_style=False, encoding=('utf-8'))
	print 'Terminated!'

def initSwissdrgDicts():
	global swissdrg_dict
	for lang in ["de", "en", "it", "fr"]:
		swissdrg_lang = open("messages_" + lang + ".properties")
		dict = {}
		swissdrg_dict[lang] = dict
		for line in swissdrg_lang:
			if not "#" in line:
				key, value = line.split("=", 1)
				dict[key] = sanitizeString(value)

def sanitizeString(string):
	string = string.replace("\u00F6", "ö")
	string = string.replace("\u00DF", "ss")
	string = string.replace("\u00E4", "ä")
	string = string.replace("\u00FC", "ü")
	return string
	
if __name__ == "__main__":
    main()