#!/bin/bash

mkdir repos_dev
mkdir repos
mkdir repos_opencv

# imagebreed dev code
git clone --branch master --depth 1 https://github.com/nickmorales/imagebreed.git  repos_dev/sgn
git clone https://github.com/solgenomics/DroneImageScripts.git repos_dev/DroneImageScripts
git clone https://github.com/nickmorales/imagesol.git repos_dev/imagesol

# core code
git clone --branch topic/metadata_schema_fixes --depth 1 https://github.com/solgenomics/cxgn-corelibs.git repos/cxgn-corelibs
git clone https://github.com/solgenomics/Phenome.git repos/Phenome
git clone https://github.com/solgenomics/rPackages.git repos/rPackages
git clone https://github.com/solgenomics/biosource.git repos/biosource
git clone https://github.com/solgenomics/Cview.git repos/Cview
git clone https://github.com/solgenomics/ITAG.git repos/ITAG
git clone https://github.com/solgenomics/tomato_genome.git repos/tomato_genome
git clone https://github.com/GMOD/Chado.git repos/Chado
git clone https://github.com/GMOD/chado_tools.git repos/chado_tools
git clone https://github.com/solgenomics/sgn-devtools.git repos/sgn-devtools
git clone https://github.com/solgenomics/solGS.git repos/solGS
git clone https://github.com/solgenomics/starmachine.git repos/starmachine
git clone https://github.com/GMOD/Chado repos/Chado
git clone https://github.com/GMOD/chado_tools repos/chado_tools
git clone https://github.com/GMOD/Bio-Chado-Schema repos/Bio-Chado-Schema
git clone https://github.com/solgenomics/Tea.git repos/Tea
git clone https://bitbucket.org/tasseladmin/tassel-5-standalone.git repos/tassel-5-standalone

# local libs
git clone --branch topic/debian_bullseye --depth 1 https://github.com/solgenomics/perl-local-lib repos/local-lib
git clone --branch topic/debian_bullseye_R4.2.0_wASREMLR --depth 1 https://github.com/solgenomics/R_libs repos/R_libs
git clone https://github.com/solgenomics/python_virtual_environment repos/python_virtual_environment

# OpenCV
git clone --branch 4.1.0 --depth 1 https://github.com/opencv/opencv repos_opencv/opencv
git clone --branch 4.1.0 --depth 1 https://github.com/opencv/opencv_contrib repos_opencv/opencv_contrib

# Mason website skins
git clone https://github.com/solgenomics/cassava.git repos/cassava
git clone https://github.com/solgenomics/yambase.git repos/yambase
git clone https://github.com/solgenomics/sweetpotatobase.git repos/sweetpotatobase
git clone https://github.com/solgenomics/ricebase.git repos/ricebase
git clone https://github.com/solgenomics/citrusgreening.git repos/citrusgreening
git clone https://github.com/solgenomics/coconut.git repos/coconut
git clone https://github.com/solgenomics/cassbase.git repos/cassbase
git clone https://github.com/solgenomics/musabase.git repos/musabase
git clone https://github.com/solgenomics/potatobase.git repos/potatobase
git clone https://github.com/solgenomics/cea.git repos/cea
git clone https://github.com/solgenomics/bea.git repos/bea
git clone https://github.com/solgenomics/cippotatobase.git repos/cippotatobase
git clone https://github.com/solgenomics/fernbase.git repos/fernbase
git clone https://github.com/solgenomics/solgenomics.git repos/solgenomics
git clone https://github.com/solgenomics/panzeabase.git repos/panzeabase
git clone https://github.com/solgenomics/varitome.git repos/varitome
git clone https://github.com/solgenomics/milkweed.git repos/milkweed
git clone https://github.com/solgenomics/erysimum.git repos/erysimum
git clone https://github.com/solgenomics/vitisbase.git repos/vitisbase
git clone https://github.com/solgenomics/panandbase.git repos/panandbase
git clone https://github.com/solgenomics/triticum.git repos/triticum
git clone https://github.com/solgenomics/gorelabbase.git repos/gorelabbbase

#Get ImageBreed static content
wget -P public_static_content/imagebreed https://imagebreed.org/static_content/imagebreed/AlfalfaExample35MeterMicasenseAerialDroneFlightRawCaptures.zip
wget -P public_static_content/imagebreed https://imagebreed.org/static_content/imagebreed/ExampleColorAerialDroneFlightRawCaptures.zip
wget -P public_static_content/imagebreed https://imagebreed.org/static_content/imagebreed/RiceExampleRGBandDSMOrthophotosGeoTIFFs.zip
wget -P public_static_content/imagebreed https://imagebreed.org/static_content/imagebreed/AgisoftMicasense10ChannelGrapesOrthomosaic.tif
