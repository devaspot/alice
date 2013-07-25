#include <pango/pango.h>
#include <atk/atk.h>
#include <atk/atk-enum-types.h>
#include <gdk/gdk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <gtk/gtk.h>
#include <gtk/gtkprivate.h>
#include <gtk/gtktree.h>
#include <libgnomecanvas/gnome-canvas.h>
#include <libgnomecanvas/gnome-canvas-bpath.h>
#include "NativeUtils.hh"
#include "NativeGLib.hh"
#include "NativePango.hh"
#include "NativeAtk.hh"
#include "NativeGdk.hh"
#include "NativeGtk.hh"
#include "NativeCanvas.hh"
DEFINE1(Canvas_Pointsnew) {
    DECLARE_INT(a0, x0);
    GnomeCanvasPoints* cres = (GnomeCanvasPoints*)gnome_canvas_points_new(
        (int)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GNOME_TYPE_CANVAS_POINTS);
    RETURN1(res);
} END
DEFINE3(Canvas_Pointsset) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_POINTS);
    DECLARE_INT(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    ((GnomeCanvasPoints*)a0)->coords[a1] = a2;
    RETURN_UNIT;
} END
DEFINE0(Canvas_CanvasPathDefnew) {
    GnomeCanvasPathDef* cres = (GnomeCanvasPathDef*)gnome_canvas_path_def_new(
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE0(Canvas_WidgetgetType) {
    GtkType cres = (GtkType)gnome_canvas_widget_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_TextgetType) {
    GType cres = (GType)gnome_canvas_text_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_PolygongetType) {
    GtkType cres = (GtkType)gnome_canvas_polygon_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_EllipsegetType) {
    GtkType cres = (GtkType)gnome_canvas_ellipse_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_RectgetType) {
    GtkType cres = (GtkType)gnome_canvas_rect_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_RichTextgetType) {
    GtkType cres = (GtkType)gnome_canvas_rich_text_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_PixbufgetType) {
    GtkType cres = (GtkType)gnome_canvas_pixbuf_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_LinegetType) {
    GtkType cres = (GtkType)gnome_canvas_line_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
GnomeCanvasGroup* MK_GnomeCanvasGroupNew (
        GList* item_list
        ) {
    GnomeCanvasGroup* res_ = new GnomeCanvasGroup;
    res_->item_list = item_list;
    return res_;
}
DEFINE1(Canvas_Groupnew) {
    DECLARE_GLIST(a0, x0, DECLARE_OBJECT);
    GnomeCanvasGroup* cres = (GnomeCanvasGroup*)MK_GnomeCanvasGroupNew(
        (GList*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
#define DOgetFieldItemList(O) ((O)->item_list)
#define DOsetFieldItemList(O, V) ((O)->item_list = (V))
DEFINE0(Canvas_GroupgetType) {
    GtkType cres = (GtkType)gnome_canvas_group_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Canvas_Groupadd) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_GROUP);
    DECLARE_INT(a1, x1);
    DECLARE_CSTRING(a2, x2);
    GnomeCanvasItem* cres = (GnomeCanvasItem*)gnome_canvas_item_new(
        (GnomeCanvasGroup*)a0
        ,(GtkType)a1
        ,(const gchar*)a2
        , NULL
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Canvas_GroupnewItem) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_GROUP);
    DECLARE_INT(a1, x1);
    GnomeCanvasItem* cres = (GnomeCanvasItem*)alice_gnome_canvas_item_new(
        (GnomeCanvasGroup*)a0
        ,(GtkType)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Canvas_GroupgetFieldItemList) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_GROUP);
    GList* cres = (GList*)DOgetFieldItemList(
        (GnomeCanvasGroup*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Canvas_GroupsetFieldItemList) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_GROUP);
    DECLARE_GLIST(a1, x1, DECLARE_OBJECT);
    DOsetFieldItemList(
        (GnomeCanvasGroup*)a0
        ,(GList*)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldItemList
#undef DOsetFieldItemList
DEFINE5(Canvas_ItemgetBounds) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_CDOUBLE(tmp0, x1);
               double* a1 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x2);
               double* a2 = (double*)&tmp1;
    DECLARE_CDOUBLE(tmp2, x3);
               double* a3 = (double*)&tmp2;
    DECLARE_CDOUBLE(tmp3, x4);
               double* a4 = (double*)&tmp3;
    gnome_canvas_item_get_bounds(
        (GnomeCanvasItem*)a0
        ,(double*)a1
        ,(double*)a2
        ,(double*)a3
        ,(double*)a4
        );
    word r1 = Real::New(*a1)->ToWord ();
    word r2 = Real::New(*a2)->ToWord ();
    word r3 = Real::New(*a3)->ToWord ();
    word r4 = Real::New(*a4)->ToWord ();
    RETURN4(r1,r2,r3,r4);
} END
DEFINE1(Canvas_ItemgrabFocus) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    gnome_canvas_item_grab_focus(
        (GnomeCanvasItem*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_Itemreparent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GNOME_TYPE_CANVAS_GROUP);
    gnome_canvas_item_reparent(
        (GnomeCanvasItem*)a0
        ,(GnomeCanvasGroup*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_Itemi2cAffine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    double a1[6]; // FIXME
    gnome_canvas_item_i2c_affine(
        (GnomeCanvasItem*)a0
        ,(double*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_Itemi2wAffine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    double a1[6]; // FIXME
    gnome_canvas_item_i2w_affine(
        (GnomeCanvasItem*)a0
        ,(double*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Canvas_Itemi2w) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_CDOUBLE(tmp0, x1);
               double* a1 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x2);
               double* a2 = (double*)&tmp1;
    gnome_canvas_item_i2w(
        (GnomeCanvasItem*)a0
        ,(double*)a1
        ,(double*)a2
        );
    word r1 = Real::New(*a1)->ToWord ();
    word r2 = Real::New(*a2)->ToWord ();
    RETURN2(r1,r2);
} END
DEFINE3(Canvas_Itemw2i) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_CDOUBLE(tmp0, x1);
               double* a1 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x2);
               double* a2 = (double*)&tmp1;
    gnome_canvas_item_w2i(
        (GnomeCanvasItem*)a0
        ,(double*)a1
        ,(double*)a2
        );
    word r1 = Real::New(*a1)->ToWord ();
    word r2 = Real::New(*a2)->ToWord ();
    RETURN2(r1,r2);
} END
DEFINE1(Canvas_Itemhide) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    gnome_canvas_item_hide(
        (GnomeCanvasItem*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Canvas_Itemshow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    gnome_canvas_item_show(
        (GnomeCanvasItem*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Canvas_ItemlowerToBottom) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    gnome_canvas_item_lower_to_bottom(
        (GnomeCanvasItem*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Canvas_ItemraiseToTop) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    gnome_canvas_item_raise_to_top(
        (GnomeCanvasItem*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_ItemlowerWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_INT(a1, x1);
    gnome_canvas_item_lower(
        (GnomeCanvasItem*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_ItemraiseWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_INT(a1, x1);
    gnome_canvas_item_raise(
        (GnomeCanvasItem*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_ItemaffineAbsolute) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    double a1[6]; // FIXME
    gnome_canvas_item_affine_absolute(
        (GnomeCanvasItem*)a0
        ,(const double*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_ItemaffineRelative) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    double a1[6]; // FIXME
    gnome_canvas_item_affine_relative(
        (GnomeCanvasItem*)a0
        ,(const double*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Canvas_Itemmove) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    gnome_canvas_item_move(
        (GnomeCanvasItem*)a0
        ,(double)a1
        ,(double)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_Itemset) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS_ITEM);
    DECLARE_CSTRING(a1, x1);
    gnome_canvas_item_set(
        (GnomeCanvasItem*)a0
        ,(const gchar*)a1
        , NULL
        );
    RETURN_UNIT;
} END
DEFINE0(Canvas_ItemgetType) {
    GtkType cres = (GtkType)gnome_canvas_item_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Canvas_GnomenewAa) {
    GtkWidget* cres = (GtkWidget*)gnome_canvas_new_aa(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_GTK_OBJECT);
    RETURN1(res);
} END
DEFINE0(Canvas_Gnomenew) {
    GtkWidget* cres = (GtkWidget*)gnome_canvas_new(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_GTK_OBJECT);
    RETURN1(res);
} END
DEFINE1(Canvas_GnomegetDither) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    GdkRgbDither cres = (GdkRgbDither)gnome_canvas_get_dither(
        (GnomeCanvas*)a0
        );
    word res = GdkRgbDithertToWord(cres);
    RETURN1(res);
} END
DEFINE2(Canvas_GnomesetDither) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkRgbDither a1 = GdkRgbDithertFromWord(x1);
    gnome_canvas_set_dither(
        (GnomeCanvas*)a0
        ,(GdkRgbDither)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_GnomegetColorPixel) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_INT(a1, x1);
    gulong cres = (gulong)gnome_canvas_get_color_pixel(
        (GnomeCanvas*)a0
        ,(guint)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Canvas_GnomegetColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CSTRING(a1, x1);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_COLOR);
    int cres = (int)gnome_canvas_get_color(
        (GnomeCanvas*)a0
        ,(const char*)a1
        ,(GdkColor*)a2
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE5(Canvas_GnomeworldToWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    DECLARE_CDOUBLE(tmp0, x3);
               double* a3 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x4);
               double* a4 = (double*)&tmp1;
    gnome_canvas_world_to_window(
        (GnomeCanvas*)a0
        ,(double)a1
        ,(double)a2
        ,(double*)a3
        ,(double*)a4
        );
    word r3 = Real::New(*a3)->ToWord ();
    word r4 = Real::New(*a4)->ToWord ();
    RETURN2(r3,r4);
} END
DEFINE5(Canvas_GnomewindowToWorld) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    DECLARE_CDOUBLE(tmp0, x3);
               double* a3 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x4);
               double* a4 = (double*)&tmp1;
    gnome_canvas_window_to_world(
        (GnomeCanvas*)a0
        ,(double)a1
        ,(double)a2
        ,(double*)a3
        ,(double*)a4
        );
    word r3 = Real::New(*a3)->ToWord ();
    word r4 = Real::New(*a4)->ToWord ();
    RETURN2(r3,r4);
} END
DEFINE5(Canvas_Gnomec2w) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_CDOUBLE(tmp0, x3);
               double* a3 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x4);
               double* a4 = (double*)&tmp1;
    gnome_canvas_c2w(
        (GnomeCanvas*)a0
        ,(int)a1
        ,(int)a2
        ,(double*)a3
        ,(double*)a4
        );
    word r3 = Real::New(*a3)->ToWord ();
    word r4 = Real::New(*a4)->ToWord ();
    RETURN2(r3,r4);
} END
DEFINE5(Canvas_Gnomew2cD) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    DECLARE_CDOUBLE(tmp0, x3);
               double* a3 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x4);
               double* a4 = (double*)&tmp1;
    gnome_canvas_w2c_d(
        (GnomeCanvas*)a0
        ,(double)a1
        ,(double)a2
        ,(double*)a3
        ,(double*)a4
        );
    word r3 = Real::New(*a3)->ToWord ();
    word r4 = Real::New(*a4)->ToWord ();
    RETURN2(r3,r4);
} END
DEFINE5(Canvas_Gnomew2c) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    DECLARE_INT_AS(int, tmp0, x3);
               int* a3 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x4);
               int* a4 = (int*)&tmp1;
    gnome_canvas_w2c(
        (GnomeCanvas*)a0
        ,(double)a1
        ,(double)a2
        ,(int*)a3
        ,(int*)a4
        );
    word r3 = Store::IntToWord(*a3);
    word r4 = Store::IntToWord(*a4);
    RETURN2(r3,r4);
} END
DEFINE2(Canvas_Gnomew2cAffine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    double a1[6]; // FIXME
    gnome_canvas_w2c_affine(
        (GnomeCanvas*)a0
        ,(double*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Canvas_GnomegetItemAt) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    GnomeCanvasItem* cres = (GnomeCanvasItem*)gnome_canvas_get_item_at(
        (GnomeCanvas*)a0
        ,(double)a1
        ,(double)a2
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Canvas_GnomeupdateNow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    gnome_canvas_update_now(
        (GnomeCanvas*)a0
        );
    RETURN_UNIT;
} END
DEFINE3(Canvas_GnomegetScrollOffsets) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_INT_AS(int, tmp0, x1);
               int* a1 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x2);
               int* a2 = (int*)&tmp1;
    gnome_canvas_get_scroll_offsets(
        (GnomeCanvas*)a0
        ,(int*)a1
        ,(int*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE3(Canvas_GnomescrollTo) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gnome_canvas_scroll_to(
        (GnomeCanvas*)a0
        ,(int)a1
        ,(int)a2
        );
    RETURN_UNIT;
} END
DEFINE5(Canvas_GnomegetScrollRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(tmp0, x1);
               double* a1 = (double*)&tmp0;
    DECLARE_CDOUBLE(tmp1, x2);
               double* a2 = (double*)&tmp1;
    DECLARE_CDOUBLE(tmp2, x3);
               double* a3 = (double*)&tmp2;
    DECLARE_CDOUBLE(tmp3, x4);
               double* a4 = (double*)&tmp3;
    gnome_canvas_get_scroll_region(
        (GnomeCanvas*)a0
        ,(double*)a1
        ,(double*)a2
        ,(double*)a3
        ,(double*)a4
        );
    word r1 = Real::New(*a1)->ToWord ();
    word r2 = Real::New(*a2)->ToWord ();
    word r3 = Real::New(*a3)->ToWord ();
    word r4 = Real::New(*a4)->ToWord ();
    RETURN4(r1,r2,r3,r4);
} END
DEFINE5(Canvas_GnomesetScrollRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    DECLARE_CDOUBLE(a2, x2);
    DECLARE_CDOUBLE(a3, x3);
    DECLARE_CDOUBLE(a4, x4);
    gnome_canvas_set_scroll_region(
        (GnomeCanvas*)a0
        ,(double)a1
        ,(double)a2
        ,(double)a3
        ,(double)a4
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_GnomesetCenterScrollRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_BOOL(a1, x1);
    gnome_canvas_set_center_scroll_region(
        (GnomeCanvas*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Canvas_GnomesetPixelsPerUnit) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    DECLARE_CDOUBLE(a1, x1);
    gnome_canvas_set_pixels_per_unit(
        (GnomeCanvas*)a0
        ,(double)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Canvas_Gnomeroot) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GNOME_TYPE_CANVAS);
    GnomeCanvasGroup* cres = (GnomeCanvasGroup*)gnome_canvas_root(
        (GnomeCanvas*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Canvas_GnomegetType) {
    GtkType cres = (GtkType)gnome_canvas_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
word NativeCanvas_CreateComponent() {
    Record *record = Record::New ((unsigned)57);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetType",Canvas_GnomegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Gnomeroot",Canvas_Gnomeroot, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomesetPixelsPerUnit",Canvas_GnomesetPixelsPerUnit, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomesetCenterScrollRegion",Canvas_GnomesetCenterScrollRegion, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomesetScrollRegion",Canvas_GnomesetScrollRegion, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetScrollRegion",Canvas_GnomegetScrollRegion, 5, 4);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomescrollTo",Canvas_GnomescrollTo, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetScrollOffsets",Canvas_GnomegetScrollOffsets, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomeupdateNow",Canvas_GnomeupdateNow, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetItemAt",Canvas_GnomegetItemAt, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Gnomew2cAffine",Canvas_Gnomew2cAffine, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Gnomew2c",Canvas_Gnomew2c, 5, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Gnomew2cD",Canvas_Gnomew2cD, 5, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Gnomec2w",Canvas_Gnomec2w, 5, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomewindowToWorld",Canvas_GnomewindowToWorld, 5, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomeworldToWindow",Canvas_GnomeworldToWindow, 5, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetColor",Canvas_GnomegetColor, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetColorPixel",Canvas_GnomegetColorPixel, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomesetDither",Canvas_GnomesetDither, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomegetDither",Canvas_GnomegetDither, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Gnomenew",Canvas_Gnomenew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GnomenewAa",Canvas_GnomenewAa, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemgetType",Canvas_ItemgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemset",Canvas_Itemset, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemmove",Canvas_Itemmove, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemaffineRelative",Canvas_ItemaffineRelative, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemaffineAbsolute",Canvas_ItemaffineAbsolute, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemraiseWindow",Canvas_ItemraiseWindow, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemlowerWindow",Canvas_ItemlowerWindow, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemraiseToTop",Canvas_ItemraiseToTop, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemlowerToBottom",Canvas_ItemlowerToBottom, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemshow",Canvas_Itemshow, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemhide",Canvas_Itemhide, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemw2i",Canvas_Itemw2i, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemi2w",Canvas_Itemi2w, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemi2wAffine",Canvas_Itemi2wAffine, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemi2cAffine",Canvas_Itemi2cAffine, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Itemreparent",Canvas_Itemreparent, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemgrabFocus",Canvas_ItemgrabFocus, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "ItemgetBounds",Canvas_ItemgetBounds, 5, 4);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GroupsetFieldItemList",Canvas_GroupsetFieldItemList, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GroupgetFieldItemList",Canvas_GroupgetFieldItemList, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GroupnewItem",Canvas_GroupnewItem, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Groupadd",Canvas_Groupadd, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "GroupgetType",Canvas_GroupgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Groupnew",Canvas_Groupnew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "LinegetType",Canvas_LinegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "PixbufgetType",Canvas_PixbufgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "RichTextgetType",Canvas_RichTextgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "RectgetType",Canvas_RectgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "EllipsegetType",Canvas_EllipsegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "PolygongetType",Canvas_PolygongetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "TextgetType",Canvas_TextgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "WidgetgetType",Canvas_WidgetgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "CanvasPathDefnew",Canvas_CanvasPathDefnew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Pointsset",Canvas_Pointsset, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeCanvas", "Pointsnew",Canvas_Pointsnew, 1, 1);
    return record->ToWord ();
}
