[![License: CC BY SA 4.0](https://img.shields.io/badge/License-CC_BY_SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

catasess (catalogues+sessions)
==============================

An industry dataset that relates exchanges and segments of exchanges,
identified by their MIC, to product groups listed in these segments (catalogues).

The aim is to capture trading days and trading sessions which often vary by
asset class, or product group, as well as over time.


Why?
----

Most trading hour data services are too coarse to be useful.
Some will provide core trading hours, the time when the most important
instrument are in continuous trading.
Others will only provide the current set of trading sessions with no
indication when this schedule became effective.


How?
----

Data is taken from primary sources (exchange rulebooks, or circulars).

An operational segment of the exchange is identified, either by using
its dedicated MIC (as published by ISO 10383), or by using an ISO 10962
code.  If the same class of instruments adheres to different schedules
the exchange's identifier for the product group will be used.


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
