#!/bin/bash

# This Bash script downloads shapefiles from GADM v3.6 into the
# data/shapefiles/ directory.
#
# Run this script from within the preprocessing/ directory.
#
# Prerequisites: None.

mkdir -p ../data/shapefiles
cd ../data/shapefiles

lmic_country_codes=(
    "AFG"  # Afghanistan
    "ALB"  # Albania
    "AGO"  # Angola
    "ARM"  # Armenia
    "AZE"  # Azerbaijan
    "BGD"  # Bangladesh
    "BEN"  # Benin
    "BOL"  # Bolivia
    "BWA"  # Botswana
    "BRA"  # Brazil
    "BFA"  # Burkina Faso
    "BDI"  # Burundi
    "KHM"  # Cambodia
    "CMR"  # Cameroon
    "CPV"  # Cape Verde
    "CAF"  # Central African Republic
    "TCD"  # Chad
    "COL"  # Colombia
    "COM"  # Comoros
    "COG"  # Congo
    "COD"  # Congo Democratic Republic
    "CIV"  # Cote d'Ivoire
    "DOM"  # Dominican Republic
    "ECU"  # Ecuador
    "EGY"  # Egypt
    "SLV"  # El Salvador
    "GNQ"  # Equatorial Guinea
    "ERI"  # Eritrea
    "ETH"  # Ethiopia
    "GAB"  # Gabon
    "GMB"  # Gambia
    "GHA"  # Ghana
    "GTM"  # Guatemala
    "GIN"  # Guinea
    "GUY"  # Guyana
    "HTI"  # Haiti
    "HND"  # Honduras
    "IND"  # India
    "IDN"  # Indonesia
    "JOR"  # Jordan
    "KAZ"  # Kazakhstan
    "KEN"  # Kenya
    "KGZ"  # Kyrgyz Republic
    "LAO"  # Lao People's Democratic Republic
    "LSO"  # Lesotho
    "LBR"  # Liberia
    "MDG"  # Madagascar
    "MWI"  # Malawi
    "MDV"  # Maldives
    "MLI"  # Mali
    "MRT"  # Mauritania
    "MEX"  # Mexico
    "MDA"  # Moldova
    "MAR"  # Morocco
    "MOZ"  # Mozambique
    "MMR"  # Myanmar
    "NAM"  # Namibia
    "NPL"  # Nepal
    "NIC"  # Nicaragua
    "NER"  # Niger
    "NGA"  # Nigeria
    # Nigeria (Ondo State)
    "PAK"  # Pakistan
    "PRY"  # Paraguay
    "PER"  # Peru
    "PHL"  # Philippines
    "RWA"  # Rwanda
    "WSM"  # Samoa
    "STP"  # Sao Tome and Principe
    "SEN"  # Senegal
    "SLE"  # Sierra Leone
    "ZAF"  # South Africa
    "LKA"  # Sri Lanka
    "SDN"  # Sudan
    "SWZ"  # Swaziland
    "TJK"  # Tajikistan
    "TZA"  # Tanzania
    "THA"  # Thailand
    "TLS"  # Timor-Leste
    "TGO"  # Togo
    "TTO"  # Trinidad and Tobago
    "TUN"  # Tunisia
    "TUR"  # Turkey
    "TKM"  # Turkmenistan
    "UGA"  # Uganda
    "UKR"  # Ukraine
    "UZB"  # Uzbekistan
    "VNM"  # Vietnam
    "YEM"  # Yemen
    "ZMB"  # Zambia
    "ZWE"  # Zimbabwe
)
# ** indicates a territory that is only included for map-plotting purposes
#    but was otherwise not considered in this paper

dhs_country_codes=(
    "ALB"  # Albania
    "AGO"  # Angola
    "ARM"  # Armenia
    "BGD"  # Bangladesh
    "BEN"  # Benin
    "BOL"  # Bolivia
    "BFA"  # Burkina Faso
    "BDI"  # Burundi
    "KHM"  # Cambodia
    "CMR"  # Cameroon
    "TCD"  # Chad
    "COD"  # Congo Democratic Republic
    "CIV"  # Cote d'Ivoire
    "DOM"  # Dominican Republic
    "EGY"  # Egypt
    "ETH"  # Ethiopia
    "GAB"  # Gabon
    "GHA"  # Ghana
    "GTM"  # Guatemala
    "GIN"  # Guinea
    "GUY"  # Guyana
    "HTI"  # Haiti
    "IND"  # India
    "IDN"  # Indonesia
    "JOR"  # Jordan
    "KEN"  # Kenya
    "KGZ"  # Kyrgyz Republic
    "LSO"  # Lesotho
    "LBR"  # Liberia
    "MDG"  # Madagascar
    "MWI"  # Malawi
    "MLI"  # Mali
    "MDA"  # Moldova
    "MAR"  # Morocco
    "MOZ"  # Mozambique
    "MMR"  # Myanmar
    "NAM"  # Namibia
    "NPL"  # Nepal
    "NGA"  # Nigeria
    "PAK"  # Pakistan
    "PER"  # Peru
    "PHL"  # Philippines
    "RWA"  # Rwanda
    "SEN"  # Senegal
    "SLE"  # Sierra Leone
    "SWZ"  # Swaziland
    "TJK"  # Tajikistan
    "TZA"  # Tanzania
    "TLS"  # Timor-Leste
    "TGO"  # Togo
    "UGA"  # Uganda
    "ZMB"  # Zambia
    "ZWE"  # Zimbabwe
)

for code in ${lmic_country_codes[@]}
do
    echo "Getting shapefiles for ${code}"

    # download ZIP'ed shapefiles from GADM v3.6
    wget --no-verbose --show-progress "https://biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_${code}_shp.zip"

    # for all African countries, unzip shapefiles for level-0 administrative
    #   regions (country-level), overwriting existing files
    unzip -o "gadm36_${code}_shp.zip" *_0.* -d "gadm36_${code}_shp"

    # for DHS countries, unzip shapefiles for level-2 administrative regions
    #   (district-level), overwriting existing files
    if [[ " ${dhs_country_codes[@]} " =~ " ${code} " ]]
    then
        unzip -o "gadm36_${code}_shp.zip" *_2.* -d "gadm36_${code}_shp"

        # if no level-2 admin regions exist, then try unzipping level-1
        # - this should only apply to Lesotho (LSO)
        #   and also Armenia (ARM) and Moldova (MDA) for LMIC
        if [ ! -f "./gadm36_${code}_shp/gadm36_${code}_2.shp" ]
        then
            echo "- No level-2 admin shapefile exists. Trying level-1."
            unzip -o "gadm36_${code}_shp.zip" *_1.* -d "gadm36_${code}_shp"
        fi
    fi

    # delete the zip file
    rm "gadm36_${code}_shp.zip"
done