SET BLOBS ON;
SPARQL
DEFINE output:format 'TTL'
PREFIX void: <http://rdfs.org/ns/void#>
prefix afn: <http://jena.hpl.hp.com/arq/function#>
prefix fn:  <http://www.w3.org/2005/xpath-functions#>
PREFIX ov:  <http://open.vocab.org/terms/>

WITH <$u{GRAPH}>
CONSTRUCT {
	?dataset a void:Dataset ;
		void:propertyPartition ?part .
	?part void:property ?p ;
		void:triples ?triples ;
		void:distinctSubjects ?subjects ;
		void:distinctObjects ?objects .
}
WHERE {
	BIND(<$u{GRAPH}Dataset> AS ?dataset)
	{
	SELECT (COUNT(*) AS ?triples) (COUNT(DISTINCT ?s) AS ?subjects) (COUNT(DISTINCT ?o) AS ?objects) ?p
	WHERE {
		?s ?p ?o .
	}
	GROUP BY ?p
	}
	BIND(IRI(CONCAT('urn:sha1:',SHA1(CONCAT("$u{GRAPH}",STR(?p))))) AS ?part)
}
;
