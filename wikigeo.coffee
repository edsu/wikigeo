###

geojson takes a latitude and longitude and a callback that will be given 
geojson for Wikipedia articles that are relevant for that location

options:
  radius: search radius in meters (default: 1000, max: 10000)
  limit: the number of wikipedia articles to limit to (default: 10, max: 500)

example:
  geojson([39.0114, -77.0155], {radius: 5000}, function(data) {
    console.log(data);
  })

###

geojson = (latlon, opts={}, callback) =>
  if typeof opts == "function"
    callback = opts
    opts = {}
  opts.limit = 10 if not opts.limit
  opts.radius = 10000 if not opts.radius

  if opts.radius > 10000
    throw new Error("radius cannot be greater than 10000")

  if opts.limit > 500
    throw new Error("limit cannot be greater than 500")

  _search(latlon[0], latlon[1], opts.radius, opts.limit, callback)


#
# recursive function to collect the results from all search result pages
#

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

    # no results, oh well just give them empty geojson
    if not (response.query and response.query.pages)
      _convert(results, callback)
      return

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
      _convert(results, callback)


#
# do the work of converting a wikipedia response to geojson
#

_convert = (results, callback) ->
  geo =
    type: "FeatureCollection"
    features: []

  if not (results and results.query and results.query.pages)
    callback(geo)
    return

  for articleId, article of results.query.pages
    if not article.coordinates
      continue

    titleEscaped = article.title.replace /\s/g, "_"
    url = "http://en.wikipedia.org/wiki/#{titleEscaped}"

    if article.pageprops
      # TODO: convert to full URL w/r/t
      # https://www.mediawiki.org/wiki/Manual:$wgHashedUploadDirectory
      image = article.pageprops.page_image
    else
      image = null

    geo.features.push
      id: url
      type: "Feature"
      properties:
        name: article.title
        summary: article.extract
        image: image
      geometry:
        type: "Point"
        coordinates: [
          (Number) article.coordinates[0].lon
          (Number) article.coordinates[0].lat
        ]

  callback(geo)
  return

#
# helpers for doing http in browser (w/ jQuery) and in node (w/ request)
#

_fetch = (uri, opts, callback) ->
  request uri, qs: opts.params, json: true, (e, r, data) ->
    callback(data)

_browserFetch = (uri, opts, callback) ->
  $.ajax url: uri, data: opts.params, dataType: "jsonp", success: (response) ->
      callback(response)

try
  request = require('request')
  fetch = _fetch
catch error
  fetch = _browserFetch

root = exports ? this
root.geojson = geojson
