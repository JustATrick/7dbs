{
  "inputs":"rooms",
  "query":[
    {"map":{
      "language":"javascript",
      "source":
        "function(v) { return [1]; }"
    }},
    {"reduce":{
      "language":"javascript",
      "name":"Riak.reduceSum"
    }}
  ]
}
