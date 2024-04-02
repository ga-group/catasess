SET BLOBS ON;
DB.DBA.XML_SET_NS_DECL('sess', 'http://data.ga-group.nl/catasess/sessions/', 1);
DB.DBA.XML_SET_NS_DECL('day', 'http://data.ga-group.nl/catasess/days/', 1);

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>

CONSTRUCT {
sess:cons-unused-session.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "session not active in any trading day" ;
		sh:resultSeverity sh:Warning ;
		sh:sourceShape sess:cons-unused-session ;
	] .
}
FROM <http://data.ga-group.nl/catasess/sessions/>
FROM <http://data.ga-group.nl/catasess/days/>
WHERE {
	?this a	fibo-fip:TradingSession .
	FILTER NOT EXISTS {
		?that a fibo-fip:TradingDay ;
			day:activeSession ?this .
	}
}
LIMIT 10000
;

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>

CONSTRUCT {
sess:cons-contradictory-catalogues.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "session bound to day via day:activeSession but they refer to different catalogues" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceShape sess:cons-contradictory-catalogues ;
		sh:value ?that
	] .
}
FROM <http://data.ga-group.nl/catasess/sessions/>
FROM <http://data.ga-group.nl/catasess/days/>
WHERE {
	?that a fibo-fip:TradingDay ;
		fibo-fip:isTradingDayOf ?thatc ;
		day:activeSession ?this .
	FILTER(?this != sess:None)
	FILTER NOT EXISTS {
	?this fibo-fip:isTradingSessionOf ?thatc .
	}
}
LIMIT 10000
;
## and the converse
SPARQL
DEFINE output:format "NICE_TTL"
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>

CONSTRUCT {
sess:cons-contradictory-catalogues.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "session bound to day via day:activeSession but they refer to different catalogues" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceShape sess:cons-contradictory-catalogues ;
		sh:value ?that
	] .
}
FROM <http://data.ga-group.nl/catasess/sessions/>
FROM <http://data.ga-group.nl/catasess/days/>
WHERE {
	?this a fibo-fip:TradingSession ;
		fibo-fip:isTradingSessionOf ?thisc .
	?that	day:activeSession ?this .
	FILTER NOT EXISTS {
	?that fibo-fip:isTradingDayOf ?thisc .
	}
}
LIMIT 10000
;
