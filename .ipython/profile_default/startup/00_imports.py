#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import os.path as path
import re
import pprint
import gzip
try:
    import cPickle as pickle
except ImportError:
    import  pickle
import numpy as np
import scipy as sp
import networkx as nx

def upp(obj):
    printer = pprint.PrettyPrinter()
    str_ = printer.pformat(obj)
    str_ = re.sub(
        r"\\u([0-9a-f]{4})", lambda x: unichr(int("0x"+x.group(1), 16)), str_
    )
    return str_
