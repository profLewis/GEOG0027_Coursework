#!/usr/bin/env python
###############################################################################
# for all of the  tar files in the pattern dirname
# extract the files from them 

import gdal # Import GDAL library bindings
from glob import glob
import os
import sys
import tempfile
import shutil
import tarfile
import ogr, os, osr
import numpy as np


def uncompress_ls(dirname,temp_dir='temp'):
  filelist = []
  if temp_dir:
    if not os.path.exists(temp_dir):
      os.makedirs(temp_dir)

  for tar_name in glob(dirname):
    print (tar_name)
    # compressed file -- uncompress to tmp directory
    tar_path = os.path.abspath(tar_name)
    extraction_dir = os.path.join(os.getcwd(), os.path.splitext(tar_name)[0])
    extraction_dir_end = extraction_dir.split('-')[-1]
    extraction_dir = extraction_dir.split('-'+extraction_dir_end)[0]
    print (extraction_dir)
    try:
        os.mkdir(extraction_dir)
    except:
        pass
    temp_dir = temp_dir or tempfile.mkdtemp()
    with tarfile.open(tar_path, 'r') as tar_file:
        thisDict = {}
        def is_within_directory(directory, target):
            
            abs_directory = os.path.abspath(directory)
            abs_target = os.path.abspath(target)
        
            prefix = os.path.commonprefix([abs_directory, abs_target])
            
            return prefix == abs_directory
        
        def safe_extract(tar, path=".", members=None, *, numeric_owner=False):
        
            for member in tar.getmembers():
                member_path = os.path.join(path, member.name)
                if not is_within_directory(path, member_path):
                    raise Exception("Attempted Path Traversal in Tar File")
        
            tar.extractall(path, members, numeric_owner=numeric_owner) 
            
        
        safe_extract(tar_file, temp_dir)
        # Move the extracted xml directory to its final location
        try:
            shutil.move(glob(temp_dir+'/*xml')[0], extraction_dir)
        except:
            pass
        # load the files
        files = np.sort(glob(temp_dir+'/*tif'))
        filelist.append(files)
  return filelist



