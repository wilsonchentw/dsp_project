#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import sys
import random
import shutil
import itertools

v = 10
rootpath = os.path.join(os.getcwd(),  sys.argv[1])
trainpath = os.path.join(os.getcwd(), sys.argv[2])
testpath = os.path.join(os.getcwd(),  sys.argv[3])

def chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i+n]

# Clean old training set and test set
if os.path.isdir(trainpath): shutil.rmtree(trainpath)
if os.path.isdir(testpath): shutil.rmtree(testpath)
os.mkdir(trainpath), os.mkdir(testpath)

for dirpath, dirnames, filenames in os.walk(rootpath):
    # Copy each directory
    for dirname in dirnames:
        src = os.path.join(dirpath, dirname)
        os.mkdir(src.replace(rootpath, trainpath, 1))
        os.mkdir(src.replace(rootpath, testpath, 1))

    # random shuffle filelist
    if len(filenames)/v<=0: continue
    random.shuffle(filenames)
    partitions = list(chunks(filenames, len(filenames) // v))

    # Random choose a fold to generate testSet and trainSet
    r = random.randrange(1,v,1)
    trainSet = list(itertools.chain.from_iterable(partitions[:r]+partitions[(r+1):]))
    testSet = partitions[r]

    #print(dirpath)
    for filename in trainSet:
        src = os.path.join(dirpath, filename)
        dst = src.replace(rootpath, trainpath, 1)
        shutil.copy2(src, dst)
    for filename in testSet:
        src = os.path.join(dirpath, filename)
        dst = src.replace(rootpath, testpath, 1)
        shutil.copy2(src, dst)
