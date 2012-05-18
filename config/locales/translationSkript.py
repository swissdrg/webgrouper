#! /usr/bin/env python
# -*- coding: UTF-8 -*-

import yaml
import os
import codecs
import unicodedata as ud

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
					keys_other[key] = swissdrg_dict[lang][swissdrg_key]
				else:
					keys_other[key] = None
		if type(value) is dict:
			addMissingKeys(keys_de[key], keys_other[key], lang)

def getSwissdrgKey(search_value):
	for key, value in swissdrg_dict["de"].items():
		if value == search_value:
			print "returning " + key
			return key
	return None
			
def main():
	de_file = codecs.open("de.yml.old", "r", "utf-8")
	de_yml = yaml.load(de_file)
	print "loaded german yml file"
	#languages = ["fr", "it", "en"]
	languages = ["fr"]
	initSwissdrgDicts()
	print de_yml
	for lang in languages:
		lang_yml = yaml.load(codecs.open(lang + ".yml.old", "r", "utf-8"))
		addMissingKeys(de_yml["de"], lang_yml[lang], lang)
		test_file_path = lang + '.yml'
		#os.remove(test_file_path)
		stream = file(test_file_path, 'w')
		yaml.safe_dump(lang_yml, stream, allow_unicode=True, default_flow_style=False)
	print 'Terminated!'

def initSwissdrgDicts():
	global swissdrg_dict
	for lang in ["de", "en", "it", "fr"]:
		swissdrg_lang = codecs.open("messages_" + lang + ".properties.utf", "r", "utf-8")
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