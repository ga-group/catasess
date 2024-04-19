[![License: CC BY SA 4.0](https://img.shields.io/badge/License-CC_BY_SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

catasess (catalogues+sessions)
==============================

An industry dataset that relates exchanges and segments of exchanges,
identified by their MIC, to product groups listed in these segments (catalogues).

The aim is to capture trading days and trading sessions which often vary by
asset class, or product group, as well as over time.  Ultimately, assigning
a catalogue to a financial instrument would explain all trading days, and
effective sessions during the entire lifetime of the instrument.


Why?
----

Most trading hour data services are too coarse to be useful.
Some will provide core trading hours, the time when the most important
instrument are in continuous trading.
Others will only provide the current set of trading sessions with no
indication when this schedule became effective.
And the ones that do provide per-instrument session hours will do so
without a session identifier that allows product grouping.


How?
----

Data is taken from primary sources (exchange rulebooks, or circulars).

An operational segment of the exchange is identified, either by using
its dedicated MIC (as published by ISO 10383), or by using an ISO 10962
code.  If the same class of instruments adheres to different schedules
the exchange's identifier for the product group will be used.

For each such product group trading sessions are identified, and their
trading hours are recorded.

At the same time, non-trading days or half trading days (early closes
or late openings) are tracked.


Where?
------

The [github repository](https://github.com/ga-group/catasess/)
contains the published datasets as well as separately maintained
alignment and enrichment files.

For ease of access the latest versions of the datasets can be
downloaded here:

- [catalogues.ttl](catalogues.ttl) trading catalogues
- [days.ttl](days.ttl) trading days
- [sessions.ttl](sessions.ttl) trading sessions


Notes
-----

MICs were introducted by ISO 10383:1992 in October 1992, with drafts
dating back as far as August 1987.  Which gives an older bound for
the start of tracking of circa 1990.  In exceptional cases, exchanges
with a long-standing tradition are tracked using proleptic MICs.
This will introduce a selection bias.
