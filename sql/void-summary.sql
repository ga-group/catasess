SET BLOBS ON;
SPARQL
DEFINE output:format 'TTL'
PREFIX pav: <http://purl.org/pav/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX fn: <http://www.w3.org/2005/xpath-functions#>

WITH <$u{GRAPH}>
CONSTRUCT {
	?dataset a void:Dataset ;
		void:uriSpace ?space ;
		void:triples ?triples ;
		void:entities ?entities ;
		void:classes ?classes ;
		void:properties ?properties ;
		pav:lastRefreshedOn ?now .
}
WHERE {
	BIND(NOW() AS ?now)
	BIND(<$u{GRAPH}Dataset> AS ?dataset)
	{
	SELECT (COUNT(*) AS ?triples) (COUNT(DISTINCT ?p) AS ?properties)
	WHERE {
		?s ?p ?o .
	}
	}
	{
	# We count instantiated classes, and ignore classes that have only
	# been declared.
	# We require classes to have URIs. Anonymous types do not count.
	SELECT (COUNT(DISTINCT ?type) AS ?classes)
	WHERE {
	      [] a ?type .
	      FILTER (isURI(?type))
	}
	}
	{
	# We define entities as any URI occurring in subject position.
	# If a URI space has been specified, then only matching URIs are
	# counted.
	# Other definitions would be possible as well.
	SELECT (COUNT(DISTINCT ?s) AS ?entities)
	WHERE {
	      ?s ?p ?o .
	      FILTER (isURI(?s))
	}
	}
}
;
