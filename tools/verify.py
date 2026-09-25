#!/usr/bin/env python3
"""Run Flutter checks without treating macOS metadata sidecars as Dart tests."""
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent
os.chdir(ROOT)
env = dict(os.environ, COPYFILE_DISABLE='1')
# Flutter's native asset cleanup can race AppleDouble metadata on external disks.
# Only remove generated metadata in the disposable build output.
assets = ROOT / 'build' / 'native_assets'
if assets.exists():
    for metadata in assets.rglob('._*'):
        if metadata.is_file():
            metadata.unlink(missing_ok=True)
subprocess.run(['flutter', 'analyze'], check=True, env=env)
tests = sorted(str(p.relative_to(ROOT)) for p in (ROOT / 'test').rglob('*_test.dart')
               if not p.name.startswith('._'))
subprocess.run(['flutter', 'test', *tests], check=True, env=env)
