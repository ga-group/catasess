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

WITH <http://data.ga-group.nl/catasess/days/>
DELETE {
	?xcn
		day:observedOn ?nond .
}
WHERE {
	?xcn a day:TradingDay ;
		day:observedOn ?nond .
	FILTER(ISLITERAL(?nond))
	FILTER(STRENDS(STR(?xcn),'-Full') || STRENDS(STR(?xcn),'-Half'))
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

WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xcn a day:NonTradingDay ;
		day:activeSession sess:None ;
		day:observedOn ?nond ;
		day:neverCoincidesWith ?xcf ;
		cata:isTradingDayOf ?xc ;
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

WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xch a day:TradingDay ;
		day:observedOn ?nond ;
		day:neverCoincidesWith ?xcn , ?xcf ;
		cata:isTradingDayOf ?xc ;
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

## calendars for a currency
SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX cc: <https://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes-Adjunct/>
PREFIX ccy: <http://ga.local/ccy#>
PREFIX fccy: <https://spec.edmcouncil.org/fibo/ontology/FND/Accounting/ISO4217-CurrencyCodes/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>
PREFIX cmns-cls: <https://www.omg.org/spec/Commons/Classifiers/>
PREFIX cdr: <http://ga.local/cdr#>

WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xcn a day:NonSettlementDay ;
		cata:isSettlementDayOf ?fccy ;
		day:observedOn ?d , ?we ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon .
}
USING <http://data.ga-group.nl/cal/>
WHERE {
	?cd a cdr:Calendar ;
		cdr:calendar-for ?ccy ;
		cdr:ccy-as-used-in ?cc .
	FILTER(STRSTARTS(STR(?ccy),STR(ccy:)))

	## find holidays
	OPTIONAL {
	?cd cdr:nonSettleDay ?d
	}
	## find weekends
	OPTIONAL {
	?cd cdr:weekend ?we
	}

	OPTIONAL {
	?cd pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?cd prov:generatedAtTime ?impon
	}

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?ccy),STR(ccy:)),'-',STRAFTER(STR(?cc),STR(cc:)),'-Non')) AS ?xcn)
	BIND(IRI(CONCAT(STR(fccy:),STRAFTER(STR(?ccy),STR(ccy:)))) AS ?fccy)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

## region calendars with no ccy, truly regional calendars
SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX lcc-3166-2-adj: <https://www.omg.org/spec/LCC/Countries/ISO3166-2-SubdivisionCodes-Adjunct/>
PREFIX ccy: <http://ga.local/ccy#>
PREFIX day: <http://data.ga-group.nl/catasess/days/>
PREFIX cmns-cls: <https://www.omg.org/spec/Commons/Classifiers/>
PREFIX cdr: <http://ga.local/cdr#>

WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xcn a day:PublicHoliday ;
		day:observedOn ?d ;
		day:observedIn ?cc ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon .
}
USING <http://data.ga-group.nl/cal/>
WHERE {
	?cd a cdr:RegionCalendar ;
		cdr:follows-observances-of ?cc .
	FILTER NOT EXISTS {
	?cd cdr:calendar-for ?some
	}
	FILTER(STRSTARTS(STR(?cc),STR(lcc-3166-2-adj:)))

	## find holidays
	OPTIONAL {
	?cd cdr:nonSettleDay ?d
	}

	OPTIONAL {
	?cd pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?cd prov:generatedAtTime ?impon
	}

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?cc),STR(lcc-3166-2-adj:)),'-Non')) AS ?xcn)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/days/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;
