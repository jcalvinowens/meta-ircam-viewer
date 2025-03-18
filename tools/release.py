#!/usr/bin/env python3

import datetime
import subprocess
import sys
import time
import yaml

def represent_none(self, _):
	return self.represent_scalar('tag:yaml.org,2002:null', '')

yaml.representer.SafeRepresenter.add_representer(type(None), represent_none)

def dmerge(d1, d2):
	for k in d2:
		if k in d1 and \
		isinstance(d1[k], dict) and \
		isinstance(d2[k], dict):
			dmerge(d1[k], d2[k])
			continue

		d1[k] = d2[k]

	return d1

d = {}

for path in sys.argv[1:]:
	with open(path, "rb") as f:
		d = dmerge(d, yaml.safe_load(f.read()))

if len(d) == 0:
	print("Usage: ./release.py kas/base.yml kas/include/noconsole.yml")
	sys.exit(1)

for path in d.get("header", {}).get("includes", []):
	with open(path, "rb") as f:
		d = dmerge(d, yaml.safe_load(f.read()))

for name, dd in d.get("repos", {}).items():
	if name == "meta-ircam-viewer":
		continue

	s = subprocess.check_output(["git", "ls-remote", dd["url"], "HEAD"])
	for ref in s.split(b'\n'):
		if ref.endswith(b'\tHEAD'):
			sha = ref.split(b'\t')[0]
			dd["commit"] = sha.decode("ascii", "ignore")
			del dd["branch"]

ts = int(time.time())
if "includes" in d["header"]:
	del d["header"]["includes"]
d["local_conf_header"]["reproducible"] = f"""
BUILD_REPRODUCIBLE_BINARIES = "1"
REPRODUCIBLE_TIMESTAMP_ROOTFS = "{ts}"
SOURCE_DATE_EPOCH = "{ts}"
"""

tsstr = datetime.datetime.fromtimestamp(ts, datetime.timezone.utc).isoformat()
print(f"# RELEASE BUILD TIMESTAMP: {tsstr}", end="\n\n")
print(yaml.safe_dump(d, default_flow_style=False, sort_keys=False), end='')
