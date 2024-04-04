SET BLOBS ON;
SPARQL
DEFINE output:format 'TTL'
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX my: <java:ie.deri.linkeddata.arqext.>
PREFIX fn: <http://www.w3.org/2005/xpath-functions#>
PREFIX afn: <http://jena.hpl.hp.com/ARQ/function#>

WITH <$u{GRAPH}>
CONSTRUCT {
	?dataset a void:Dataset;
		void:vocabulary ?vocabulary .
}
WHERE {
	BIND(<$u{GRAPH}Dataset> AS ?dataset)
	{
	SELECT IRI(bif:REGEXP_SUBSTR('^.+[/#]', STR(?term), 0)) AS ?vocabulary
	WHERE {
		{
		SELECT DISTINCT ?term
		WHERE {
			?s ?term ?o
		}
		} UNION {
		SELECT DISTINCT ?term
		WHERE {
			?s a ?term
		}
		}
	}
	}
}
;
