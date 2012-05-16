#! /usr/bin/env python
import yaml
import os

def addMissingKeys(keys_de, keys_other):
	if type(keys_other) is str:
		return
	for key, value in keys_de.items():
		if not key in keys_other:
			if type(value) is dict:
				keys_other[key] = {}
			else:
				keys_other[key] = ' '
		if type(value) is dict:
			addMissingKeys(keys_de[key], keys_other[key])
			
def main():
	de_file = open("de.yml")
	de_yml = yaml.load(de_file)
	print "loaded german yml file"
	languages = ["fr", "it", "en"]
	
	for lang in languages:
		lang_yml = yaml.load(open(lang + ".yml"))
		addMissingKeys(de_yml["de"], lang_yml[lang])
		test_file_path = 'test_'+ lang + '.yaml'
		os.remove(test_file_path)
		stream = file(test_file_path, 'w')
		yaml.dump(lang_yml, stream,  default_flow_style=False, encoding=('utf-8'))
	print 'Terminated!'

def initSwissDRGdict():
	swissdrg_lang = open("messages_" + lang + ".properties")
	for line in swissdrg_lang:
		key, value = line.split("=")
		swissdrg_dict[key] = value
		
if __name__ == "__main__":
    main()