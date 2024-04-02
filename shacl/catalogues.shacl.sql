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
cata:cons-unused-catalogue.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "catalogue not referenced in any trading session nor trading day" ;
		sh:resultSeverity sh:Warning ;
		sh:sourceShape cata:cons-unused-catalogue ;
	] .
}
FROM cata:
FROM sess:
FROM day:
WHERE {
	?this a	fibo-fpas:FinancialProductCatalog .
	FILTER NOT EXISTS {
		?that a fibo-fip:TradingDay ;
			day:isTradingDayOf ?this .
	}
	FILTER NOT EXISTS {
		?that a fibo-fip:TradingSession ;
			sess:isTradingSessionOf ?this .
	}
}
LIMIT 10000
;
