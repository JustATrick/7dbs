{
  "inputs":"rooms",
  "query":[
    {"map":{
      "language":"javascript",
      "source":
        "function(v) {
           var parsed_data = JSON.parse(v.values[0].data);
           var floor = Math.floor(v.key / 100);
           var data = {};
           data[floor] = parsed_data.capacity;
           return [data];
        }"
    }},
    {"reduce":{
      "language":"javascript",
      "source":
        "function(values) {
          var totals = {};
          for (var i in values) {
            for (var floor in values[i]) {
              if ( totals[floor] ) totals[floor] += values[i][floor];
              else                 totals[floor]  = values[i][floor];
            }
          }
          return [totals];
        }"
    }}
  ]
}
