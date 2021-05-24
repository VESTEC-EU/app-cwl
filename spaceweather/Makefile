all: ipic.cwl ipic-input-gen.cwl

ipic.cwl: ipic-template.cwl all-inputs.yml input-map.yml dumb_include.py
	./dumb_include.py $< $@

ipic-input-gen.cwl: ipic-input-gen-template.cwl all-inputs.yml dumb_include.py
	./dumb_include.py $< $@

input-map.yml : input-map.py all-inputs.yml
	./input-map.py all-inputs.yml

