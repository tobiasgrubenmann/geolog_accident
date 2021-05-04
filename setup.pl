:- module(setup, [near_radius/1, between_tolerance/1, db_connection/1, db_connection_path/1]).

:- use_module(designated).

:- dynamic db_connection/1.
:- dynamic db_connection_path/1.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Setup
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Author: Tobias Grubenmann
	% Email: grubenmann@cs.uni-bonn.de
	% Copyright: (C) 2020 Tobias Grubenmann
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

near_radius(100).
close_radius(10).
between_tolerance(5).



designated:designated_relation("accidents").
designated:relation_key("accidents", "accident_id").

designated:designated_relation("transport").
designated:relation_key("transport", "osm_id").

designated:designated_relation("traffic").
designated:relation_key("traffic", "osm_id").

designated:designated_relation("pofw").
designated:relation_key("pofw", "osm_id").

designated:designated_relation("pois").
designated:relation_key("pois", "osm_id").

designated:designated_relation("railways").
designated:relation_key("railways", "osm_id").

designated:designated_relation("roads").
designated:relation_key("roads", "osm_id").

designated:designated_relation("buildings").
designated:relation_key("buildings", "osm_id").

?- start_geolog('C:/Users/Tobias/AppData/Roaming/ESRI/Desktop10.8/ArcCatalog/geolog.sde').
