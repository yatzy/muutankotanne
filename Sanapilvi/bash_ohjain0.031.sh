#!/bin/bash

# FIRST: declare luettava = 'polku_tekstitiedostoon'

rivittaja="/home/yatzy/Dropbox/opiskelu/Tekstinlouhinta/Hurmio/r_poista_erikoismerkit_ja_rivita.R"

# luetaan R:ään

echo '!!!!!!!!!!! R aloittaa !!!!!!!!!!! '
Rscript --vanilla $rivittaja $luettava

#
echo '!!!!!!!!!!! Malaga aloittaa !!!!!!!!!!! '
tiedosto_malagalle="${luettava}_rout.txt"
echo 'Malaga lukee tiedoston tiedostosta'
echo 'Malaga lukee tiedoston paikasta' $tiedosto_malagalle

#malaga_luettava=$(<$tiedosto_malagalle)

#teksti_malagalle=$(cat $tiedosto_malagalle)

malaga_perusosa="${tiedosto_malagalle%.*}"
malaga_ulos="${malaga_perusosa}_mout.txt"

echo '##################'
echo $malaga_ulos
echo '##################'

echo $teksti_malagalle
#cat $teksti_malagalle | malaga -i /home/yatzy/Applications/suomi-malaga-1.13/sukija/#suomi.pro

# TÄMÄ TOIMIII!!!!!

cat $tiedosto_malagalle |  malaga suomi.pro -m > $malaga_ulos


echo 'Malaga valmis'
