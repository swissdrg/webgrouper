#! /usr/bin/env python
import yaml

de_file = open("de.yml")
de_yml = yaml.load(de_file)

languages = ["fr", "it", "en"]

for lang in languages:
	lang_yml = yaml.load(open(lang + ".yml"))
	
	swissdrg_lang = open("messages_" + lang + ".properties")
	for line in swissdrg_lang:
		key, value = line.split("=")
		swissdrg_dict[key] = value
	
	addMissingKeys(

def addMissingKeys(keys_de, keys):
	for key, value in keys_de.items():
		if not key in keys:
			lang_value = blub
			keys[key] = lang_value


def initKeyChart(swissdrg_dict, de_yml):
	
