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


designated:relation_key("accidents", "accident_id").

designated:relation_key("transport", "osm_id").

designated:relation_key("traffic", "osm_id").

designated:relation_key("pofw", "osm_id").

designated:relation_key("pois", "osm_id").

designated:relation_key("railways", "osm_id").

designated:relation_key("roads", "osm_id").

designated:relation_key("buildings", "osm_id").

:- designated:initialize_db_connection("C:/Users/Tobias/AppData/Roaming/ESRI/Desktop10.8/ArcCatalog/geolog.sde", run).
