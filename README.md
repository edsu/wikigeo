wikigeo
=======

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
      "id": "http://en.wikipedia.org/wiki/Silver_Spring,_Maryland",
      "type": "Feature",
      "properties": {
        "name": "Silver Spring, Maryland",
        "image": "Downtown_silver_spring_wayne.jpg",
        "templates": [
          "-",
          "Abbr",
          "Ambox",
          "Ambox/category",
          "Ambox/small",
          "Basepage subpage",
          "Both",
          "Category handler",
          "Category handler/blacklist",
          "Category handler/numbered"
        ],
        "summary": "Silver Spring is an unincorporated area and census-designated place (CDP) in Montgomery County, Maryland, United States. It had a population of 71,452 at the 2010 census, making it the fourth most populous place in Maryland, after Baltimore, Columbia, and Germantown.\nThe urbanized, oldest, and southernmost part of Silver Spring is a major business hub that lies at the north apex of Washington, D.C. As of 2004, the Central Business District (CBD) held 7,254,729 square feet (673,986 m2) of office space, 5216 dwelling units and 17.6 acres (71,000 m2) of parkland. The population density of this CBD area of Silver Spring was 15,600 per square mile all within 360 acres (1.5 km2) and approximately 2.5 square miles (6 km2) in the CBD/downtown area. The community has recently undergone a significant renaissance, with the addition of major retail, residential, and office developments.\nSilver Spring takes its name from a mica-flecked spring discovered there in 1840 by Francis Preston Blair, who subsequently bought much of the surrounding land. Acorn Park, tucked away in an area of south Silver Spring away from the main downtown area, is believed to be the site of the original spring.\n\n",
        "categories": [
          "All articles to be expanded",
          "All articles with dead external links",
          "All articles with unsourced statements",
          "Articles to be expanded from June 2008",
          "Articles with dead external links from July 2009",
          "Articles with dead external links from October 2010",
          "Articles with dead external links from September 2010",
          "Articles with unsourced statements from February 2007",
          "Articles with unsourced statements from May 2009",
          "Commons category template with no category set"
        ]
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.019,
          39.0042
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Montgomery_Blair_High_School",
      "type": "Feature",
      "properties": {
        "name": "Montgomery Blair High School",
        "image": "MBHS_Seal.png",
        "templates": [
          "Ambox",
          "Ambox/category",
          "Ambox/core"
        ],
        "summary": "Montgomery Blair High School (MBHS) is a public high school located in unincorporated Silver Spring in Montgomery County, Maryland, United States.\nThe school was named after Montgomery Blair, a lawyer who represented Dred Scott in his United States Supreme Court case and who served as Postmaster General under President Abraham Lincoln. It originally opened in 1925 as Takoma Park-Silver Spring High School. In 1935, however, Montgomery Blair High School opened at 313 Wayne Avenue, a location overlooking Sligo Creek, now occupied by Silver Spring International Middle School. In 1998, the campus moved two miles (3 km) north to the Kay Tract, a long-vacant tract of land adjacent to the Capital Beltway.\nThe school has a magnet program and a Communication Arts Program (CAP), which draw students from both the Silver Spring area and across Montgomery County, and make up approximately 20% of Blair's student population. It is a member of the National Consortium for Specialized Secondary Schools of Mathematics, Science and Technology (NCSSSMST).",
        "categories": [
          "1925 establishments in Maryland",
          "All articles needing additional references",
          "All articles with dead external links",
          "All articles with unsourced statements",
          "Articles needing additional references from August 2010",
          "Articles needing additional references from January 2013",
          "Articles with dead external links from January 2013"
        ]
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.0116,
          39.0181
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Polychrome_Historic_District",
      "type": "Feature",
      "properties": {
        "name": "Polychrome Historic District",
        "image": "Polychrome_Historic_District_Apr_10.JPG",
        "templates": [
          "Asbox"
        ],
        "summary": "The Polychrome Historic District is a national historic district in the Four Corners neighborhood in Silver Spring, Montgomery County, Maryland. It recognizes a group of five houses built by John Joseph Earley in 1934 and 1935. Earley used precast concrete panels with brightly colored aggregate to produce the polychrome effect, with Art Deco details. The two-inch-thick panels were attached to a conventional wood frame. Earley was interested in the use of mass-production techniques to produce small, inexpensive houses, paralleling Frank Lloyd Wright's Usonian house concepts.",
        "categories": [
          "Art Deco architecture in Maryland",
          "Historic districts in Maryland"
        ]
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.0158,
          39.0181
        ]
      }
    },
    {
      "id": "http://en.wikipedia.org/wiki/Four_Corners_(Silver_Spring,_Maryland)",
      "type": "Feature",
      "properties": {
        "name": "Four Corners (Silver Spring, Maryland)",
        "templates": [
          "Asbox",
          "Cite web",
          "Coord",
          "Maryland-geo-stub",
          "Navbar",
          "Reflist",
          "Talk other",
          "Transclude",
          "Citation/CS1"
        ],
        "summary": "Four Corners is a neighborhood located in Silver Spring, Maryland, United States.",
        "categories": [
          "Maryland geography stubs",
          "Neighborhoods in Montgomery County, Maryland",
          "Silver Spring, Maryland"
        ]
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.0131,
          39.02
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
