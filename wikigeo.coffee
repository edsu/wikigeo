geojson = (latlon, opts, callback) =>
  opts.limit = 10 if not opts.limit
  opts.radius = 10000 if not opts.radius
  _search(latlon[0], latlon[1], opts.radius, opts.limit, callback)

# recursive function to collect the results from all search result pages

_search = (lat, lon, radius, limit, callback, results, queryContinue) =>
  url = "http://en.wikipedia.org/w/api.php"
  q =
    action: "query"
    prop: "info|extracts|coordinates|pageprops"
    exlimit: "max"
    exintro: 1
    explaintext: 1
    generator: "geosearch"
    ggsradius: radius
    ggscoord: "#{lat}|#{lon}"
    ggslimit: limit
    format: "json"

  # add continue parameters if they have been provided
  
  continueParams =
    extracts: "excontinue"
    coordinates: "cocontinue"

  if queryContinue
    for name, param of continueParams
      if queryContinue[name]
        q[param] = queryContinue[name][param]

  fetch url, params: q, (response) =>
    if not results
      results = response

    for articleId, article of response.query.pages
      resultsArticle = results.query.pages[articleId]

      # this parameter is singular in article data...
      for prop of continueParams
        if prop == 'extracts'
          prop = 'extract'

        # continue if there are no new values to merge 
        newValues = article[prop]
        if not newValues
          continue

        # merge arrays by concatenating with old values
        if Array.isArray(newValues)
          if not resultsArticle[prop]
            resultsArticle[prop] = []
          resultsArticle[prop] = resultsArticle[prop].concat(newValues)

        # otherwise just assign
        else
          resultsArticle[prop] = article[prop]

    if response['query-continue']
      if not queryContinue
        queryContinue = response['query-continue']
      else
        for name, param of continueParams
          if response['query-continue'][name]
            queryContinue[name] = response['query-continue'][name]
      _search(lat, lon, radius, limit, callback, results, queryContinue)

    else
      # all done
      # TODO: convert to geojson
      callback(results)

_fetch = (uri, opts, callback) ->
  request uri, qs: opts.params, json: true, (e, r, data) ->
    callback(data)

_browserFetch = (uri, opts, callback) ->
  $.ajax url: url, data: opts.params, dataType: "jsonp", success: callback

try
  request = require('request')
  fetch = _fetch
catch error
  fetch = _browserFetch

root = exports ? this
root.wikigeo = wikigeo
