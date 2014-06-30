
exports.byTime = (list) ->
  list.sort (a, b) ->
    timeA = (new Date a.time).valueOf()
    timeB = (new Date b.time).valueOf()
    timeB - timeA