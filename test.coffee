wikigeo = require './wikigeo'
geojson = wikigeo.geojson
assert = require('chai').assert

describe 'wikigeo', ->

  describe  'geojson', ->
    this.timeout(10000)

    it 'should work with just lat/lon', (done) ->
      geojson [-73.94, 40.67], (data) ->
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
        assert.ok f.geometry
        assert.equal f.geometry.type, "Point"
        assert.ok f.geometry.coordinates
        assert.equal typeof f.geometry.coordinates[0], "number"
        assert.equal typeof f.geometry.coordinates[1], "number"
        done()

    it 'should return empty results when there are no hits', (done) ->
      geojson [77.0155, 39.0114], (data) ->
        assert.equal data.type, "FeatureCollection"
        assert.ok data.features
        assert.ok Array.isArray(data.features)
        assert.equal data.features.length, 0
        done()

    it 'should be able to get summaries', (done) ->
      geojson [-77.0155, 39.0114], {summaries: true}, (data) ->
        assert.ok data.features[0].properties.summary
        done()

    it 'should be able to get images', (done) ->
      geojson [-77.0155, 39.0114], {images: true}, (data) ->
        assert.ok data.features[0].properties.image
        done()

    it 'should be able to get templates', (done) ->
      geojson [-77.0155, 39.0114], {templates: true}, (data) ->
        assert.ok data.features[0].properties.templates
        done()

    it 'should be able to get categories', (done) ->
      geojson [-77.0155, 39.0114], {categories: true}, (data) ->
        assert.ok data.features[0].properties.categories
        done()

    it 'limit should cause more results to come in', (done) ->
      geojson [-77.0155, 39.0114], limit: 15, (data) ->
        assert.ok data.features.length > 10 and data.features.length < 15
        done()

    it 'respects maximum limit', (done) ->
      doit = -> geojson([-77.0155, 39.0114], limit: 501, (data) ->)
      assert.throws doit, 'limit cannot be greater than 500'
      done()

    it 'respects maximum radius', (done) ->
      doit = -> geojson([-77.0155, 39.0114], radius: 10001, (data) ->)
      assert.throws doit, 'radius cannot be greater than 10000'
      done()

    #it 'allows for non en wikipedias', (done) ->
    #  console.log 'hi'
    #  geojson [-77.0155, 39.0114], language: (data) ->
    #    assert.match data.features[0].id, /http:\/\/fr\.wikipedia\.org/
    #    done()
