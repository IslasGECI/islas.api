# islas

**One island, one answer.**

Island geography is usually scattered. A coastline lives in one file, an area
in a spreadsheet, and the same number is recomputed a third time in a script.
Two reports about the same islet can disagree about how big it is, or about
which polygon is even meant.

`islas` removes that disagreement. An island becomes a single record with one
name, one location code, and one set of measurements, so every script and
every report asks the same question and gets the same answer.

## What an island is

An island is the land: a set of islets.

Everything measurable — area, perimeter, extent, centre, outline — is measured
from that land and from nothing else. A reference polygon may accompany an
island to say which coastline belongs to it, but it never enters a measurement.
The size of Guadalupe is the size of Guadalupe, not the size of the box drawn
around it.

## Where an island is

Each islet carries a geohash: a short code that places it on a grid. Codes
nest. A coarse code covers a wide cell; a finer code covers a small cell inside
it. So a code can be read at a glance as "somewhere in this part of the Gulf"
or as "this rock", and two codes that begin the same way lie in the same
coarser cell.

## What you can ask

- How big is this island, and where is it?
- Which islet lies under this coordinate?
- Are these two records the same island? Is one contained in the other?
- What happens when the islets of two islands are combined, or when one
  island's islets are removed from another's?

## What it does not do

- **Elevation and terrain.** The interface describes the outline of the land,
  not its height.
- **Projections and zone choices.** Coordinates are geographic and distances
  are measured on the Earth, not on a flat map, so nobody has to pick a zone.
- **Drawing.** Maps belong to the tools that read the records, not to the
  records.
- **File conventions.** Reading shapefiles, spreadsheets, or downloads is the
  step before import, and belongs to the caller.

## Who it is for

Biologists and analysts who write about islands, and the programmers who
prepare the data behind their reports.

## The interface

The types and operations are listed in [DOCS.md](DOCS.md). They are defined
independently of any programming language, so the same names and the same
contracts apply wherever they are used.
