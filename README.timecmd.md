`timecmd.cmd`: A `time` clone for Windows.
Not actually my creation, see https://stackoverflow.com/a/6209392
This file will measure the time it takes to complete a command. Just put `timecmd.cmd` before your command.
Example: 
```
>timecmd tree /F
Folder PATH listing for volume Mizuki
Volume serial number is D18C-3AF0
C:.
    just-domains.cmd
    LICENSE
    README.just-domains.md
    README.md
    README.rexplorer.md
    README.test-pngs.md
    README.timerun.md
    README.unique-lines.md
    rexplorer.cmd
    test-pngs.cmd
    timecmd.cmd
    unique-lines.cmd

No subfolders exist

command took 0:0:0.02 (0.02s total)
```