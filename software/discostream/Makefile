
BINARY=discostream
MAIN_PACKAGE=cmd/main.go
LDFLAGS=-ldflags="-v"
# omit symbol table, omit DWARF debugging info, verbose
# LDFLAGS=-ldflags="-s -w -v"
HOST=<YOUR-HOSTNAME>
DEST_FOLDER=disco
TEMPLATES=templates/
TEMPL_ARCHIVE=templ.tar

SKETCHES=uioTest hello

all: riscv

.PHONY: riscv
riscv:
	GOOS=linux GOARCH=riscv64 CGO_ENABLED=0 go build $(LDFLAGS) -o $(BINARY) $(MAIN_PACKAGE)

.PHONY: sketches
sketches: $(SKETCHES)
	echo "hello, world"

.PHONY: $(SKETCHES)
$(SKETCHES): %: sketches/%.go
	echo $@
	GOOS=linux GOARCH=riscv64 CGO_ENABLED=0 go build $(LDFLAGS) -o $@ sketches/$@.go

.PHONY: uiotest
uiotest:
	GOOS=linux GOARCH=riscv64 CGO_ENABLED=0 go build $(LDFLAGS) -o uiotest sketches/uioTest.go

folder:
	ssh root@$(HOST) mkdir -p $(DEST_FOLDER)

.PHONY: templates
templates:
	tar -cf $(TEMPL_ARCHIVE) $(TEMPLATES)
	scp $(TEMPL_ARCHIVE) root@$(HOST):/root
	ssh root@$(HOST) tar -xf /root/$(TEMPL_ARCHIVE) -C $(DEST_FOLDER)

.PHONY: upload
upload: riscv folder
	scp $(BINARY) root@$(HOST):/root/$(DEST_FOLDER)/

.PHONY: clean
clean:
	go clean
	rm -f $(BINARY)
	rm -f $(SKETCHES)
