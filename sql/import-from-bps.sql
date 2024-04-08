SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX cmns-cls: <https://www.omg.org/spec/Commons/Classifiers/>

##SELECT *
##FROM <http://data.ga-group.nl/bps/>
WITH <http://data.ga-group.nl/catasess/catalogues/>
INSERT {
	?xc a fibo-fpas:FinancialProductCatalog , owl:NamedIndividual ;
		cmns-cls:isClassifiedBy ?p ;
		fibo-rel:isProvidedBy ?fmic ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon ;
		pav:sourceAccessedOn ?sacon ;
		pav:sourceLastAccessedOn ?slaon .
}
USING <http://data.ga-group.nl/bps/>
WHERE {
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc .
	OPTIONAL {
	?c pav:importedOn ?impon
	}
	OPTIONAL {
	?c pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?c pav:sourceAccessedOn ?sacon
	}
	OPTIONAL {
	?c pav:sourceLastAccessedOn ?slaon
	}
	BIND(IRI(CONCAT(STR(fibo-mic:),'Exchange-',STRBEFORE(STRAFTER(STR(?xc),STR(cata:)),'-'))) AS ?fmic)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/catalogues/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;


SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>

##SELECT *
##FROM <http://data.ga-group.nl/bps/>
WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xcd a fibo-fip:TradingDay ;
		day:activeSession ?xs ;
		fibo-fip:isTradingDayOf ?xc ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon ;
		pav:sourceAccessedOn ?sacon ;
		pav:sourceLastAccessedOn ?slaon .
}
USING <http://data.ga-group.nl/bps/>
WHERE {
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc .
	OPTIONAL {
	?c pav:importedOn ?impon
	}
	OPTIONAL {
	?c pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?c pav:sourceAccessedOn ?sacon
	}
	OPTIONAL {
	?c pav:sourceLastAccessedOn ?slaon
	}

	OPTIONAL {
	[] a fibo-fip:TradingSession ;
		fibo-fip:isTradingSessionOf ?c ;
		skos:exactMatch|skos:closeMatch ?xs
	FILTER(STRSTARTS(STRAFTER(STR(?xs),STR(sess:)),STRAFTER(STR(?xc),STR(cata:))))
	}

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Full')) AS ?xcd)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/days/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;


SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>

##SELECT *
##FROM <http://data.ga-group.nl/bps/>
WITH <http://data.ga-group.nl/catasess/sessions/>
INSERT {
	?xs a fibo-fip:TradingSession ;
		fibo-fip:isTradingSessionOf ?xc ;
		sess:efficaciousOn ?xcd ;
		?v ?o .
}
USING <http://data.ga-group.nl/bps/>
WHERE {
	?s a fibo-fip:TradingSession ;
		fibo-fip:isTradingSessionOf ?c ;
		skos:exactMatch ?xs ;
		?v ?o .
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc .

	FILTER(STRSTARTS(STRAFTER(STR(?xs),STR(sess:)),STRAFTER(STR(?xc),STR(cata:))))
	FILTER(?v != fibo-fip:isTradingSessionOf)
	FILTER(?v != skos:exactMatch)
	FILTER(?v != skos:closeMatch)

	BIND(EXISTS {
		?xs rdfs:label ?lbl
	} AS ?lblp)
	FILTER(!?lblp || ?v != rdfs:label)

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Full')) AS ?xcd)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/sessions/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;
