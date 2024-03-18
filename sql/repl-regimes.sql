log_enable(3,1);

SET u{GRAPH} http://data.ga-group.nl/catasess/regimes/;
SET u{STAGE} regm-staging;
SET u{DIFFG} regm-diff;

SPARQL CREATE SILENT GRAPH <$u{STAGE}>;
SPARQL CLEAR GRAPH <$u{STAGE}>;

DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/catasess/regimes.ttl.repl';
ld_add('/home/freundt/author/catasess/regimes.ttl.repl', '$u{STAGE}');
rdf_loader_run();
CHECKPOINT;

LOAD '/data/data-source/bbstk/sql/diff-nodel.sql';
LOAD '/data/data-source/bbstk/sql/unify-delta.sql';
LOAD '/data/data-source/bbstk/sql/fixup-delta.sql';
LOAD '/data/data-source/bbstk/sql/patch.sql';

SPARQL ADD <$u{STAGE}> TO <$u{GRAPH}>;
SPARQL ADD <$u{DIFFG}> TO <$u{GRAPH}>;

LOAD '/data/data-source/bbstk/sql/prov-massage.sql';
