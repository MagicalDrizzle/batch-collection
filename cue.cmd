for /f "usebackq delims=" %%i in (`dir /a-d /b /s *_ogg.cue ^| busybox64u sed "s/\\/\//g"`) do (  
	busybox64u sed -i "s/\.flac\"/\.ogg\"/g" "%%i"
)
pause