for /r %%i in (*.tta) do (
	ffmpeg -i "%%i" -c:a flac -compression_level 12 "%%~dpni.flac"
)