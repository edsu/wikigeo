wikigeo = require './wikigeo'
geojson = wikigeo.geojson
assert = require('chai').assert

describe 'wikigeo', ->

  describe  'geojson', ->

    it 'should work with just lat/lon', (done) ->
      geojson [40.67, -73.94], (data) ->
        assert.equal data.type, "FeatureCollection"
        assert.ok data.features
        assert.ok Array.isArray(data.features)
        assert.ok data.features.length > 0 and data.features.length <= 10

        f = data.features[0]
        assert.ok f.id
        assert.match f.id, /http:\/\/en.wikipedia.org\/wiki\/.+/
        assert.equal f.type, "Feature"
        assert.ok f.properties
        assert.ok f.properties.name
        assert.ok f.properties.image
        assert.ok f.geometry
        assert.equal f.geometry.type, "Point"
        assert.ok f.geometry.coordinates
        assert.equal typeof f.geometry.coordinates[0], "number"
        assert.equal typeof f.geometry.coordinates[1], "number"
        done()

    it 'should return empty results when there are no hits', (done) ->
      geojson [39.0114, 77.0155], (data) ->
        assert.equal data.type, "FeatureCollection"
        assert.ok data.features
        assert.ok Array.isArray(data.features)
        assert.equal data.features.length, 0
        done()

    it 'limit should cause more results to come in', (done) ->
      geojson [40.67, -73.94], limit: 15, (data) ->
        assert.ok data.features.length > 10 and data.features.length < 15
        done()

    it 'respects maximum limit', ->
      doit = -> geojson([40.67, -73.94], limit: 501, (data) ->)
      assert.throws doit, 'limit cannot be greater than 500'

    it 'respects maximum radius', ->
      doit = -> geojson([40.67, -73.94], radius: 10001 , (data) ->)
      assert.throws doit, 'radius cannot be greater than 10000'


