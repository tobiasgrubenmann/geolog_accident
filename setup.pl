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



designated:designated_name("accidents").
designated:designated_id("accidents", "accident_id").

designated:designated_name("transport").
designated:designated_id("transport", "osm_id").

designated:designated_name("traffic").
designated:designated_id("traffic", "osm_id").

designated:designated_name("pofw").
designated:designated_id("pofw", "osm_id").

designated:designated_name("pois").
designated:designated_id("pois", "osm_id").

designated:designated_name("railways").
designated:designated_id("railways", "osm_id").

designated:designated_name("roads").
designated:designated_id("roads", "osm_id").

designated:designated_name("buildings").
designated:designated_id("buildings", "osm_id").

?- start_geolog('C:/Users/Tobias/AppData/Roaming/ESRI/Desktop10.8/ArcCatalog/geolog.sde').
