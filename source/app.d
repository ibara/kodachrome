import std.stdio;
import std.getopt;
import std.datetime;
import core.thread;
import x11.Xlib;
import kodachrome.x;

static void badexit()
{
    import core.stdc.stdlib: exit;

    exit(1);
}

static void usage()
{
    stderr.writeln("usage: kodachrome [-d seconds] [name]");
    badexit();
}

void main(string[] args)
{
    int delayFlag = 3;
    string fileName;

    auto Option = getopt(args, "delay|d", &delayFlag);

    if (Option.helpWanted)
        usage();

    /+ Optional [name] argument +/
    if (args.length > 2)
        usage();

    Thread.sleep(delayFlag.seconds);

    if (args.length == 2)
        fileName = args[1];
    else
        fileName = Clock.currTime().toISOString();

    auto success = getScreen(fileName);
    if (success == false) {
        stderr.writeln("Screenshot failed");
        badexit();
    }
}
