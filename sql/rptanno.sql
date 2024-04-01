PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX : <http://ga.local/stk#>

CONSTRUCT {
	?fn sh:violated-shape ?sch
}
WHERE {
	?x a sh:ValidationResult ;
		sh:resultSeverity sh:Violation ;
		sh:focusNode ?fn ;
		sh:sourceShape ?sh .
	OPTIONAL {
		?r sh:sourceConstraint ?sc
	}
	BIND(COALESCE(?sc, ?sh) AS ?sch)
}
