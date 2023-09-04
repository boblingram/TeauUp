const String journeyJson = '''{"userJourney":[
{"date":"2023-09-09T10:15:55.469427Z","id":"14","time":"2023-06-01T10:15:55.469427Z","name":"10km Cycling","status":"COMPLETED"},{"date":"2023-06-10T10:15:55.469427Z","id":"2","time":"2023-06-01T10:15:55.469427Z","name":"5km Running","status":"SKIPPED"},
{"date":"2023-07-01T10:15:55.469427Z","id":"3","time":"2023-06-01T10:15:55.469427Z","name":"10km Cycling","status":"SKIPPED"},
{"date":"2023-07-01T10:15:55.469427Z","id":"4","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":""},
{"date":"2023-07-01T10:15:55.469427Z","id":"5","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-02T10:15:55.469427Z","id":"6","time":"2023-06-01T10:15:55.469427Z","name":"Algebra - Solve 10 polynomial","status":"SKIPPED"},
{"date":"2023-09-02T10:15:55.469427Z","id":"7","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":""},
{"date":"2023-09-03T10:15:55.469427Z","id":"8","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"9","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-04T10:15:55.469427Z","id":"10","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"11","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"12","time":"2023-06-01T10:15:55.469427Z","name":"THree","status":"COMPLETED"},
{"date":"2023-09-09T10:15:55.469427Z","id":"18","time":"2023-06-01T10:15:55.469427Z","name":"Hundred","status":"COMPLETED", "desc": "Lose Weight"},
{"date":"2023-09-09T10:15:55.469427Z","id":"18","time":"2023-06-01T10:15:55.469427Z","name":"Hundred","status":"COMPLETED", "desc": "Lose Weight"},
{"date":"2023-09-06T10:15:55.469427Z","id":"20","time":"2023-06-01T10:15:55.469427Z","name":"Fifty Thousand","status":"COMPLETED"},
{"date":"2023-09-04T10:15:55.469427Z","id":"18","time":"2023-06-01T10:15:55.469427Z","name":"Hundred","status":"COMPLETED", "desc": "Lose Weight"},
{"date":"2023-09-09T10:15:55.469427Z","id":"14","time":"2023-06-01T10:15:55.469427Z","name":"Working fine","status":"COMPLETED", "desc": "Lose Weight"},{"date":"2023-05-06T10:15:55.469427Z","id":"12","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED", "desc": "Study"},
{"date":"2023-09-06T10:15:55.469427Z","id":"12","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED", "desc": "Study"}
]}''';


const String journeyGJson = '''{"userJourney":[
{"date":"2023-09-09T10:15:55.469427Z","id":"14","time":"2023-06-01T10:15:55.469427Z","name":"10km Cycling","status":"COMPLETED"},
{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"},
{"date":"2023-07-01T10:15:55.469427Z","id":"3","time":"2023-06-01T10:15:55.469427Z","name":"10km Cycling","status":"SKIPPED"},
{"date":"2023-07-01T10:15:55.469427Z","id":"4","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-07-01T10:15:55.469427Z","id":"5","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-02T10:15:55.469427Z","id":"6","time":"2023-06-01T10:15:55.469427Z","name":"Algebra - Solve 10 polynomial","status":"SKIPPED"},
{"date":"2023-09-02T10:15:55.469427Z","id":"7","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"8","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"9","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-04T10:15:55.469427Z","id":"10","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"11","time":"2023-06-01T10:15:55.469427Z","name":"Calculus - Solve 5 Differential Equations","status":"COMPLETED"},
{"date":"2023-09-03T10:15:55.469427Z","id":"12","time":"2023-06-01T10:15:55.469427Z","name":"THree","status":"COMPLETED"},
{"date":"2023-09-09T10:15:55.469427Z","id":"18","time":"2023-06-01T10:15:55.469427Z","name":"Hundred","status":"COMPLETED", "desc": "Lose Weight"},
{"date":"2023-09-09T10:15:55.469427Z","id":"18","time":"2023-06-01T10:15:55.469427Z","name":"Hundred","status":"COMPLETED", "desc": "Lose Weight"},
{"date":"2023-09-06T10:15:55.469427Z","id":"20","time":"2023-06-01T10:15:55.469427Z","name":"Fifty Thousand","status":"COMPLETED"},
{"date":"2023-09-04T10:15:55.469427Z","id":"18","time":"2023-06-01T10:15:55.469427Z","name":"Hundred","status":"COMPLETED", "desc": "Lose Weight"},
{"date":"2023-09-09T10:15:55.469427Z","id":"14","time":"2023-06-01T10:15:55.469427Z","name":"Working fine","status":"COMPLETED", "desc": "Lose Weight"},{"date":"2023-05-06T10:15:55.469427Z","id":"12","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED", "desc": "Study"},
{"date":"2023-09-06T10:15:55.469427Z","id":"12","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED", "desc": "Study"}
]}''';