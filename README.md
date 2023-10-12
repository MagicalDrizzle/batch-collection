1. `dupe.cmd`: Let you see the unique lines a file has, compared to another file.  
Syntax: `dupe.cmd a.txt b.txt`  
 - `a.txt`: The file you want to see unique lines of.
 - `b.txt`: The file containing lines.  
Example:
 - `a.txt`:
```
1
4
2.2455
cfdfdfd
9
```
 - `b.txt`:
```
3
9
4
12.45
1
```
 - Result:
```
-- a.txt
2.2455
cfdfdfd
```

2. `just-domain.cmd`: Turn a `hosts` file into an website/IP list file.
It basically automates "removes 127.0.0.1 and 0.0.0.0 globally" for you.
