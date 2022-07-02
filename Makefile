SHELL := /bin/zsh

sparql := /home/freundt/usr/apache-jena/bin/sparql
stardog := STARDOG_JAVA_ARGS='-Dstardog.default.cli.server=http://plutos:5820' /home/freundt/usr/stardog/bin/stardog

all: Catalogues.ttl TradingSessions.ttl
check: check.Catalogues check.TradingSessions
canon: Catalogues.ttl.canon TradingSessions.ttl.canon

%.ttl.canon: %.ttl
	rapper -i turtle $< >/dev/null
	ttl2ttl --sortable $< \
	| tr '@' '\001' \
	| sort -u \
	| tr '\001' '@' \
	| ttl2ttl -B \
	> $@ && mv $@ $<

check.TradingSessions: ADDITIONAL = Catalogues.ttl

check.%: %.ttl shacl/%.shacl.ttl
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/iso10383/" iso $< $(ADDITIONAL)
	$(stardog) icv report --output-format PRETTY_TURTLE -g "http://data.ga-group.nl/iso10383/" -r -l -1 iso shacl/$*.shacl.ttl \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

check.%: %.ttl shacl/%.shacl.sql
	$(RM) tmp/shacl-*.qry
	mawk 'BEGIN{f=0}/\f/{f++;next}{print>"tmp/shacl-"f".qry"}' $(filter %.sql, $^)
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/iso10383/" iso $< $(ADDITIONAL)
	for i in tmp/shacl-*.qry; do \
		$(stardog) query execute --format PRETTY_TURTLE -g "http://data.ga-group.nl/iso10383/" -r -l -1 iso $${i}; \
	done \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

%.rpt: /tmp/check.%.ttl
	$(sparql) --results text --data $< --query sql/valrpt.sql


TradingSessions.ttl: TradingSessions-aux.ttl
	ttl2ttl --sortable $(filter %.ttl, $^) \
	> $@.t
	-cat $@ >> $@.t
	mv $@.t $@
	$(MAKE) $@.canon

Catalogues.ttl: Catalogues-aux.ttl
	ttl2ttl --sortable $(filter %.ttl, $^) \
	> $@.t
	-cat $@ >> $@.t
	mv $@.t $@
	$(MAKE) $@.canon

setup-stardog:                                                                                                                                                                                          
	$(stardog)-admin db create -o reasoning.sameas=OFF -n iso
	$(stardog) namespace add --prefix fibo-fbc-fct-mkt --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/Markets/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-mkti --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/MarketsIndividuals/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-bc --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCenters/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-bci --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCentersIndividuals/ iso

unsetup-stardog:
	$(stardog)-admin db drop iso
