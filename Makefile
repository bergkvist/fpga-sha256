.PHONY: test watch

test: sha256_tb.vvp
	vvp -n $<

sha256_tb.vvp: sha256_tb.sv sha256.sv
	iverilog -g2012 $^ -o $@

watch:
	ls *.sv | entr -csr "make test"
