log_enable(3,1);
SET u{GRAPH} http://data.ga-group.nl/catasess/regimes/;
SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/catasess/regimes.ttl';
ld_add('/home/freundt/author/catasess/regimes.ttl', '$u{GRAPH}');
rdf_loader_run();
CHECKPOINT;

LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
