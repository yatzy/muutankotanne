#!/bin/bash

#
# Uses wget to get data from different interfaces 
#

echo 'Gettin data from: Helsinki Palvelukartta REST-API'
wget -q -O palvelukartta_toimipisteet.xml http://www.hel.fi/palvelukarttaws/rest/v2/unit/?format=xml

wget -q -O palvelukartta_palvelut.xml http://www.hel.fi/palvelukarttaws/rest/v2/service/?format=xml
