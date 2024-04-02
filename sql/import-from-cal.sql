SPARQL
DEFINE sql:log-enable 3

#SELECT *
#FROM <http://data.ga-group.nl/iso10383/MarketsIndividuals/>
#FROM <http://data.ga-group.nl/catasess/catalogues/>
WITH <http://data.ga-group.nl/catasess/catalogues/>
INSERT {
	?x tempo:validFrom ?from
}
USING <http://data.ga-group.nl/iso10383/MarketsIndividuals/>
WHERE {
	?x a fibo-fpas:FinancialProductCatalog ;
		fibo-rel:isProvidedBy ?mic .
	SERVICE <http://zappa.ga.local:8890/sparql> {
	?mic tempo:validFrom ?from .
	}
}
;

SET u{GRAPH} http://data.ga-group.nl/catasess/catalogues/;
SET u{PRED} tempo:validFrom;
LOAD '/data/data-source/bbfix/sql/prov-mini-loop.sql';
CHECKPOINT;


SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>
PREFIX cmns-cls: <https://www.omg.org/spec/Commons/Classifiers/>
PREFIX cdr: <http://ga.local/cdr#>

##SELECT *
##FROM <http://data.ga-group.nl/bps/>
##FROM <http://data.ga-group.nl/cal/>
WITH <http://data.ga-group.nl/catasess/days/>
DELETE {
	?xcn
		day:observedOn ?nond .
}
WHERE {
	?xcn a fibo-fip:TradingDay ;
		day:observedOn ?nond .
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>
PREFIX cmns-cls: <https://www.omg.org/spec/Commons/Classifiers/>
PREFIX cdr: <http://ga.local/cdr#>

##SELECT *
##FROM <http://data.ga-group.nl/bps/>
##FROM <http://data.ga-group.nl/cal/>
WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xcn a fibo-fip:TradingDay ;
		day:activeSession sess:None ;
		day:observedOn ?nond ;
		day:neverCoincidesWith ?xcf ;
		fibo-fip:isTradingDayOf ?xc ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon .
}
USING <http://data.ga-group.nl/bps/>
USING <http://data.ga-group.nl/cal/>
USING <http://data.ga-group.nl/catasess/catalogues/>
WHERE {
	{
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc ;
		gas:cdr-code ?cd .

	## make sure ?cd is the only cdr-code
	OPTIONAL {
	?c gas:cdr-code ?c2
	FILTER(?c2 != ?cd)
	}
	FILTER(!BOUND(?c2))
	} UNION {
	## also go for stuff in cal.ttl with cata:assigned-catalogue
	?cd a cdr:Calendar ;
		cata:assigned-catalogue ?xc .
	}

	OPTIONAL {
	## find non-trading days
	?cd cdr:nonTradingDay ?nond .
	## ... obeying the catalogue_s validity
	?xc tempo:validFrom ?from .
	FILTER(?nond >= ?from)
	}

	OPTIONAL {
	?cd pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?cd prov:generatedAtTime ?impon
	}

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Non')) AS ?xcn)
	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Full')) AS ?xcf)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;


SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>
PREFIX cmns-cls: <https://www.omg.org/spec/Commons/Classifiers/>
PREFIX cdr: <http://ga.local/cdr#>

##SELECT *
##FROM <http://data.ga-group.nl/bps/>
##FROM <http://data.ga-group.nl/cal/>
WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xch a fibo-fip:TradingDay ;
		day:observedOn ?nond ;
		day:neverCoincidesWith ?xcn , ?xcf ;
		fibo-fip:isTradingDayOf ?xc ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon .
}
USING <http://data.ga-group.nl/bps/>
USING <http://data.ga-group.nl/cal/>
USING <http://data.ga-group.nl/catasess/catalogues/>
WHERE {
	{
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc ;
		gas:cdr-code ?cd .

	## make sure ?cd is the only cdr-code
	OPTIONAL {
	?c gas:cdr-code ?c2
	FILTER(?c2 != ?cd)
	}
	FILTER(!BOUND(?c2))
	} UNION {
	## also go for stuff in cal.ttl with cata:assigned-catalogue
	?cd a cdr:Calendar ;
		cata:assigned-catalogue ?xc .
	}

	## find partial trading days
	?cd cdr:partialTradingDay ?nond .
	## ... obeying the catalogue_s validity
	?xc tempo:validFrom ?from .
	FILTER(?nond >= ?from)

	OPTIONAL {
	?cd pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?cd prov:generatedAtTime ?impon
	}

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Half')) AS ?xch)
	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Non')) AS ?xcn)
	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Full')) AS ?xcf)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/days/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;
