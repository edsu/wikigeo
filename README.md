wikigeo
=======

wikigeo allows you to easily fetch georss for wikipedia articles around
a given geographic coordinate. It can easily be slotted into working with 
[Leaflet](http://leafletjs.com/)'s 
[geojson support](http://leafletjs.com/examples/geojson.html).

Basics
------

When you add wikigeo.js to your HTML page you will get a function called 
georss which you pass a coordinate and a callback that will receive the 
data.

```javascript
geojson([40.67, -73.94], function(data) {
  console.log(data);
});
```

If you want to get more than 10 results, or increase the radius use the 
`limit` and `radius` options:

```javascript
geojson([40.67, -73.94], {radius: 10000, limit: 100}, function(data) {
  console.log(data);
});
```

Quick Start With Leaflet
------------------------

In your HTML, you'll want to use Leaflet as usual:

```html

// create the map

var map = L.map('map').setView([40.67, -73.94], 13);
var osmLayer = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {});
osmLayer.addTo(map);

// get geojson and add it to the map

geojson([40.67, -73.94], {radius: 10000, limit: 50}, function(data) {
    L.geoJson(data).addTo(map)
});

```

That's it, to get the basic functionality working. Open example.html for a
working example.

Develop
-------

If you want to hack on wikigeo you'll need a [node](http://nodejs.org) and
then you'll need to install some dependencies for testing:

  npm install

This will install cake, which you can use to run the tests:

  cake test

License
-------

[![cc0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)
