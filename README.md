# TileServer PHP in Docker

<a href="https://github.com/ec22s/docker-tileserver-php/actions/workflows/test.yml"><img src="https://github.com/ec22s/docker-tileserver-php/workflows/Test/badge.svg"></a>

### Forked from [maptiler/tileserver-php](https://github.com/maptiler/tileserver-php)

- Changes:

  - Containerization using Docker

    - Based https://github.com/ec22s/docker-php5.6-apache2 and upgraded to PHP 7.1

  - Use GitHub Actions instead of Travis CI

  - and WIP...

<br>

### 2025年12月 下記の手順でローカルファイルの `mbtiles` を表示できること確認

```shell
cd doc-root
wget https://github.com/klokantech/tileserver-php/releases/download/v0.1/grandcanyon.mbtiles
make up
# open http://localhost:8888
```
- データのURLはフォーク元の `.travis.yml` にあったもの

- 中身の仕様は以下のとおりラスタデータ 
  ```
  $ mbtiles meta-all grandcanyon.mbtiles 
  id: grandcanyon
  tile_info:
    format: png
    encoding: ''
  layer_type: overlay
  tilejson:
    tilejson: 3.0.0
    tiles: []
    bounds:
    - -112.261791
    - 35.983744
    - -112.113981
    - 36.132062
    name: AZ_Grand_Canyon_1988_geo
    version: '1'
    format: png
  ```

<br>

### 動作確認環境

- macOS 15.6 (24G84)

- GNU bash, version 5.3.3(1)-release (x86_64-apple-darwin23.6.0)

- Docker version 29.0.0, build 3d4129b9ea

- Docker Compse version v2.40.3-desktop.1

<br>

### 確認した動き

- ブラウザがページを読み込む時、`doo/root/` 下の `mbtiles` ファイルが認識される (サーバ再起動不要)

- `mbtiles` が一つだと自動的に地図表示に、複数あるとサムネイルでの選択画面になる

  - 地図表示では、普通のオンライン地図を背景としてローカルの `mbtiles` がオーバーレイされ、オーバーレイの濃度を変えられる

    <img width=512 src="https://github.com/user-attachments/assets/7d9dd4d0-b11f-4b9a-8e09-27360363751f" />

- ファイル名に空白があると正常に動作しない (サムネはでき、クリックするとファイルの地図データの位置に合わせて背景のオンライン地図が出る)

  <img width=512 src="https://github.com/user-attachments/assets/253412c1-a05f-4402-95b4-fb6c7b04fc3c" />

- ファイルがベクタタイルでも一応読み込まれるが、サムネは全世界になり、スタイルもほぼ当てられない

  <img height=384 src="https://github.com/user-attachments/assets/77302f49-c268-42a1-97d7-b9480629f176" />　
  <img height=384 src="https://github.com/user-attachments/assets/56b846ef-bc93-4ea3-8a7b-1eb606509013" />

- ベクタタイルにスタイルを当てられれば実用性が大きく増すはず

  - ズームレベルに応じて表示する地物の詳細度が変わる (ベクタだから当然)

  - 右側ペインでOpenLayers 3を選ぶと、背景のオンライン地図を表示することも可 (左下のチェックボックス)

  - 描画速度はMapbox GLの方が速い

<br>

以下、fork元のREADMEです

---

TileServer PHP: MapTiler and MBTiles maps via WMTS
==================================================

[![Build Status](https://travis-ci.org/klokantech/tileserver-php.svg)](https://travis-ci.org/klokantech/tileserver-php)
[![Docker Hub](https://img.shields.io/badge/docker-hub-blue.svg)](https://hub.docker.com/r/klokantech/tileserver-php/)

This server distributes maps to desktop, web, and mobile applications from a standard Apache+PHP web hosting.

It is a free and open-source project implementing the OGC WMTS standard for pre-rendered map tiles made with any [map tiling software](https://www.maptiler.com/desktop/) like MapTiler Desktop, GDAL2Tiles, or any other MBTiles file.

It is the easiest and cheapest way how to serve zoomable maps in a standardized way - practically from any ordinary web hosting.

It is easy to install - copy the project files to a PHP-enabled directory along with your map data.

It comes with an online interface showing the list of the maps and step-by-step guides for online mapping libraries (Google Maps API, Leaflet, OpenLayers, OL3, MapLibre GL JS, ArcGIS JS) and various desktop GIS software:

![tileserver-screenshot](https://f.cloud.github.com/assets/59284/1041807/a040160c-0fdb-11e3-8941-ab367b2a648d.png)

This project is developed in PHP, not because it is the best language for the development of web applications, but because it maximally simplifies the deployment on a large number of web hostings, including various free web hostings providers.

Tiles are served directly by Apache with mod_rewrite rules as static files and therefore are very fast and with correct HTTP caching headers. Only XML metadata is delivered via PHP. MBTiles are served via PHP and are therefore slower unless they are unpacked with mbutil.

[MapTiler](http://www.maptiler.com/) can render GeoTIFF, ECW, MrSID, GeoPDF into compatible map tiles. JPEG, PNG, GIF, and TIFF with scanned maps or images without geolocation can be turned into standard map layers with the visual georeferencing functionality (http://youtu.be/eJxdCe9CNYg).

[![MapTiler - mapping tiles](https://cloud.githubusercontent.com/assets/59284/3037911/583d7810-e0c6-11e3-877c-6a7747b80dd3.jpg)](http://www.maptiler.com/)

Requirements:
-------------

- Apache webserver (with mod_rewrite / .htaccess supported)
- PHP 5.6+ with SQLite module (php5-sqlite)

(or another webserver implementing mod_rewrite rules and PHP)

Installation:
-------------

Download the project files as a [zip archive](https://github.com/klokantech/tileserver-php/archive/master.zip) or source code from GitHub and unpack it into a web-hosting of your choice.

If you access the web address relevant to the installation directory, the TileServer.php Server should display you a welcome message and further instructions.

Then you can upload to the web hosting your mapping data - a directory with tiles rendered with [MapTiler](http://www.maptiler.com/).

Tiles produced by open-source GDAL2Tiles or MapTiler Desktop and tiles in .mbtiles format can be easily converted to the required structure (XYZ with top-left origin and metadata.json file). The open-source utility [mbutil](https://github.com/mapbox/mbutil) produces exactly the required format.

Direct reading of .mbtiles files is supported but with decreased performance compared to the static files in a directory. The advantage is easier data management, especially upload over FTP or similar protocols.

Supported protocols:
--------------------

- OpenGIS WMTS 1.0.0

  The Open Geospatial Consortium (OGC) Web Map Tile Service (WMTS)
  Both KVP and RESTful version 1.0.0:
  http://www.opengeospatial.org/standards/wmts/

  Target is maximal compliance to the standard.

  Exposed at http://[...]/wmts

- OSGeo TMS 1.0.0

  The OSGeo Tile Maps Service, but with inverted y-coordinates:
  http://wiki.osgeo.org/wiki/Tile_Map_Service_Specification
  This means request compatible with OpenStreetMap tile servers.

  Target is "InvertedTMS" implementation used by the ArcBruTile client
  which is available from http://arcbrutile.codeplex.com/ and uses
  flipped y-axis.

  Exposed at http://[...]/tms

- TileJSON

  Metadata about the individual maps in a ready to use form for web
  clients following the standard http://mapbox.com/developers/tilejson/
  and with support for JSONP access.

  Exposed at http://[...]/layer.json or .jsonp

- Direct access with XYZ tile requests (to existing tiles in a directory
  or to .mbtiles)

  Compatible with Google Maps API / Bing SDK / OpenStreetMap clients.

  Exposed at http://[...]/layer/z/x/y.ext

- MapBox UTFgrid request (for existing tiles in .mbtiles with UTFgrid support). Callback is supported

  Example https://www.mapbox.com/demo/visiblemap/
  Specification https://github.com/mapbox/utfgrid-spec

  Exposed at http://[...]/layer/z/x/y.grid.json

- MapBox Vector Tiles (for MBTiles generated by [MapBox Studio Classic](https://www.mapbox.com/mapbox-studio-classic/) or by [OSM2VectorTiles](http://osm2vectortiles.org/) project).

  Example http://osm2vectortiles.tileserver.com/
  TileJSON can be used in MapBox Studio Classic, MapBox SDKs/APIs, OpenLayers, etc.

  Exposed at http://[...]/layer/z/x/y.pbf

- Retina / HighDPI routing with 512 tiles
Use @2x suffix in url for JSONs and tiles. For example http://tileserver.maptiler.com/grandcanyon@2x.json

To use the OGC WMTS standard, point your client (desktop or web) to the URL of 'directory' where you installed tileserver.php project with suffix "wmts".
For example: http://www.example.com/directory/wmts

If you have installed the project into a root directory of a domain, then the address is: http://www.example.com/wmts

The supported WMTS requests includes:

GetCapabilities RESTful/KVP:

   http://[...]/1.0.0/WMTSCapabilities.xml
   http://[...]?service=wmts&request=getcapabilities&version=1.0.0

GetTile RESTful/KVP:

   http://[...]/layer/[ANYTHING-OPTIONAL][z]/[x]/[y].[ext]
   http://[...]?service=wmts&request=getTile&layer=[layer]&tilematrix=[z]&tilerow=[y]&tilecol=[y]&format=[ext]

Other example requests are mentioned in the .htaccess.

TileServer-PHP supports all coordinates systems. You have to define it with tilejson with specification on https://github.com/klokantech/tilejson-spec/tree/custom-projection/2.2.0
Or use MapTiler to produce datasets with this specification.

Performance from the web clients
--------------------------------

It is highly recommended to map several domain names to the service, such as:

http://a.example.com/, http://b.example.com/, http://c.example.com/.

This can be done with DNS CNAME records pointing to your hosting. The reason for this is that traditionally browsers will not send more than two simultaneous HTTP requests to the same domain - with multiple domains for the same server, you can better saturate the network and receive the maps faster.

Performance
-----------

In case the data are available in the form of a directory with XYZ tiles, then the Apache webserver is serving these files directly as WMTS RESTful or KVP.

This means performance is excellent, maps are delivered very fast, and a large number of concurrent visitors can be handled even with quite low-end hardware or cheap/free web hosting providers.

Mod_rewrite rules are utilized to ensure the HTTP requests defined in the OCG WMTS standard are served, and Apache preserves standard caching headers & eTag.

The performance should be significantly better than any other tile caching project (such as TileCache.org or GeoWebCache).

Performance graph for "apache static" comparing other tile caching projects is available online at http://code.google.com/p/mod-geocache/wiki/PreliminaryBenchmark

Limits of actual implementation
-------------------------------

With intention, at this moment, the project supports only:
- We enforce and require XYZ (top-left origin) tiling schema (even for TMS).

Password protection
-------------------

HTTP Simple Authentication can be easily added to the server.
Edit the .htaccess and add these lines:

    AuthUserFile /full/path/to/.htpasswd
    AuthType Basic
    AuthName "Secure WMTS"
    Require valid-user

Create a file called .htpasswd with user:password format.
You can use a command-line utility:

$ htpasswd -c .htpasswd [your-user-login]

Or an online service:

http://www.htaccesstools.com/htpasswd-generator/

HTTPS / SSL support
-------------------

TileServer.php can run without any problems over HTTPS, if required.

Microsoft Windows web-hosting
-----------------------------

The TileServer.php should run on Windows-powered webservers with Apache installation if PHP 5.2+ and mod_rewrite are available.

With the IIS webserver hosting, you may need PHP and IIRF module (http://iirf.codeplex.com/) and alter appropriately the rewrite rules.

Credits / Contributors
----------------------

Project developed initially by Klokan Technologies GmbH, Switzerland, in cooperation with National Oceanic and Atmospheric Administration - NOAA, USA.

- Petr Pridal - Klokan Technologies GmbH <petr.pridal@maptiler.com>
- Jason Woolard - NOAA <jason.woolard@noaa.gov>
- Jon Sellars - NOAA <jon.sellars@noaa.gov>
- Dalibor Janak - Klokan Technologies GmbH <dalibor.janak@maptiler.com>

Tested WMTS/TMS clients
-----------------------

- QuantumGIS Desktop 1.9+ - open with Layer->Add WMS layer
  http://www.qgis.org/
- ESRI ArcGIS Desktop 10.1+ - native WMTS implementation supported
  http://www.esri.com/software/arcgis/arcgis-for-desktop
- ESRI ArcGIS Online - loading via WMTS protocol
  http://www.arcgis.com/
- ArcBruTiles plugin for ArcGIS 9.3+ - via TMS endpoint
  http://arcbrutile.codeplex.com/
- OpenLayers WMTS Layer - including parsing GetCapabilities
  http://www.openlayers.org/
- GAIA - native WMTS (issues with 3857 to be fixed)
  http://www.thecarbonproject.com/gaia.php
- MapBox.js - the loading of maps via TileJSON, interaction layer supported
  https://www.mapbox.com/mapbox.js

Alternative
-----------

If you need [map server with commercial support](https://www.maptiler.com/server/), explore the possibilities provided by the MapTiler Server.

BSD License
-----------

Copyright (C) 2020 MapTiler AG (https://www.maptiler.com/)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
