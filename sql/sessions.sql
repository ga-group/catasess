SPARQL
PREFIX cata: <http://data.ga-group.nl/catasess/catalogues/>
PREFIX day: <http://data.ga-group.nl/catasess/days/>
PREFIX sess: <http://data.ga-group.nl/catasess/sessions/>
SELECT	DISTINCT ?cata ?day ?sess
FROM cata:
FROM day:
FROM sess:
WHERE {
	OPTIONAL {
	?cata a fibo-fpas:FinancialProductCatalog .
	}
	OPTIONAL {
	?day a fibo-fip:TradingDay ;
		fibo-fip:isTradingDayOf ?cata
	}
	OPTIONAL {
	?sess a fibo-fip:TradingSession ;
		fibo-fip:isTradingSessionOf ?cata .
		OPTIONAL {
		?sess sess:efficaciousOn ?sday
		}
		FILTER(!BOUND(?sday) || ?sday = ?day)
	}
}
ORDER BY ?cata ?day ?sess
;
