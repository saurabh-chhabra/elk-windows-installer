@echo off
rem ---------- tools
SET CURL=tools\curl\bin\curl.exe
SET NSIS=tools\nsis\makensis.exe
SET NSSM=tools\nssm\win64\nssm.exe
SET ZIP=tools\7zip\7za.exe

rem ---------- components versions
SET ELASTIC_SEARCH_VERSION=2.3.3
SET LOGSTASH_VERSION=2.3.2
SET KIBANA_VERSION=4.5.1

rem ---------- installer version
SET INSTALLER_VERSION=1.0.0
IF DEFINED APPVEYOR_BUILD_VERSION SET INSTALLER_VERSION=%APPVEYOR_BUILD_VERSION%
echo "Building installer v%INSTALLER_VERSION%"

rem ---------- Download packages ----------
if not exist "downloads" mkdir downloads

if not exist "downloads\elasticsearch-%ELASTIC_SEARCH_VERSION%.zip" %CURL% "https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/%ELASTIC_SEARCH_VERSION%/elasticsearch-%ELASTIC_SEARCH_VERSION%.zip" -o downloads\elasticsearch-%ELASTIC_SEARCH_VERSION%.zip
if not exist "downloads\logstash-%LOGSTASH_VERSION%.zip" %CURL% "https://download.elastic.co/logstash/logstash/logstash-%LOGSTASH_VERSION%.zip" -o downloads\logstash-%LOGSTASH_VERSION%.zip
if not exist "downloads\kibana-%KIBANA_VERSION%.zip" %CURL% "https://download.elastic.co/kibana/kibana/kibana-%KIBANA_VERSION%-windows.zip" -o downloads\kibana-%KIBANA_VERSION%.zip
rem --------------------------------------

rem ---------- Unzip packages ----------
rmdir /Q /S temp
mkdir temp

%ZIP% x -otemp downloads\elasticsearch-%ELASTIC_SEARCH_VERSION%.zip
%ZIP% x -otemp downloads\logstash-%LOGSTASH_VERSION%.zip
%ZIP% x -otemp downloads\kibana-%KIBANA_VERSION%.zip

move temp\elasticsearch-%ELASTIC_SEARCH_VERSION% temp\elasticsearch
move temp\logstash-%LOGSTASH_VERSION% temp\logstash
move temp\kibana-%KIBANA_VERSION%-windows temp\kibana
rem ------------------------------------

rem ---------- Run makensis ----------
if not exist "dist" mkdir dist
%NSIS% /Dversion="%INSTALLER_VERSION%" elk.nsi
