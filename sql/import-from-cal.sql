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
		fibo-fip:isTradingDayOf ?xc ;
		pav:importedOn ?impon ;
		pav:lastRefreshedOn ?refon .
}
USING <http://data.ga-group.nl/bps/>
USING <http://data.ga-group.nl/cal/>
WHERE {
	?c a figi-gii:PricingSource ;
		cata:assigned-catalogue ?xc ;
		gas:cdr-code ?cd .

	## make sure ?cd is the only cdr-code
	OPTIONAL {
	?c gas:cdr-code ?c2
	FILTER(?c2 != ?cd)
	}
	FILTER(!BOUND(?c2))

	?cd cdr:nonTradingDay ?nond .
	OPTIONAL {
	?cd pav:lastRefreshedOn ?refon
	}
	OPTIONAL {
	?cd prov:generatedAtTime ?impon
	}

	BIND(IRI(CONCAT(STR(day:),STRAFTER(STR(?xc),STR(cata:)),'-Non')) AS ?xcn)
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/catasess/days/;
LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
CHECKPOINT;
