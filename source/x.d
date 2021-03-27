module kodachrome.x;
import std.stdio;
import x11.X;
import x11.Xlib;
import x11.Xutil;
import kodachrome.png;

bool getScreen(string name)
{
    XWindowAttributes xattr;

    Display* disp = XOpenDisplay(null);
    if (disp == null) {
        stderr.writeln("kodachrome: Could not open X Display");
        return false;
    }
    Window wind = DefaultRootWindow(disp);
    XGetWindowAttributes(disp, wind, &xattr);
    XImage* ximg = XGetImage(disp, wind, 0, 0, xattr.width, xattr.height,
                            AllPlanes, ZPixmap);
    createPNG(name, ximg);

    XDestroyImage(ximg);
    XCloseDisplay(disp);

    return true;
}
