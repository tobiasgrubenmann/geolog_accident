import time
import geolog_core.interpreter

ip = geolog_core.interpreter.Interpreter()
for i in [256, 512, 1024, 2048, 4096, 8192]:
    query = 'random_relation("accidents", ' + str(i) + ', Accidents), entity_type_relational(crossing_features, "traffic", Crossings), near_relational(Accidents, Crossings, AccidentsNearCrossing, ["Accident", "Crossing"]), filter_by_relationship("traffic", AccidentsNearCrossing, "Crossing", CrossingsFiltered), entity_type_relational(traffic_signal_features, "traffic", Signals), near_relational(CrossingsFiltered, Signals, CrossingsSignals, ["Crossing", "Signal"]), join_relational(AccidentsNearCrossing, CrossingsSignals, AccidentSignalsCrossing, "Crossing", "Crossing", [["rel1.Accident", "Accident"], ["rel1.Crossing", "Crossing"], ["rel2.Signal", "Signal"]]), project_id_relational(AccidentSignalsCrossing, [["Accident", "Accident"], ["Crossing", "Crossing"]], AccidentWithSignalsNearCrossing), project_id_relational(AccidentsNearCrossing, [["Accident", "Accident"], ["Crossing", "Crossing"]], AccidentCrossingProj), minus_relational(AccidentCrossingProj, AccidentWithSignalsNearCrossing, Result), iterate_relational(Result, [Accident, _])'
    result = ""
    for j in range(10):
        start = time.time()
        ip.query(query)
        end = time.time()
        elapsed_time = end - start
        result += str(elapsed_time) + "\t"
    print(result)
