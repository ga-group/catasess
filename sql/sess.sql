PREFIX fibo-fd: <https://spec.edmcouncil.org/fibo/ontology/FND/DatesAndTimes/FinancialDates/>
PREFIX fibo-fip: <https://spec.edmcouncil.org/fibo/ontology/FBC/FinancialInstruments/InstrumentPricing/>
PREFIX fibo-fpas: <https://spec.edmcouncil.org/fibo/ontology/FBC/ProductsAndServices/FinancialProductsAndServices/>
PREFIX cata: <http://data.ga-group.nl/catasess/Catalogues/>
PREFIX sess: <http://data.ga-group.nl/catasess/TradingSessions/>

SELECT ?sess ?exch ?tikr ?from ?till
WHERE {
	?s a fibo-fip:TradingSession ;
		sess:isTradingSessionFor ?c ;
		fibo-fd:hasOpeningDateTime ?from ;
		fibo-fd:hasClosingDateTime ?till .
	?c a fibo-fpas:FinancialProductCatalog ;
		cata:supporting-exch ?exch ;
		cata:supporting-ticker ?tikr .
	BIND(STRAFTER(STR(?s), STR(sess:)) AS ?sess)
}
