SET BLOBS ON;
DB.DBA.XML_SET_NS_DECL('sess', 'http://data.ga-group.nl/catasess/sessions/', 1);
DB.DBA.XML_SET_NS_DECL('day', 'http://data.ga-group.nl/catasess/days/', 1);

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX day: <http://data.ga-group.nl/catasess/days/>

CONSTRUCT {
day:neverCoincidesWith-property.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "neverCoincidesWith is irreflexive" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceShape day:neverCoincidesWith-property ;
	] .
}
FROM <http://data.ga-group.nl/catasess/days/>
WHERE {
	?this a	fibo-fip:TradingDay ;
		day:neverCoincidesWith ?this .
}
LIMIT 10000
;

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX day: <http://data.ga-group.nl/catasess/days/>

CONSTRUCT {
day:cons-neverCoincidesWith.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "trading days in neverCoincidesWith must not have coinciding day:observedOn values" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceShape sess:cons-neverCoincidesWith ;
		sh:conflicting-peer ?that ;
		sh:value ?value
	] .
}
FROM <http://data.ga-group.nl/catasess/days/>
WHERE {
	?this a fibo-fip:TradingDay ;
		day:neverCoincidesWith ?that ;
		day:observedOn ?value .
	?that day:observedOn ?value .
}
LIMIT 10000
;
