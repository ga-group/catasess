SET BLOBS ON;
DB.DBA.XML_SET_NS_DECL('cata', 'http://data.ga-group.nl/catasess/catalogues/', 1);
DB.DBA.XML_SET_NS_DECL('sess', 'http://data.ga-group.nl/catasess/sessions/', 1);
DB.DBA.XML_SET_NS_DECL('day', 'http://data.ga-group.nl/catasess/days/', 1);

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>

CONSTRUCT {
cata:cons-no-sessions.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "catalogue not referenced in any trading session" ;
		sh:resultSeverity sh:Warning ;
		sh:sourceShape cata:cons-no-sessions ;
	] .
}
FROM cata:
FROM sess:
FROM day:
WHERE {
	?this a	fibo-fpas:FinancialProductCatalog .
	OPTIONAL {
		?that fibo-fip:isTradingSessionOf ?this .
	}
	FILTER(!BOUND(?that))
}
LIMIT 10000
;

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>

CONSTRUCT {
cata:cons-no-days.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "catalogue not referenced in any trading day" ;
		sh:resultSeverity sh:Warning ;
		sh:sourceShape cata:cons-no-days ;
	] .
}
FROM cata:
FROM sess:
FROM day:
WHERE {
	?this a	fibo-fpas:FinancialProductCatalog .
	OPTIONAL {
		?that fibo-fip:isTradingDayOf ?this .
	}
	FILTER(!BOUND(?that))
}
LIMIT 10000
;
