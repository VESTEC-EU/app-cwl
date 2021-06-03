all: ipic.cwl ipic-input-gen.cwl ipic-b0-ensemble.cwl

pysource = $(wildcard cwltran/*.py)

input-map.yml : input-map.py all-inputs.yml
	./input-map.py all-inputs.yml

ipic.cwl: ipic.cwl.tmpl all-inputs.yml input-map.yml $(pysource)
	python3 -m cwltran $< $@

ipic-input-gen.cwl: ipic-input-gen.cwl.tmpl all-inputs.yml $(pysource)
	python3 -m cwltran $< $@

ipic-b0-ensemble.cwl: ipic-b0-ensemble.cwl.tmpl all-inputs.yml $(pysource)
	python3 -m cwltran $< $@

.PHONY: clean
clean:
	rm -f input-map.yml ipic.cwl ipic-input-gen.cwl ipic-b0-ensemble.cwl ipic-types.yml
