SHELL := /bin/zsh

include .make.env

NOW := $(shell dateconv now)Z
FILES = catalogues.ttl regimes.ttl sessions.ttl days.ttl

all: $(FILES:%.ttl=.imported.%)
check: $(FILES:%.ttl=check.%)

.%.ttl.canon: %.ttl
	rapper -i turtle $< >/dev/null
	ttl2ttl --sortable $< \
	| tr '@' '\001' \
	| sort -u \
	| tr '\001' '@' \
	| ttl2ttl -B \
	> $@ && mv $@ $< \
	&& touch $@

check.sessions: ADDITIONAL = catalogues.ttl regimes.ttl
check.days: ADDITIONAL = catalogues.ttl sessions.ttl

tmp/import-from-bps.out: /data/data-source/bbstk/.imported.bps
tmp/import-from-cal.out: /data/data-source/bbstk/.imported.bps /data/data-source/bbstk/.imported.cal

check.%: %.ttl shacl/%.shacl.ttl
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/catasess/" catasess $< $(ADDITIONAL)
	$(stardog) icv report --output-format PRETTY_TURTLE -g "http://data.ga-group.nl/catasess/" -r -l -1 catasess shacl/$*.shacl.ttl \
        >> /tmp/$@.ttl || true
	if test -f shacl/$*.shacl.sql; then \
		m4 shacl/$*.shacl.sql \
		| $(ttlsql) \
			>> /tmp/$@.ttl || true; \
	fi
	$(MAKE) $*.rpt

%.rpt: /tmp/check.%.ttl
	$(sparql) --results text --data $< --query sql/valrpt.sql
%.anno: /tmp/check.%.ttl
	mawk '!(/violated-shape/||/warned-shape/)||/\.$$/&&$$0="."' $*.ttl \
	> $@
	$(sparql) --data $< --query sql/rptanno.sql \
	>> $@ && mv $@ $*.ttl


tmp/%.out:: sql/%.sql
	$(csvsql) $< \
	| unqpc --only-printable \
	> $@.t && mv $@.t $@

tmp/%.out:: tmp/%.sql
	$(csvsql) $< \
	| unqpc --only-printable \
	| tee $@.t && mv $@.t $@


.imported.%:: %.ttl.repl sql/repl-%.sql
	rapper -c -i turtle $<
	$(csvsql) < sql/repl-$*.sql \
	&& touch $@ && $(RM) -- $<

.imported.%:: %.ttl.add sql/ladd-%.sql
	rapper -c -i turtle $<
	$(csvsql) < sql/ladd-$*.sql \
	&& touch $@ && $(RM) -- $<

.imported.%:: %.ttl sql/load-%.sql
	$(riot) --validate --syntax=TURTLE $<
	$(csvsql) < sql/load-$*.sql \
	&& touch $@


/var/scratch/lakshmi/freundt/%.ttl: sql/dump-%.sql .imported.%
	m4 $< \
	| $(csvsql)

export.%: /var/scratch/lakshmi/freundt/%.ttl
	-mawk '(x+=$$0=="")<=3&&($$0==""||(x=0)||1)' $*.ttl > $@
	sed 's/rdf:type/a/' /var/scratch/lakshmi/freundt/$*.ttl \
	| ttl2ttl --sortable --expand-generic \
	| sort -u \
	| ttl2ttl -BQU \
	| sed '/^@/d;s@rdf:predicate\ta@rdf:predicate\trdf:type@' \
	>> $@
	touch .imported.$*
	mv $@ $*.ttl

export.void: $(FILES:%.ttl=tmp/%.void)
	-mawk '(x+=$$0=="")<=3&&($$0==""||(x=0)||1)' void.ttl > $@
	@echo >> $@
	@echo "## with summaries" >> $@
	cat $^ \
	>> $@
	mv $@ void.ttl && ln -f void.ttl tmp/void_$(NOW).ttl

tmp/%.void: .imported.%
	$(ttlsql) \
		sql/void-summary.sql \
		sql/void-vocabulary.sql \
		sql/void-class-partitions.sql \
		sql/void-no-class-partition.sql \
		sql/void-property-partitions.sql \
		-u GRAPH="http://data.ga-group.nl/catasess/$*/" \
	| ttl2ttl --sortable --expand-generic \
	| sed 's@<urn:sha1:\([0-9a-f]*\)>@ _:b\1@; s/rdf:type\t/a\t/; /^@/d' \
	| sort -u \
	| ttl2ttl -B \
	> $@


setup-stardog:
	$(stardog_admin) db create -o reasoning.sameas=OFF -n catasess
	$(stardog) namespace add --prefix cata --uri http://data.ga-group.nl/catasess/catalogues/ catasess
	$(stardog) namespace add --prefix sess --uri http://data.ga-group.nl/catasess/sessions/ catasess
	$(stardog) namespace add --prefix regm --uri http://data.ga-group.nl/catasess/regimes/ catasess

unsetup-stardog:
	$(stardog)-admin db drop catasess
