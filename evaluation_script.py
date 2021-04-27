import time
import geolog_core.interpreter

ip = geolog_core.interpreter.Interpreter()
for i in [256, 512, 1024, 2048, 4096, 8192]:
    query = 'random_relation("accidents", ' + str(i) + ', Accidents), closeby((Accidents, AccidentID), ("roads", RoadID)), closeby(("traffic", TrafficID), ("roads", RoadID))'
    result = ""
    for j in range(10):
        start = time.time()
        ip.query(query)
        end = time.time()
        elapsed_time = end - start
        result += str(elapsed_time) + "\t"
    print(result)
