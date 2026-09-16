# Isolate local SDK caches in the workspace without changing global settings.
$env:APPDATA=Join-Path $PSScriptRoot '../.toolchains/flutter-state'
$env:LOCALAPPDATA=$env:APPDATA
$env:PUB_CACHE=Join-Path $PSScriptRoot '../.toolchains/pub-cache'
$env:FLUTTER_SUPPRESS_ANALYTICS='true'
$flutterPath=Join-Path $PSScriptRoot '../.toolchains/flutter/bin/flutter.bat'
& $flutterPath @args
exit $LASTEXITCODE
