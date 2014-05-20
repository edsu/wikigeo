wikigeo
=======

[![Build Status](https://travis-ci.org/edsu/wikigeo.svg)](http://travis-ci.org/edsu/wikigeo)

wikigeo allows you to fetch [geojson](http://www.geojson.org/geojson-spec.html)
for [Wikipedia](http://wikipedia.org) articles around a given geographic
coordinate. It can be easily added to a map using [Leaflet's geojson
support](http://leafletjs.com/examples/geojson.html). The data comes directly
from the [Wikipedia API](http://en.wikipedia.org/w/api.php) which has the
[GeoData](http://www.mediawiki.org/wiki/Extension:GeoData) extension installed.

![Leaflet Screenshot](http://edsu.github.io/wikigeo/img/screenshot.png)

Basics
------

When you add wikigeo.js to your HTML page you will get a function called 
`geojson` which you pass a coordinate `[longitude, latitude]` and a callback
function that will receive the geojson data:

```javascript
geojson([-73.94, 40.67], function(data) {
  console.log(data);
});
```

The geojson for this call should look something like:

```javascript
{
  "type": "FeatureCollection",
  "features": [
    {
      "id": "30854694",
      "type": "Feature",
      "properties": {
        "url": "https://en.wikipedia.org/?curid=30854694",
        "name": "Jewish Children\'s Museum",
        "touched": "2014-05-18T12:50:57Z"
    },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9419,
          40.6689
        ]
      }
    },
    {
      "id": "729460",
      "type": "Feature",
      "properties": {
        "url": "https://en.wikipedia.org/?curid=729460",
        "name": "Kingston Avenue (IRT Eastern Parkway Line)",
        "touched": "2014-05-13T00:12:17Z"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -73.9422,
          40.6694
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

Additional Wikipedia Properties
-------------------------------

Additional properties of the Wikipedia articles can be added to the
geojson feature properties by setting any of the following options to true: 
`images`, `categories`, `summaries`,  `templates`.  For example:

```javascript
geojson(
  [-73.94, 40.67], 
  {
    limit: 5,
    radius: 1000,
    images: true, 
    categories: true, 
    summaries: true,
    templates: true
  }, 
  function(data) {
    console.log(data);
  }
);
```

Beware, this can increase your query time since multiple trips to the Wikipedia
API are often required. Here's what the results would look like for the above
call:

```javascript

{
  "type": "FeatureCollection",
  "features": [
     {
      "id": "43485",
      "type": "Feature",
      "properties": {
        "url": "https://en.wikipedia.org/?curid=43485",
        "name": "Silver Spring, Maryland",
        "touched": "2014-05-20T04:25:48Z",
        "image": "Silver_Spring_Montage.jpg",
        "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/4/48/Silver_Spring_Montage.jpg",
        "templates": ["!",
          "-",
          "Abbr",
          "Ambox",
          "Both",
          "Br separated entries",
          "Category handler",
          "Citation",
          "Citation needed",
          "Cite news",
          "Cite web",
          "Column-width",
          "Commons",
          "Commons category",
          "Convert",
          "Coord",
          "Country data Maryland",
          "Country data United States",
          "Country data United States of America",
          "DCMetroArea",
          "Dead link",
          "Expand section",
          "Fix",
          "Fix/category",
          "Flag",
          "Flag/core",
          "Flagicon image",
          "GR",
          "Geobox coor",
          "Geographic reference",
          "Infobox",
          "Infobox settlement",
          "Infobox settlement/areadisp",
          "Infobox settlement/densdisp",
          "Infobox settlement/impus",
          "Infobox settlement/lengthdisp",
          "Infobox settlement/pref",
          "Largest cities",
          "Largest cities of Maryland",
          "Maryland",
          "Max",
          "Max/2",
          "Montgomery County, Maryland",
          "Navbar",
          "Navbox",
          "Navbox subgroup",
          "Navboxes",
          "Nowrap",
          "Order of magnitude",
          "Precision",
          "Reflist",
          "Rnd",
          "Side box",
          "Sister",
          "Talk other",
          "Transclude",
          "US Census population",
          "US county navigation box",
          "US state navigation box",
          "Unbulleted list",
          "Wikivoyage",
          "National Register of Historic Places in Maryland",
          "Navbar",
          "Navbox",
          "Reflist",
          "Str left",
          "Talk other",
          "Transclude",
          "Arguments",
          "Citation/CS1",
          "Citation/CS1/Configuration",
          "Citation/CS1/Date validation",
          "Citation/CS1/Whitelist",
          "Coordinates",
          "HtmlBuilder",
          "Infobox",
          "Location map",
          "Math",
          "Navbar",
          "Navbox",
          "Yesno"
        ],
        "summary": "The Polychrome Historic District is a national historic district in the Four Corners neighborhood in Silver Spring, Montgomery County, Maryland. It recognizes a group of five houses built by John Joseph Earley in 1934 and 1935. Earley used precast concrete panels with brightly colored aggregate to produce the polychrome effect, with Art Deco details. The two-inch-thick panels were attached to a conventional wood frame. Earley was interested in the use of mass-production techniques to produce small, inexpensive houses, paralleling Frank Lloyd Wright\'s Usonian house concepts.",
        "categories": ["Art Deco architecture in Maryland",
          "Coordinates on Wikidata",
          "Historic American Buildings Survey in Maryland",
          "Historic districts in Maryland",
          "Houses in Montgomery County, Maryland",
          "Houses on the National Register of Historic Places in Maryland",
          "Maryland Registered Historic Place stubs"
        ]
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.0158,
          39.0181
        ]
      }
    }
  ]
}
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

If you want to hack on wikigeo you'll need [Node](http://nodejs.org) and
then you'll need to install some dependencies for testing:

    npm install

This will install mocha, which you can use to run the tests, simply do:

    npm test

and you should see something like a nyan cat:

```
  > wikigeo@1.0.0 test /home/despairblue/vcs/git/wikigeo
  > mocha --colors --reporter nyan --compilers coffee:coffee-script/register test/wikigeo.coffee

   11  -_-_-_-_-_-__,------,
   0   -_-_-_-_-_-__|  /\_/\ 
   0   -_-_-_-_-_-_~|_( ^ .^) 
       -_-_-_-_-_-_ ""  "" 

    11 passing (5s)
```

License
-------

[![cc0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)
