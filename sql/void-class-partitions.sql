SET BLOBS ON;
SPARQL
DEFINE output:format 'TTL'
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX afn: <http://jena.hpl.hp.com/arq/function#>
PREFIX fn:  <http://www.w3.org/2005/xpath-functions#>
PREFIX ov:  <http://open.vocab.org/terms/>

WITH <$u{GRAPH}>
CONSTRUCT {
	?dataset a void:Dataset ;
		void:classPartition ?part .
	?part void:class ?type ;
		void:entities ?instances .
}
WHERE {
	BIND(<$u{GRAPH}Dataset> AS ?dataset)
	{
	SELECT (COUNT(DISTINCT ?instance) AS ?instances) ?type
	WHERE {
		?instance a ?type
		FILTER (isURI(?type))
	}
	GROUP BY ?type
	}
	BIND(IRI(CONCAT('urn:sha1:',SHA1(CONCAT("$u{GRAPH}",STR(?type))))) AS ?part)
	FILTER(?instances > 0)
}
;
