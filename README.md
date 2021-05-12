# Accident Analysis using Geolog

## Setup

1. Open ArcMap with GEolog Plugin installed.
2. Change `setup.pl` to point to db connection file (*.sde)
3. Change `designated:relation_key("table_name", "id_field")` in `setup.pl` such that they correspond to the database tables.
4. Consult `setup.pl` amd `spatial_relations.pl`.

## Usage

The following predicates are provided:

* `near(?Entity2, ?Entity2)`: True if `Entity1` is near `Entity2` according to `setup:near_radius`.
* `near_relational(+Relation1, +Relation2, -Output)`: Returns as output a relation with all pair of IDs that are near each other according to `setup:near_radius`.
* `closeby(?Entity1, ?Entity2)`: True if `Entity1` is close to `Entity2` according to `setup:close_radius`.
* `close_table(+Relation1, +Relation2, -Output)`: Returns as output a relation with all pair of IDs that are close each other according to `setup:close_radius`.

## Example

The following query asks about accidents near crossings:

    :- near(("accidents", AccidentID), ("traffic", TrafficID)), entity_type(crossing_features, ("traffic", TrafficID)).