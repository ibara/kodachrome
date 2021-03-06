module kodachrome.png;
import std.stdio;
import std.algorithm.mutation;
import std.string;
import x11.X;
import x11.Xlib;
import kodachrome.x;

/+
 + This part needs to be spun off into its own library.
 +/
extern(C):
alias png_byte = char;
alias png_bytep = png_byte*;
alias png_const_bytep = const(png_byte)*;

alias png_charp = char*;
alias png_const_charp = const(char)*;
alias png_voidp = void*;

struct png_struct;
alias png_structp = png_struct*;
alias png_structpp = png_struct**;
alias png_structrp = png_structp;
alias png_const_structp = const(png_struct)*;
alias png_const_structrp = png_const_structp;

struct png_info;
alias png_infop = png_info*;
alias png_infopp = png_info**;
alias png_inforp = png_infop;
alias png_const_infop = const(png_info)*;
alias png_const_inforp = png_const_infop;

png_infop png_create_info_struct(png_const_structrp);

alias png_error_ptr = void function(png_structp, png_const_charp);

void png_destroy_write_struct(png_structpp, png_infopp);

enum PNG_LIBPNG_VER_STRING = "1.6.37";

png_structp png_create_write_struct(png_const_charp, png_voidp,
    png_error_ptr, png_error_ptr);

alias png_FILE_p = FILE*;

void png_init_io(png_structrp, png_FILE_p);

void png_set_IHDR(png_const_structrp, png_inforp, png_uint_32, png_uint_32,
    int, int, int, int, int);

alias png_uint_32 = uint;

struct png_text
{
    int compression;
    png_charp key;
    png_charp text;
    size_t text_length;
    size_t itxt_length;
    png_charp lang;
    png_charp lang_key;
}

alias png_const_textp = const(png_text)*;

void png_set_text(png_const_structrp, png_inforp, png_const_textp, int);

void png_write_info(png_structrp, png_const_inforp);

void png_write_row(png_structrp, png_const_bytep);

void png_write_end(png_structrp, png_inforp);

void png_free_data(png_const_structrp, png_inforp, png_uint_32, int);

enum PNG_COLOR_MASK_COLOR = 2;
enum PNG_COLOR_MASK_ALPHA = 4;
enum PNG_COLOR_TYPE_RGB_ALPHA = PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_ALPHA;

enum PNG_INTERLACE_NONE = 0;

enum PNG_COMPRESSION_TYPE_BASE = 0;

enum PNG_FILTER_TYPE_BASE = 0;

enum PNG_TEXT_COMPRESSION_NONE = -1;

enum PNG_FREE_ALL = 0xffffU;

/+
 + This stays.
 +/
extern(D):
bool createPNG(string name, XImage* ximg)
{
    png_text title_text;

    png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING,
        null, null, null);
    if (png_ptr == null) {
        stderr.writeln("kodachrome: Could not create PNG write struct");
        return false;
    }

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (info_ptr == null) {
        stderr.writeln("kodachrome: Could not create PNG info struct");
        png_destroy_write_struct(&png_ptr, null);
        return false;
    }

    string nameWithExt = name ~ ".png";
    File f = File(nameWithExt, "w");

    png_init_io(png_ptr, f.getFP());

    png_set_IHDR(png_ptr, info_ptr, ximg.width, ximg.height, 8,
        PNG_COLOR_TYPE_RGB_ALPHA, PNG_INTERLACE_NONE,
        PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

    title_text.compression = PNG_TEXT_COMPRESSION_NONE;
    title_text.key = cast(char*)toStringz("Title");
    title_text.text = cast(char*)toStringz(name);
    png_set_text(png_ptr, info_ptr, &title_text, 1);

    png_write_info(png_ptr, info_ptr);

    char* row = ximg.data;
    for (int i = 0; i < ximg.height; i++) {
        if (ximg.bitmap_bit_order == LSBFirst) {
            for (int idx = 0; idx < ximg.chars_per_line; idx += 4) {
                swap(row[idx], row[idx + 2]);
                row[idx + 3] = 255;
            }
        } else {
            for (int idx = 0; idx < ximg.chars_per_line; idx += 4) {
                ubyte t1 = row[idx + 1];
                ubyte t2 = row[idx + 2];
                ubyte t3 = row[idx + 3];

                row[idx] = t1;
                row[idx + 1] = t2;
                row[idx + 2] = t3;
                row[idx + 3] = 255;
            }
        }

        png_write_row(png_ptr, row);
        row += ximg.chars_per_line;
    }
    png_write_end(png_ptr, null);

    f.close();

    png_free_data(png_ptr, info_ptr, PNG_FREE_ALL, -1);
    png_destroy_write_struct(&png_ptr, null);

    return true;
}
