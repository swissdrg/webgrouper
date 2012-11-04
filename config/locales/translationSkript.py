#! /usr/bin/env python
# -*- coding: UTF-8 -*-

# This script was added to keep all translation files synchronized. It is assumed that german is
# the most completed language. The missing keys in other languages are added either with the value
# "Translation missing" or the value provided by the old grouper translations.

# For now, the backup files must be created by hand (just copy them into the old_locales folder)
# TODO: Make it all automatic
import yaml
import os
import codecs

def fillInNewTranslations(keys_de, keys_other, new_translations):
	if type(keys_other) is str:
		return
	for key, value in keys_de.items():
		if not key in keys_other or needsTranslation(keys_other[key]):
			if type(value) is dict:
				keys_other[key] = {}
			else:
				if key in new_translations:
					keys_other[key] = new_translations[key]
				else:
					keys_other[key] = None
		if type(value) is dict:
			fillInNewTranslations(keys_de[key], keys_other[key], new_translations)
			
def needsTranslation(value):
	if value is None:
		return True
	else: 
		return value == u""
			
def main():
	languages = ["fr", "it", "en"]
	files = ["", "simple_form."]
	
	new_trans = dict(en="translations_webgrouper_batchgrouper-e.txt",
					 fr="translations_webgrouper_batchgrouper-f.txt",
					 it="translations_webgrouper_batchgrouper-i.txt")
	
	for f in files:
		de_file = codecs.open("old_locales/" + f + "de.yml", "r", "utf-8")
		de_yml = yaml.load(de_file)
		for lang in languages:
			new_trans_yaml = yaml.load(codecs.open("old_locales/" + new_trans[lang], "r", "ISO-8859-1"))
			lang_yml = yaml.load(codecs.open("old_locales/" + f + lang + ".yml", "r", "utf-8"))
			test_file_path = f + lang + '.yml'
			print "Trying to complete " + test_file_path
			fillInNewTranslations(de_yml["de"], lang_yml[lang], new_trans_yaml)
			stream = file(test_file_path, 'w')
			yaml.safe_dump(lang_yml, stream, allow_unicode=True, default_flow_style=False)
	print 'Terminated!'
	
if __name__ == "__main__":
    main()