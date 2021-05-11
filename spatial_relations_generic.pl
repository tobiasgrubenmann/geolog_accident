:- module(spatial_relations, [near/2, near_relational/4, closeby/2, closeby_relational/4]).

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Spatial Concepts
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Author: Tobias Grubenmann
	% Email: grubenmann@cs.uni-bonn.de
	% Copyright: (C) 2020-2021 Tobias Grubenmann
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ----------------------------------------------------------------------
% TODO: 
%
% 1. Test that the following goals are equivalent: 
%        Query = within_distance((Relation1, Id1), (Relation2, Id2), Radius),
%        geoquery_on_entities(Query, Result) 
%    and 
%        within_distance((Relation1, Id1), (Relation2, Id2), Radius)
%
% 2. Add separate file with templates for intersect((Relation1, Id1), (Relation2, Id2))
%   
% 3. Test that the following goals are equivalent: 
%        Query = intersect((Relation1, Id1), (Relation2, Id2))
%        geoquery_on_entities(Query, Result) 
%    and 
%        intersect((Relation1, Id1), (Relation2, Id2)
%
% 4. Test generic relational queries
% 
% 5. Make postgres:select_where_query/3 generic too and adapt osm_features.pl 
% ----------------------------------------------------------------------


            
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

closeby(Entity1, Entity2) :-
    setup:close_radius(Radius),
    within_distance(Radius, Entity1, Entity2).

%------------------------------------------------------------------------------
% close_table(+Table1, +Table2, -Output):
%------------------------------------------------------------------------------
% Returns as output a table with all pair of IDs that are close each other according to setup:close_radius.

closeby_relational(Relation1, Relation2, ResultRelation, ResultFields) :-
    setup:close_radius(Radius),
	within_distance_relational(Relation1, Relation2, ResultRelation, Radius, ResultFields). 

%==============================================================================
% GIS-based geoqueries
%==============================================================================

%------------------------------------------------------------------------------
%within_distance(+Radius, ?Entity1, ?Entity2 )	
%------------------------------------------------------------------------------
within_distance(Radius, Entity1, Entity2) :-
	Entity1 = (Relation1, KeyValue1),
	Entity2 = (Relation2, KeyValue2),
	geoquery_on_entities( within_distance(Radius),
						  [Relation1, Relation2], 
						  [KeyValue1, KeyValue2]
	).
	 
%------------------------------------------------------------------------------
%within_distance_relational(+Relation1, +Relation2, +ResultRelation, +Radius, +ResultFields)	 
%------------------------------------------------------------------------------
within_distance_relational(Relation1, Relation2, ResultRelation, Radius, [ResultField1, ResultField2]) :-
	geo_query_on_relations( within_distance(Radius),
							[Relation1, Relation2], 
					 		[ResultField1, ResultField2],
							ResultRelation 
	).	


%==============================================================================
% Geoquery invocation predicates	 
%==============================================================================
geo_query_on_entities(Goal,InputRelations,KeyValues) :-
	'geolog_sql.entitylevel':geoquery(Goal,InputRelations,KeyValues).

geo_query_on_relations(Goal,InputRelations,ResultFields,ResultRelation) :-
	'geolog_sql.relational':geoquery(Goal,InputRelations,ResultFields,ResultRelation).


%==============================================================================
% Implementation of SQL WHERE clause of relational geoqueries	 
%==============================================================================
% The geoqueries on relations issued by the invocation predicate above 
% are assembled automatically, except for their WHERE clause, which is
% specific to the respective Goal. This specific part must be supplied
% by the application via geo_operation(Goal, Vars, WhereClauseTemplate)
	
% -------------------------------------------------------------------
% geo_operation(
%	+Goal, 
%	+Relations,  
%	?ResultFields, 
%	?ResultRelation, 
%	+Vars, 
%	?WhereClauseTemplate)
% -------------------------------------------------------------------
% A clause for this predicate must be defined by the application for
% each geo-operation that should be run in relational mode via 
% @see geolog_sql:geoquery_on_relations(+Goal, -ResultRelation). 
% 
% The first four parameters must conform to the specification of 
% @see geolog_sql:geoquery_on_relations/4
%
% Vars must be a list that contains the variables from Goal in the order 
% in which they are referencedthat in WhereClauseTemplate. 
%
% If the clause is constructed properly, the goal 
%    format(atom(Where), WhereClauseTemplate, Vars) 
% will bind Where to the corect WHERE clause for the geographic 
% operation that implements Goal. The rest of the SQL query (that is,
% the "SELECT ... FROM ... WHERE" prefix ) is assembled automatically.
% -------------------------------------------------------------------
:- multifile 'geolog_sql.relational':geo_operation/3 .

'geolog_sql.relational':geo_operation( 
	within_distance(Radius), 
	[Relation1, Relation2],
	_,
	_, 
	[Relation1, Radius, Relation2],                    % <-- values referenced below
    'ST_Intersects(ST_Buffer(~a.shape,~a), ~a.shape)'  % <-- atom with placeholders
	).

'geolog_sql.relational':geo_operation( 
	intersect(_),
	Relations,         
	_,
	_, 
	Relations,                           % <-- values referenced below                            
   'ST_Intersects(~a.shape, ~a.shape)'   % <-- atom with placeholders 
	).		


% -------------------------------------------------------------------
% geolog_sql:query_template(
%   ?Mode,
%	+Goal, 
%	+Relations, 
%	+KeyFields, 
%	?KeyValues, 
%	?SELECT_template, +SELECT_vars,
%	  ?FROM_template,   +FROM_vars,
%	 ?WHERE_template,  +WHERE_vars
% )
% -------------------------------------------------------------------
% For each Goal that should be run on entities via 
% @see geolog_sql:geoquery_on_entities(Goal,R,KF,KV)
% and each possible instantiation Mode of Goal, a clause for this
% predicate must be defined by the application.  
% 
% Mode is the instantiation mode of Goal. Each argument of Goal that 
% is bound (=instantiated) is represented by a + symbol, and each 
% unbound (=free) argument is represented by a - symbol. So, for 
% a binary predicate the possible modes are ++, +-, -+, and --. 
%  
% Goal, Relations, KeyFields, KeyValues must conform to the spec of 
% @see geolog_sql:geoquery_on_entities/4
%
% The last three argument pairs specify the SELECT, FROM, and WHERE 
% parts of the SQL command that implements Goal in the respective Mode.
% Each template is a string that represents the respective part of 
% the SQL command and refers to values from the following list via
% ~a placeholders. The values in the subsequent list must appear 
% in the order in which they are used / referenced in the template. 
% Each template and subsequent list must conform to the specification
% of the arguments for the built-in SWI-Prolog predicate format/2. 
% -------------------------------------------------------------------

:- multifile 'geolog_sql.entitylevel':query_template/11 .

'geolog_sql.entitylevel':query_template(
	'++', % both KeyValues bound
    within_distance(Radius),
    [Relation1, Relation2],
    [KeyField1, KeyField2],
    [KeyValue1, KeyValue2],
"	SELECT
	    ST_DWithin(table1.shape, table2.shape, ~a)", [Radius],
"	FROM
	    ~a AS table1 , ~a AS table2", [Relation1, Relation2],
"	WHERE
	      table1.~a = ~a 
	  AND table2.~a = ~a", [KeyField1,KeyValue1,KeyField2,KeyValue2]
	).  
 
	 
'geolog_sql.entitylevel':query_template(
	'+-', % KeyValue1 bound, KeyValue2 unbound
    within_distance(Radius),
    Relations,
    [KeyField1, KeyField2],
    [KeyValue1, _], 
"	SELECT
	    table2.~a", [KeyField2],
"	FROM
	    ~a AS table1 , ~a AS table2", Relations,
"	WHERE
	      table1.~a = ~a 
	  AND ST_Intersects(ST_Buffer(table1.shape, ~a), table2.shape)", [KeyField1,KeyValue1,Radius]
	).  

'geolog_sql.entitylevel':query_template(
	'--', % both KeyValues unbound
    within_distance(Radius),
    Relations,
    KeyFields,
    _, 
"	SELECT
	    table1.~a, table2.~a", KeyFields,
"	FROM
	    ~a AS table1 , ~a AS table2", Relations,
"	WHERE
	      table1.~a = ~a 
	  AND ST_Intersects(ST_Buffer(table1.shape, ~a), table2.shape)", [Radius]
	).          
