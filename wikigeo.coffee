###

geojson takes a geo coordinate (longitude, latitude) and a callback that will 
be given geojson for Wikipedia articles that are relevant for that location

options:
  radius: search radius in meters (default: 1000, max: 10000)
  limit: the number of wikipedia articles to limit to (default: 10, max: 500)
  images: set to true to get filename images for the article
  summaries: set to true to get short text summaries for the article
  templates: set to true to get a list of templates used in the article
  categories: set to true to get a list of categories the article is in

example:
  geojson([-77.0155, 39.0114], {radius: 5000}, function(data) {
    console.log(data);
  })

###

geojson = (geo, opts={}, callback) =>
  if typeof opts == "function"
    callback = opts
    opts = {}
  opts.limit = 10 if not opts.limit
  opts.radius = 10000 if not opts.radius

  if not opts.language
    opts.language = "en"

  if opts.radius > 10000
    throw new Error("radius cannot be greater than 10000")

  if opts.limit > 500
    throw new Error("limit cannot be greater than 500")

  _search(geo, opts, callback)


#
# recursive function to collect the results from all search result pages
#

_search = (geo, opts, callback, results, queryContinue) =>
  url = "http://#{ opts.language }.wikipedia.org/w/api.php"
  q =
    action: "query"
    prop: "info|coordinates"
    generator: "geosearch"
    ggsradius: opts.radius
    ggscoord: "#{geo[1]}|#{geo[0]}"
    ggslimit: opts.limit
    format: "json"

  if opts.images
    q.prop += "|pageprops"

  if opts.summaries
    q.prop += "|extracts"
    q.exlimit = "max"
    q.exintro = 1
    q.explaintext = 1

  if opts.templates
    q.prop += "|templates"
    q.tllimit = 500

  if opts.categories
    q.prop += "|categories"
    q.cllimit = 500

  # add continue parameters if they have been provided, these are
  # parameters that are used to fetch more results from the api
  
  continueParams =
    extracts: "excontinue"
    coordinates: "cocontinue"
    templates: "tlcontinue"
    categories: "clcontinue"

  if queryContinue
    for name, param of continueParams
      if queryContinue[name]
        q[param] = queryContinue[name][param]

  fetch url, params: q, (response) =>

    if not results
      first = true
      results = response
    else:
      first = false

    # no results, oh well just give them empty geojson
    if not (response.query and response.query.pages)
      _convert(results, opts, callback)
      return

    for articleId, article of response.query.pages
      resultsArticle = results.query.pages[articleId]

      # this parameter is singular in article data...
      for prop, param of continueParams
        if prop == 'extracts'
          prop = 'extract'

        # continue if there are no new values to merge 
        newValues = article[prop]
        if not newValues
          continue

        # merge arrays by concatenating with old values
        if Array.isArray(newValues)
          if not resultsArticle[prop]
            resultsArticle[prop] = newValues
          else if not first and resultsArticle[prop][-1] != newValues[-1]
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
      _search(geo, opts, callback, results, queryContinue)

    else
      _convert(results, opts, callback)


#
# do the work of converting a wikipedia response to geojson
#

_convert = (results, opts, callback) ->
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
    url = "http://#{ opts.language }.wikipedia.org/wiki/#{titleEscaped}"

    feature =
      id: url
      type: "Feature"
      properties:
        name: article.title
      geometry:
        type: "Point"
        coordinates: [
          (Number) article.coordinates[0].lon
          (Number) article.coordinates[0].lat
        ]

    if opts.images
      if article.pageprops
        # TODO: convert to full URL
        # https://www.mediawiki.org/wiki/Manual:$wgHashedUploadDirectory
        image = article.pageprops.page_image
      else
        image = null
      feature.properties.image = image

    if opts.templates
      feature.properties.templates = _clean(article.templates)

    if opts.summaries
      feature.properties.summary = article.extract

    if opts.categories
      feature.properties.categories = _clean(article.categories)

    geo.features.push feature

  callback(geo)
  return

#
# strip wikipedia specific information
# 

_clean = (list) ->
  return (i.title.replace(/^.+?:/, '') for i in list)

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
