wikigeo
=======

wikigeo allows you to easily fetch geojson for wikipedia articles around
a given geographic coordinate. It can easily be slotted into working with 
[Leaflet](http://leafletjs.com/)'s 
[geojson support](http://leafletjs.com/examples/geojson.html).

Basics
------

When you add wikigeo.js to your HTML page you will get a function called 
`geojson` which you pass a coordinate [longitude, latitude] and a callback 
that will receive the geojson data:

```javascript
geojson([-73.94, 40.67], function(data) {
  console.log(data);
});
```

The geojson this call would receive should look something like:

```javascript
{
  "type": "FeatureCollection",
  "features": [
    {
      "id": "http://en.wikipedia.org/wiki/New_York_City",
      "type": "Feature",
      "properties": {
        "name": "New York City"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.94,
          40.67
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Kingston_Avenue_(IRT_Eastern_Parkway_Line)",
      "type": "Feature",
      "properties": {
        "name": "Kingston Avenue (IRT Eastern Parkway Line)"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9422,
          40.6694
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Crown_Heights_–_Utica_Avenue_(IRT_Eastern_Parkway_Line)",
      "type": "Feature",
      "properties": {
        "name": "Crown Heights – Utica Avenue (IRT Eastern Parkway Line)"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9312,
          40.6688
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Brooklyn_Children's_Museum",
      "type": "Feature",
      "properties": {
        "name": "Brooklyn Children's Museum"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9439,
          40.6745
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/770_Eastern_Parkway",
      "type": "Feature",
      "properties": {
        "name": "770 Eastern Parkway"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9429,
          40.669
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Eastern_Parkway_(Brooklyn)",
      "type": "Feature",
      "properties": {
        "name": "Eastern Parkway (Brooklyn)"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9371,
          40.6691
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Paul_Robeson_High_School_for_Business_and_Technology",
      "type": "Feature",
      "properties": {
        "name": "Paul Robeson High School for Business and Technology"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.939,
          40.6755
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Pathways_in_Technology_Early_College_High_School",
      "type": "Feature",
      "properties": {
        "name": "Pathways in Technology Early College High School"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.939,
          40.6759
        ]
      }
    }
  ]
}
```

If you want to get more than 10 results, or increase the radius use the 
`limit` and `radius` options:

```javascript
geojson([-73.94, 40.67], {radius: 10000, limit: 100}, function(data) {
  console.log(data);
});
```

Quick Start With Leaflet
------------------------

In your HTML, you'll want to use Leaflet as usual:

```javascript

// create the map

var map = L.map('map').setView([40.67, -73.94], 13);
var osmLayer = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {});
osmLayer.addTo(map);

// get geojson and add it to the map

geojson([-73.94, 40.67], {radius: 10000, limit: 50}, function(data) {
    L.geoJson(data).addTo(map)
});
```

Please note that the order of geo coordinates in Leaflet is (lat, lon) whereas
in geojson it is (lon, lat). 

That's it, to get the basic functionality working. Open example.html for a
working example.

Develop
-------

If you want to hack on wikigeo you'll need a [node](http://nodejs.org) and
then you'll need to install some dependencies for testing:

    npm install

This will install cake, which you can use to run the tests:

    cake test

and you should see something like:

```
  wikigeo
    geojson
      ✓ should work with just lat/lon (202ms)
      ✓ should return empty results when there are no hits (136ms)
      ✓ limit should cause more results to come in (438ms)
      ✓ respects maximum limit
      ✓ respects maximum radius


  5 tests complete (781 ms)
```

License
-------

[![cc0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)
