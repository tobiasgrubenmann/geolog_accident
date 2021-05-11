:- module(setup, [near_radius/1, close_radius/1, between_tolerance/1]).

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

geolog_sql:relation_key("accidents", "accident_id").
geolog_sql:relation_key("transport", "osm_id").
geolog_sql:relation_key("traffic", "osm_id").
geolog_sql:relation_key("pofw", "osm_id").
geolog_sql:relation_key("pois", "osm_id").
geolog_sql:relation_key("railways", "osm_id").
geolog_sql:relation_key("roads", "osm_id").
geolog_sql:relation_key("buildings", "osm_id").

:- geolog_sql:initialize_db_connection("C:/Users/Tobias/AppData/Roaming/ESRI/Desktop10.8/ArcCatalog/geolog.sde", run).
%:- start_geolog('C:/Users/Tobias/AppData/Roaming/ESRI/Desktop10.8/ArcCatalog/geolog.sde').
