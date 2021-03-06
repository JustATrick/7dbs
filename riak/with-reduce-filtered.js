{
  "inputs":{
    "bucket":"rooms",
    "key_filters":[["string_to_int"], ["less_than", 1000]]
  },
  "query":[
    {"map":{
      "language":"javascript",
      "bucket":"my_functions",
      "key":"map_capacity"
    }},
    {"reduce":{
      "language":"javascript",
      "source":
        "function(v) {
          var totals = {};
          for (var i in v) {
            for (var style in v[i]) {
              if ( totals[style] ) totals[style] += v[i][style];
              else                 totals[style]  = v[i][style];
            }
          }
          return [totals];
        }"
    }}
  ]
}
