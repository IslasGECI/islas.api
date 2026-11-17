# islas — Interface Reference

`islas` describes island geography as a set: an island is the land it is made
of, and that land is a set of islets. This document lists the types and
operations of the interface and the contract each one honours. The names and
shapes below are what an implementation exposes; the definitions are
independent of any programming language.

## Conventions

- **Coordinates.** Longitude and latitude in degrees, WGS84, as defined by
  RFC 7946. Longitude increases east, latitude increases north. No other
  coordinate reference system is accepted.
- **Measurements.** Areas are geodesic square metres on the WGS84 ellipsoid;
  perimeters are geodesic metres. There are no unit parameters: hectares and
  square kilometres are conversions the caller performs (10,000 m² = 1 ha).
- **Aggregation.** Every measurement accepts an island or an islet. Given an
  island, it is computed from that island's islets only; the margin never
  contributes to a measurement.
- **Emptiness.** `null` means absent. An operation that has no value to return
  returns `null`; it does not raise an error.
- **Antimeridian.** The interface does not define behaviour for geometry that
  crosses the antimeridian.
- **Purity.** Every operation is deterministic. Only `import_islands` and
  `export_islands` touch the disk.

## Types

### `polygon`

A region bounded by one exterior ring and zero or more interior rings (holes).

- A ring is a closed list of `point` values: at least four points, the first
  equal to the last.
- Rings do not self-intersect, holes lie inside the exterior ring, and holes do
  not overlap each other.
- Two polygons are equal when they enclose the same region, with ring
  direction, starting point, and repeated consecutive points normalised first.
  Comparison is exact: no coordinate tolerance is applied.

### `point`

| Field | Type   | Meaning                       |
| ----- | ------ | ----------------------------- |
| `lon` | number | Longitude in degrees, east.   |
| `lat` | number | Latitude in degrees, north.   |

### `bbox`

| Field     | Type   | Meaning                     |
| --------- | ------ | --------------------------- |
| `lon_min` | number | Westernmost longitude.      |
| `lat_min` | number | Southernmost latitude.      |
| `lon_max` | number | Easternmost longitude.      |
| `lat_max` | number | Northernmost latitude.      |

### `islet`

One landmass: an element of an island.

| Field      | Type      | Notes                        |
| ---------- | --------- | ---------------------------- |
| `geometry` | `polygon` | The land of this landmass.   |

The geohash is not a stored field. It is derived from the geometry by
`compute_geohash`, so it cannot go stale.

### `island`

A named record of land.

| Field    | Type             | Notes                              |
| -------- | ---------------- | ---------------------------------- |
| `id`     | string or `null` | Stable key; see below.             |
| `name`   | string or `null` | Human-readable name.               |
| `margin` | `polygon` or `null` | Reference polygon; metadata.   |
| `islets` | list of `islet`   | The land; the set's elements.      |

- `id` is a slug: lowercase ASCII letters, digits, and interior hyphens
  (`^[a-z0-9]+(-[a-z0-9]+)*$`). It is the key callers use to refer to an
  island.
- `margin` states which land belongs to the island and supplies nothing else.
  It may be present on an imported island and is always `null` on an island
  returned by `compute_union` or `compute_difference`.
- An island returned by a set operation has `id` and `name` set to `null`.
  Assigning an identity to a derived island is the caller's action.

## Import and export

### `import_islands(path)`

Reads a GeoJSON FeatureCollection and returns the islands it describes.

- **Parameters:** `path` — string, path to a file.
- **Returns:** list of `island`, ordered by the first appearance of each `id`.
- **Format:** every feature has a `Polygon` geometry and three properties:
  - `id` — island slug; features with the same `id` belong to the same island.
  - `name` — island name, the same for every feature of one island.
  - `part` — `"islet"` or `"margin"`.
- **Errors:** unreadable file; not a FeatureCollection; a geometry that is not
  a `Polygon`; a missing or invalid `id`, `name`, or `part`; a `name` that
  differs between features of one island; zero or more than one `margin`
  feature for an island; an island with no `islet` feature; a `crs` member.
- **Notes:** islet order is the order of the file. Duplicate islets are kept,
  not merged. No reprojection is performed.

### `export_islands(islands, path)`

Writes islands as a GeoJSON FeatureCollection readable by `import_islands`.

- **Parameters:** `islands` — list of `island`; `path` — string, destination.
- **Returns:** `null`; writes the file.
- **Errors:** an island with a `null` `id` or `name`; an island with no
  islets; an unwritable path; an invalid polygon.
- **Notes:** one feature per islet and one per margin, with the properties
  defined by `import_islands`. Round-tripping preserves `id`, `name`, the
  islets, and the margin.

## Measurement

### `compute_area(x)`

Geodesic area of the land.

- **Parameters:** `x` — `island` or `islet`.
- **Returns:** number, square metres.
- **Notes:** for an islet, the exterior ring's area minus its holes. For an
  island, the sum over its islets. Overlapping islets are not merged, so an
  island can report more than the area of the union of its land.

### `compute_perimeter(x)`

Geodesic length of the coastline.

- **Parameters:** `x` — `island` or `islet`.
- **Returns:** number, metres.
- **Notes:** for an islet, the exterior ring plus its holes. For an island, the
  sum over its islets.

### `compute_bbox(x)`

The smallest axis-aligned box that contains the land.

- **Parameters:** `x` — `island` or `islet`.
- **Returns:** `bbox` or `null` when there are no islets.
- **Notes:** computed from islet vertices only; the margin is excluded.

### `compute_centroid(x)`

The representative point of the land.

- **Parameters:** `x` — `island` or `islet`.
- **Returns:** `point` or `null` when there are no islets.
- **Notes:** the area-weighted mean of the islet centroids, computed in
  longitude and latitude. It is a planar approximation intended for labelling
  and ordering, not a geodesic centre.

### `compute_hull(x)`

The convex hull of the land.

- **Parameters:** `x` — `island` or `islet`.
- **Returns:** `polygon` or `null` when there are no islets.
- **Notes:** the convex hull of all islet vertices in longitude and latitude;
  one exterior ring, no holes.

### `compute_geohash(x)`

The location code of the land.

- **Parameters:** `x` — `island` or `islet`.
- **Returns:** string or `null` when there are no islets.
- **Notes:** the standard geohash alphabet, lowercase
  (`0123456789bcdefghjkmnpqrstuvwxyz`). The result is the shortest geohash
  whose decoded cell midpoint lies inside the land — inside an islet, or on
  its boundary. Precision is tried from 1 upward and stops at 12; if no
  midpoint qualifies, the 12-character geohash of the midpoint of
  `compute_centroid` is returned. Length is a scale, not a rank: each extra
  character shrinks the cell by a factor of 32 in area. Keys nest — when one
  key is a prefix of another, the second cell lies inside the first — but that
  relation belongs to the grid, not to the islands.

## Lookup

### `find_islet(island, lon, lat)`

Finds the islet that contains a coordinate.

- **Parameters:** `island` — `island`; `lon` — number, degrees; `lat` —
  number, degrees.
- **Returns:** `islet` or `null` when no islet contains the point.
- **Notes:** the first islet, in island order, whose polygon contains the
  point; a point on a boundary counts as inside. The lookup uses geometry and
  does not decode a geohash.
- **Errors:** `lon` outside −180 to 180, or `lat` outside −90 to 90.

## Set operations

An island's islets are a set: order does not matter and repeated islets do not
exist, which is what `is_equal` and `is_subset` compare.

### `compute_union(a, b)`

- **Parameters:** `a`, `b` — `island`.
- **Returns:** `island` with `null` `id`, `name`, and `margin`, whose islets are
  the islets of `a` followed by the islets of `b` that are not already present.
- **Notes:** a set union, not a geometric clip. Two islets that overlap but are
  not equal are both kept.

### `compute_difference(a, b)`

- **Parameters:** `a`, `b` — `island`.
- **Returns:** `island` with `null` `id`, `name`, and `margin`, whose islets are
  the islets of `a` that are not equal to any islet of `b`.
- **Notes:** a set difference, not a geometric clip. An islet that partially
  overlaps an islet of `b` is kept whole.

### `is_equal(a, b)`

- **Parameters:** `a`, `b` — `island`.
- **Returns:** logical.
- **Notes:** true when the islet sets are in bijection under polygon equality.
  `id`, `name`, `margin`, and order are ignored.

### `is_subset(a, b)`

- **Parameters:** `a`, `b` — `island`.
- **Returns:** logical.
- **Notes:** true when every islet of `a` is equal to some islet of `b`.
