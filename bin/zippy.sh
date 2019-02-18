#!/bin/bash

# make sure we create any archives we might need

pushd  docs/files
zip classy.zip classy_lu* classy.pro
tar cvzf classy.tar.Z classy_lu* classy.pro
tar cvf classy.tar classy_lu* classy.pro
zip UrbanModel.zip Guangdong-Yearbook-2019.csv model-2019.csv results-2019.csv UrbanModelData.R UrbanModel.R 

# copy files to UCL repo
scp classy.zip  classy.tar.Z classy.tar UrbanModel.zip triangle.geog.ucl.ac.uk://home/plewis/public_html/GEOG0027

popd

