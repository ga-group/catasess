SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>

WITH <http://data.ga-group.nl/catasess/days/>
INSERT {
	?xd day:activeSession ?xs .
}
USING <http://data.ga-group.nl/catasess/sessions/>
WHERE {
	?xs sess:efficaciousOn ?xd .
	?xd a fibo-fip:TradingDay .
	FILTER NOT EXISTS {
	?xd day:activeSession ?xs .
	}
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;

SPARQL
DEFINE sql:log-enable 3
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>

WITH <http://data.ga-group.nl/catasess/sessions/>
INSERT {
	?xs sess:efficaciousOn ?xd .
}
USING <http://data.ga-group.nl/catasess/days/>
WHERE {
	?xd day:activeSession ?xs .
	?xs a fibo-fip:TradingSession .
	FILTER NOT EXISTS {
	?xs sess:efficaciousOn ?xd .
	}
}
;
ECHO $ROWCNT "\n";
CHECKPOINT;
