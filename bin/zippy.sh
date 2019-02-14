#!/bin/bash

# make sure we create any archives we might need

pushd  docs/files

zip UrbanModel.zip Guangdong-Yearbook-2019.csv model-2019.csv results-2019.csv UrbanModelData.R UrbanModel.R 

popd

