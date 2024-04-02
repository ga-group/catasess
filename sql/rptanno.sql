PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX : <http://ga.local/stk#>

CONSTRUCT {
	?fn ?p ?sch .
}
WHERE {
	VALUES (?sev ?p) {
	(sh:Violation sh:violated-shape)
	(sh:Warning sh:warned-shape)
	}
	?x a sh:ValidationResult ;
		sh:resultSeverity ?sev ;
		sh:focusNode ?fn ;
		sh:sourceShape ?sh .
	OPTIONAL {
		?x sh:sourceConstraint ?sc
	}
	BIND(COALESCE(?sc, ?sh) AS ?sch)
}
