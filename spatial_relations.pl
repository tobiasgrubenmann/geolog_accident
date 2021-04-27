:- module(spatial_relations, [near/2, near_relational/4, closeby/2, closeby_relational/4]).

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Spatial Concepts
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Author: Tobias Grubenmann
	% Email: grubenmann@cs.uni-bonn.de
	% Copyright: (C) 2020-2021 Tobias Grubenmann
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
% near(?Input1, ?Input2):
%------------------------------------------------------------------------------
% True if Feature1(Table1, Id1) is near Feature2(Table2, Id2) according to setup:near_radius.

near(Input1, Input2) :-
    setup:near_radius(Radius),
    within_distance(Input1, Input2, Radius).

%------------------------------------------------------------------------------
% near_relational(+Table1, +Table2, -Output):
%------------------------------------------------------------------------------
% Returns as output a table with all pair of IDs that are near each other according to setup:near_radius.

near_relational(Table1, Table2, Output, Fields) :-
    setup:near_radius(Radius),
    within_distance_relational(Table1, Table2, Output, Radius, Fields).

%------------------------------------------------------------------------------
% closeby(?Input1, ?Input2):
%------------------------------------------------------------------------------
% True if Feature1(Table1, Id1) is near Feature2(Table2, Id2) according to setup:close_radius.

closeby(Input1, Input2) :-
    setup:close_radius(Radius),
    within_distance(Input1, Input2, Radius).

%------------------------------------------------------------------------------
% close_table(+Table1, +Table2, -Output):
%------------------------------------------------------------------------------
% Returns as output a table with all pair of IDs that are close each other according to setup:close_radius.

closeby_relational(Table1, Table2, Output, Fields) :-
    setup:close_radius(Radius),
    within_distance_relational(Table1, Table2, Output, Radius, Fields).



