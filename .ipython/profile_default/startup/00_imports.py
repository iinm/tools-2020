#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import re
import pprint
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
