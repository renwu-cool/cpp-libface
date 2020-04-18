#!/usr/bin/env python

from os.path import dirname,abspath,join
from tests.name import gen_two_words
from random import randint

ROOT = join(dirname(abspath(__file__)),"server")
with open(join(ROOT,"name.tsv"),"w") as f:
    for i in range(99999):
        f.write(f"{randint(1, 1+i)}\t{gen_two_words()}\t{gen_two_words()}\n")


with open(join(ROOT,"id.tsv"),"w") as f:
    for i in range(99999):
        f.write(f"{randint(1, 1+i)}\t{gen_two_words()}\t{randint(1,10)}\n")
