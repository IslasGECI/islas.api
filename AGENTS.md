# AGENTS.md — islas

Language-neutral interface specification for island geography.

**This repository contains a specification, not an implementation.** There is
no code, no build, no test command, and no dependency to install. `DOCS.md` is
the source of truth; where anything else disagrees with it, `DOCS.md` wins.

## Files

| File | Purpose |
| --- | --- |
| `README.md` | Overview for non-technical readers: the problem, the two ideas, and what the interface does not cover. |
| `DOCS.md` | The interface reference: types, operations, and contracts. |
| `MATLAB/` | The legacy MATLAB toolbox this specification was recovered from, with its original notes in `MATLAB/README.md`. Read for lineage, not as a source of truth. |

`CHANGELOG.md` and `TODO.md` are absent by design: nothing here is released,
and the work that remains belongs to the repository that implements the
interface.

## Public interface

The public interface is the set of types and operations in `DOCS.md`: the
`island` and `islet` records and the operations that import, export, measure,
look up, combine, and compare them. Nothing outside `DOCS.md` is part of the
interface, and no other file may list its elements.

## Scope

In scope: identity (slug and geohash), measurement on the WGS84 ellipsoid,
point lookup, set operations over islets, and GeoJSON interchange.

Out of scope, deliberately:

- **Elevation.** The legacy toolbox carried SRTM tiles and a map type. Terrain
  is a separate dataset, not part of an island's outline.
- **Plotting.** Rendering belongs to the tools that read the records.
- **Projections and grid accessors.** The legacy `x`/`X`/`utm_zone` accessors
  existed because MATLAB's mapping toolbox needed them. Measurements are
  geodesic instead.
- **The size classification** (`roca`, `islote`, `isla chica`, …). It was a
  lookup over area, untested, and the only culture-specific vocabulary in an
  otherwise English interface.
- **A `region` type.** Its only role was to be an island's margin; the margin
  is now a polygon field.
- **Shapefile reading and coastline extraction.** Import is GeoJSON only.

## Conventions

- Prose and identifiers are English. Types and fields are `snake_case`;
  operations use the prefixes `compute_`, `is_`, `find_`, `import_`, and
  `export_`.
- Units are fixed by the interface: area in square metres, perimeter in
  metres. There are no unit parameters.
- No worked examples and no numeric outputs. Nothing in this repository can be
  run, so no documented claim may depend on a computed value.
- Files are complementary: the overview explains why, the reference lists what.
  Do not repeat an element in `README.md`.

## Lineage

`MATLAB/` holds the original toolbox: `Island`, `Islet`, and `Region` classes,
a `RegionID` enumeration, an SRTM elevation map, plotting methods, and script
tests. It was written for MATLAB on Windows and versioned with Mercurial.

The specification keeps the two ideas that survived scrutiny — an archipelago
as a set of islets, and a nesting geohash that locates each one — and drops the
rest. Where this specification differs from the toolbox, the difference is
intentional:

- Identity is a stable slug; the geohash is derived, not a key.
- The geohash is the shortest code whose cell midpoint falls inside the land,
  not inside its convex hull.
- Measurements exclude the margin.
- Set operations work on islet sets and never clip geometry.
- Derived islands have no identity and no margin.

## Verifying a change

A change is complete when all of these hold:

1. Every affected operation states parameters, return value, errors, and notes.
2. New or changed elements appear in `DOCS.md` and nowhere else.
3. Claims are checkable from the text: a reader can tell what a value means,
   in which units, and when it is `null`.
4. `README.md` still describes the problem and the ideas without naming an
   element of the interface.
