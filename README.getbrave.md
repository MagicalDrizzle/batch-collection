`getbrave.cmd`: Download standalone Brave binaries (Windows x64) for you. Supports Release, Beta and Nightly channels.  
This script is meant to be used to update Brave Portable: https://github.com/portapps/brave-portable.  
Create a `updater` directory in the same directory as `brave-portable.exe`, and put `getbrave.cmd` and `busybox.exe` into it (if `busybox` is not on `PATH`).  
```
├── app  
├── brave-portable.exe  
└── updater  
    ├── busybox.exe  
    └── getbrave.cmd
```  
Requires:  
- [BusyBox](https://frippery.org/files/busybox/busybox.exe) (you can find-and-replace the `busybox wget` part to any downloader you want).  
