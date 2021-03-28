import std.stdio;
import std.getopt;
import std.datetime;
import core.thread;
import kodachrome.x;

void main(string[] args)
{
    int delayFlag = 3;
    string fileName;

    auto Option = getopt(args, "delay|d", &delayFlag);

    /+ Reasons to show the user some help +/
    if (Option.helpWanted || args.length > 2) {
        stderr.writeln("usage: kodachrome [-d seconds] [name]");
        return;
    }

    Thread.sleep(delayFlag.seconds);

    if (args.length == 2)
        fileName = args[1];
    else
        fileName = Clock.currTime().toISOString();

    auto success = getScreen(fileName);
    if (success == false)
        stderr.writeln("Screenshot failed");
}
