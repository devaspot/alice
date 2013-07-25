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
GTimeVal* MK_GTimeValNew (
        glong tv_sec
        , glong tv_usec
        ) {
    GTimeVal* res_ = new GTimeVal;
    res_->tv_sec = tv_sec;
    res_->tv_usec = tv_usec;
    return res_;
}
DEFINE2(GLib_TimeValnew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    GTimeVal* cres = (GTimeVal*)MK_GTimeValNew(
        (glong)a0
        ,(glong)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
#define DOgetFieldTvSec(O) ((O)->tv_sec)
#define DOsetFieldTvSec(O, V) ((O)->tv_sec = (V))
#define DOgetFieldTvUsec(O) ((O)->tv_usec)
#define DOsetFieldTvUsec(O, V) ((O)->tv_usec = (V))
DEFINE1(GLib_TimeValgetFieldTvUsec) {
    DECLARE_OBJECT(a0, x0);
    glong cres = (glong)DOgetFieldTvUsec(
        (GTimeVal*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(GLib_TimeValsetFieldTvUsec) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldTvUsec(
        (GTimeVal*)a0
        ,(glong)a1
        );
    RETURN_UNIT;
} END
DEFINE1(GLib_TimeValgetFieldTvSec) {
    DECLARE_OBJECT(a0, x0);
    glong cres = (glong)DOgetFieldTvSec(
        (GTimeVal*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(GLib_TimeValsetFieldTvSec) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldTvSec(
        (GTimeVal*)a0
        ,(glong)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldTvSec
#undef DOsetFieldTvSec
#undef DOgetFieldTvUsec
#undef DOsetFieldTvUsec
DEFINE0(GLib_PtrArraygPtrArrayNew) {
    GPtrArray* cres = (GPtrArray*)g_ptr_array_new(
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
#define DOgetFieldLen(O) ((O)->len)
#define DOsetFieldLen(O, V) ((O)->len = (V))
DEFINE2(GLib_PtrArrayindex) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    gpointer cres = (gpointer)g_ptr_array_index(
        (GPtrArray*)a0
        ,(gint)a1
        );
    word res = OBJECT_TO_WORD(cres, TYPE_POINTER);
    RETURN1(res);
} END
DEFINE1(GLib_PtrArraygetFieldLen) {
    DECLARE_OBJECT(a0, x0);
    guint cres = (guint)DOgetFieldLen(
        (GPtrArray*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(GLib_PtrArraysetFieldLen) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldLen(
        (GPtrArray*)a0
        ,(guint)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldLen
#undef DOsetFieldLen
DEFINE2(GLib_ObjectgetProperty) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, G_TYPE_OBJECT);
    DECLARE_CSTRING(a1, x1);
    GValue* a2 = new GValue; memset(a2, 0, sizeof(GValue));
    g_value_init ((GValue*)a2, G_PARAM_SPEC_VALUE_TYPE(
        g_object_class_find_property (G_OBJECT_GET_CLASS ((GObject*)a0), (const gchar*)a1)));
     g_object_get_property ((GObject*)a0, (const gchar*)a1, (GValue*)a2);
    
    word r2 = OBJECT_TO_WORD (a2, TYPE_BOXED | FLAG_OWN, G_TYPE_VALUE);
    RETURN1(r2);
} END
DEFINE3(GLib_ObjectsetProperty) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, G_TYPE_OBJECT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_OBJECT_OF_TYPE(a2, x2, G_TYPE_VALUE);
    g_object_set_property(
        (GObject*)a0
        ,(const gchar*)a1
        ,(GValue*)a2
        );
    RETURN_UNIT;
} END
word NativeGLib_CreateComponent() {
    Record *record = Record::New ((unsigned)11);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "ObjectsetProperty",GLib_ObjectsetProperty, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "ObjectgetProperty",GLib_ObjectgetProperty, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "PtrArraysetFieldLen",GLib_PtrArraysetFieldLen, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "PtrArraygetFieldLen",GLib_PtrArraygetFieldLen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "PtrArrayindex",GLib_PtrArrayindex, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "PtrArraygPtrArrayNew",GLib_PtrArraygPtrArrayNew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "TimeValsetFieldTvSec",GLib_TimeValsetFieldTvSec, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "TimeValgetFieldTvSec",GLib_TimeValgetFieldTvSec, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "TimeValsetFieldTvUsec",GLib_TimeValsetFieldTvUsec, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "TimeValgetFieldTvUsec",GLib_TimeValgetFieldTvUsec, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGLib", "TimeValnew",GLib_TimeValnew, 2, 1);
    return record->ToWord ();
}
