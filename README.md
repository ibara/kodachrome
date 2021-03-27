Kodachrome
==========
`Kodachrome` is a simple screenshot utility written in D. Screenshots are
output in PNG format.

Dependencies
------------
You will need the X11 and PNG libraries.

Usage
-----
```
$ kodachrome [-d seconds] [name]
```
Where `seconds` is the number of seconds to delay before taking the
screenshot (default: 3) and `name` is the name of the output file. If no
`name` is given, then `Clock.currTime().toISOString()` is used to generate
the output file name. In all cases, the `.png` extension is automatically
added.

Caveats
-------
LSB architectures only. That will change soon.

`Kodachrome` is tested on [OpenBSD](https://www.openbsd.org/)/amd64. It
will probably work on all Posix systems. Windows support is planned.

License
-------
ISC license. See `LICENSE` for more details.
