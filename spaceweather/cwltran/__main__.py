import argparse
from pathlib import Path

from . import Processor
from .IMPORT import IMPORT
from .scatter import Scatter
from .templating import Templater, read_template

parser = argparse.ArgumentParser()
parser.add_argument("source")
parser.add_argument("dest")

def boolopt(parser, name, default=True):
    grp = parser.add_mutually_exclusive_group()
    grp.add_argument(f"--{name}", action="store_true", default=default)
    grp.add_argument(f"--no-{name}", dest=name, action="store_false", default=default)

boolopt(parser, "IMPORT")
boolopt(parser, "scatter")
parser.add_argument("--template", "-t", action="append", default=[])

args = parser.parse_args()

source = Path(args.source)
passes = []

if args.IMPORT:
    passes.append(IMPORT(source.parent))

if args.template:
    tdecls = []
    for t in args.template:
        tdecls.extend(read_template(t))
    passes.append(Templater(tdecls))

if args.scatter:
    passes.append(Scatter())

proc = Processor(passes)
proc(args.source, args.dest)
