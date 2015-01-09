#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import random
from os import getcwd, listdir
from os.path import isfile, join

v = 10
rootpath = join(getcwd(), sys.argv[1])
trainfile = open(sys.argv[2], mode='w')
testfile = open(sys.argv[3], mode='w')
for idx, label in enumerate(listdir(rootpath)):
    dirpath = join(rootpath, label)
    filelist = [ f for f in listdir(dirpath) if isfile(join(dirpath, f)) ]
    random.shuffle(filelist)
    test_sample = filelist[0:len(filelist):v]
    train_sample = [f for f in filelist if f not in test_sample]
    for f in test_sample: print(join(label, f) + " " + str(idx), file=testfile)
    for f in train_sample: print(join(label, f) + " " + str(idx), file=trainfile)
