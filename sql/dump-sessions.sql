changequote()changequote([,])
DB.DBA.XML_SET_NS_DECL('rdfs', 'http://www.w3.org/2000/01/rdf-schema#', 3);
DB.DBA.XML_SET_NS_DECL('figi-gii', 'http://www.omg.org/spec/FIGI/GlobalInstrumentIdentifiers/', 3);
DB.DBA.XML_SET_NS_DECL('figi-ps', 'http://www.omg.org/spec/FIGI/PricingSources/', 3);
DB.DBA.XML_SET_NS_DECL('fibo-loc', 'https://spec.edmcouncil.org/fibo/ontology/FND/Places/Locations/', 3);
DB.DBA.XML_SET_NS_DECL('fibo-fip', 'https://spec.edmcouncil.org/fibo/ontology/FBC/FinancialInstruments/InstrumentPricing/', 3);
DB.DBA.XML_SET_NS_DECL('fibo-fd', 'https://spec.edmcouncil.org/fibo/ontology/FND/DatesAndTimes/FinancialDates/', 3);
DB.DBA.XML_SET_NS_DECL('fibo-mic', 'https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/MarketsIndividuals/', 3);
DB.DBA.XML_SET_NS_DECL('fibo-fpas', 'https://spec.edmcouncil.org/fibo/ontology/FBC/ProductsAndServices/FinancialProductsAndServices/', 3);
DB.DBA.XML_SET_NS_DECL('cmns-cls', 'https://www.omg.org/spec/Commons/Classifiers/', 3);
DB.DBA.XML_SET_NS_DECL('tempo', 'http://purl.org/tempo/', 3);
DB.DBA.XML_SET_NS_DECL('cc', 'https://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes-Adjunct/', 3);
DB.DBA.XML_SET_NS_DECL('cfi', 'http://schema.ga-group.nl/meta/classification/CFI/', 3);
DB.DBA.XML_SET_NS_DECL('dct', 'http://purl.org/dc/terms/', 3);
DB.DBA.XML_SET_NS_DECL('gr', 'http://purl.org/goodrelations/v1#', 3);
DB.DBA.XML_SET_NS_DECL('gas', 'http://schema.ga-group.nl/symbology#', 3);
DB.DBA.XML_SET_NS_DECL('mic', 'http://fadyart.com/markets#', 3);
DB.DBA.XML_SET_NS_DECL('time', 'http://www.w3.org/2006/time#', 3);
DB.DBA.XML_SET_NS_DECL('dbr', 'http://dbpedia.org/resource/', 3);
DB.DBA.XML_SET_NS_DECL('wd', 'http://www.wikidata.org/entity/', 3);
DB.DBA.XML_SET_NS_DECL('skos', 'http://www.w3.org/2004/02/skos/core#', 3);
DB.DBA.XML_SET_NS_DECL('bps', 'http://bsym.bloomberg.com/pricing_source/', 3);
DB.DBA.XML_SET_NS_DECL('cata', 'http://data.ga-group.nl/catasess/catalogues/', 1);
DB.DBA.XML_SET_NS_DECL('sess', 'http://data.ga-group.nl/catasess/sessions/', 1);
DB.DBA.XML_SET_NS_DECL('regm', 'http://data.ga-group.nl/catasess/regimes/', 1);
DB.DBA.XML_SET_NS_DECL('cdr', 'http://ga.local/cdr#', 1);
DB.DBA.XML_SET_NS_DECL('intr', 'http://ga.local/intr#', 3);
DB.DBA.XML_SET_NS_DECL('ccy', 'http://ga.local/ccy#', 3);
DB.DBA.XML_SET_NS_DECL('delta', 'http://www.w3.org/2004/delta#', 3);
DB.DBA.XML_SET_NS_DECL('pav', 'http://purl.org/pav/', 3);
DB.DBA.XML_SET_NS_DECL('prov', 'http://www.w3.org/ns/prov#', 3);
DB.DBA.XML_SET_NS_DECL('sh', 'http://www.w3.org/ns/shacl#', 3);
DB.DBA.XML_SET_NS_DECL('', 'http://ga.local/bps#', 1);

include(/data/data-source/bbstk/sql/dump-generic.sql)
CREATE DUMP_PROCEDURE(dump_sessions,
SPARQL
DEFINE input:storage ""
PREFIX fibo-fpas: <https://spec.edmcouncil.org/fibo/ontology/FBC/ProductsAndServices/FinancialProductsAndServices/>
PREFIX delta: <http://www.w3.org/2004/delta#>
SELECT ?s ?p ?o
FROM <http://data.ga-group.nl/catasess/sessions/>
WHERE {
	?s a fibo-fip:TradingSession ; ?p ?o
}
);

dump_sessions('/var/scratch/lakshmi/freundt/sessions.ttl');
CHECKPOINT;
