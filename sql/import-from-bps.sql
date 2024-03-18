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
		fibo-rel:isProvidedBy ?fmic .
}
USING <http://data.ga-group.nl/bps/>
WHERE {
	?c a figi-gii:PricingSource ;
		gas:MIC ?mic ;
		gas:traded-product ?p .
	OPTIONAL {
	?c gas:assigned-lmic ?lmic
	}
	BIND(COALESCE(?lmic,?mic) AS ?xmic)
	BIND(IRI(CONCAT(STR(cata:),STRAFTER(STR(?xmic),STR(mic:)),'-',STRAFTER(STR(?p),STR(cfi:)))) AS ?xc)
	BIND(IRI(CONCAT(STR(fibo-mic:),'Exchange-',STRAFTER(STR(?xmic),STR(mic:)))) AS ?fmic)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/sessions/;
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
		?v ?o .
}
USING <http://data.ga-group.nl/bps/>
WHERE {
	?s a fibo-fip:TradingSession ;
		fibo-fip:isTradingSessionOf ?c ;
		?v ?o .
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc .

	FILTER(?v != fibo-fip:isTradingSessionOf)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/sessions/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;
