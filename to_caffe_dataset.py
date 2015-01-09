#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import os
import shutil

root = sys.argv[1]
filelist = sys.argv[2]

rootpath = os.path.join(os.getcwd(), root)
caffe_data = open(filelist, mode='w')
for idx, label in enumerate(os.listdir(rootpath)):
    for filename in os.listdir(os.path.join(rootpath, label)):
        imgpath = os.path.join(label, filename)
        #os.system("convert " + imgpath + " -resize 256x256! " + imgpath)
        print(imgpath + " " + str(idx), file=caffe_data)
        
