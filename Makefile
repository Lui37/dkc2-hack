j1.0:
	cp sfc/dkc2_j1.0.sfc target/dkc2hack_j1.0.sfc && cd src && asar -Drom_revision=0 main.asm ../target/dkc2hack_j1.0.sfc && cd -

j1.1:
	cp sfc/dkc2_j1.1.sfc target/dkc2hack_j1.1.sfc && cd src && asar -Drom_revision=1 main.asm ../target/dkc2hack_j1.1.sfc && cd -

u1.0:
	cp sfc/dkc2_u1.0.sfc target/dkc2hack_u1.0.sfc && cd src && asar -Drom_revision=0 main.asm ../target/dkc2hack_u1.0.sfc && cd -

u1.1:
	cp sfc/dkc2_u1.1.sfc target/dkc2hack_u1.1.sfc && cd src && asar -Drom_revision=1 main.asm ../target/dkc2hack_u1.1.sfc && cd -

j1.1ss:
	cp "sfc/DKC2 Practice 0.10.sfc" "target/DKC2 Practice 0.10 + timer.sfc" && cd src && asar -Drom_revision=1 main.asm  "../target/DKC2 Practice 0.10 + timer.sfc" && cd -


all: j1.0 j1.1 u1.0 u1.1 j1.1ss

clean:
	rm -f target/*
