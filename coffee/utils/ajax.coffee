
host = location.host
host = host.replace /topics/, 'topics-api'
apiHost = "http://#{host}"

console.log apiHost

local =
  handle: (x) ->
    console.log 'ajax error', x

exports.req = (type, url, data, cb) ->
  if typeof data is 'function'
    cb = data
    data = {}
  jQuery.ajax
    url: "#{apiHost}#{url}"
    type: type
    data: data
    xhrFields:
      withCredentials: true
    success: (data) ->
      cb data if cb?
    error: (data) ->
      local.handle data

exports.handleError = (f) ->
  local.handle = f