//
// Author:
//   Robert Grabowski <grabow@ps.uni-sb.de>
//
// Copyright:
//   Robert Grabowski, 2003
//
// Last Change:
//   $Date: 2006-06-25 06:50:13 $ by $Author: tack $
//   $Revision: 1.32 $
//

/*
  This header file is included in every generated native source file.
  It contains conversion macros that are specifically written for
  the GTK+ binding.
*/

#ifndef _NATIVE_UTILS_HH_
#define _NATIVE_UTILS_HH_

#include <gtk/gtk.h>
#include <libgnomecanvas/libgnomecanvas.h>
#include "Alice.hh"
#include "MyNativeAuthoring.hh"

#define AWAIT(y,x) \
	if (Store::WordToTransient(x) != INVALID_POINTER) REQUEST(x); \
	word y = PointerOp::Deref(x);

extern const char *empty_str;


enum { gtkBOOL, gtkEVENT, gtkINT, gtkLIST, gtkOBJECT, gtkREAL, gtkSTRING };

/***********************************************************************/
// MACROS FOR OBJECT HANDLING 

// Note: all C pointers leaving the native level are put into an
//       (pointer, typeinfo, parent_if_any, gtype) tuple. 
//       These tuples are called "objects".
//       When an object enters the native level, the C pointer is extracted.
//       Using unmanged pointers directly as words in alice causes trouble with
//       the garbage collection, thus the GTK+ binding does not make use of
//       the DECLARE_UNMANAGED_POINTER and UNMANAGED_POINTER_TO_WORD macros.

enum { FLAG_OWN = 1 << 7 };     // set for TYPE_BOXED or TYPE_POINTER or
                                // TYPE_UNKNOWN if the data is supposed to
                                // be 'delete'd upon unref

enum { TYPE_GTK_OBJECT, /* objects derived from GtkObject */ 
       TYPE_G_OBJECT,   /* objects derived from GObject but not from GtkObject */
       TYPE_BOXED,      /* c structs like GtkColor third tuple element contains the 
                           gtype
                         */
       TYPE_POINTER,    /* pointer to something (e.g string) also third tuple element
                           contains the gtype
                         */
       TYPE_UNKNOWN     /* if we for some reason couldn't keep track of the type */
     };

// Extract a C pointer from an object tuple.
// The pointer itself cannot be a transient, as the object tuples are
// always created by the native components
#define DECLARE_OBJECT(pointer, x)                               \
  DECLARE_TUPLE(pointer##__tup,x);                               \
  void *pointer = Store::WordToUnmanagedPointer(pointer##__tup->Sel(0));

// Extract C pointer and type information from object tuple.
#define DECLARE_OBJECT_WITH_TYPE(pointer, type, x)               \
  DECLARE_TUPLE(pointer##__tup,x);                               \
  pointer##__tup->AssertWidth (4);                               \
  int type = Store::WordToInt(pointer##__tup->Sel(1)) & ~FLAG_OWN;           \
  GType type##_gtype = Store::WordToInt (pointer##__tup->Sel (3)); \
  void *pointer = Store::WordToUnmanagedPointer(pointer##__tup->Sel(0));


word makeGtkCoreTypeError (GType actual, GType expected);

#define THROW_TYPE_ERROR(actual, expected)                      \
{ word _exn = makeGtkCoreTypeError (actual, expected); \
  fprintf (stderr, "type error actual = %s, expected = %s\n", getGType (actual), getGType (expected)); \
  fflush(stderr); RAISE(_exn); }

static inline const char *getGType (GType gt) {
    if (gt == 0) {
        return "ZERO GTYPE";
    } else {
        return g_type_name (gt);
    }
}


#define DECLARE_OBJECT_OF_TYPE(pointer, x, expected)            \
    DECLARE_TUPLE(pointer##__tup, x);                           \
    pointer##__tup->AssertWidth (4);                            \
    void *pointer = Store::WordToUnmanagedPointer (pointer##__tup->Sel (0)); \
    { \
        GType actual = (GType)Store::WordToInt(pointer##__tup->Sel (3));                         \
        switch (Store::WordToInt (pointer##__tup->Sel(1)) & ~FLAG_OWN) {            \
            case TYPE_GTK_OBJECT:                                       \
            case TYPE_G_OBJECT:                                         \
                if (!g_type_is_a (G_OBJECT_TYPE((GObject*)pointer), expected)) {  \
                    THROW_TYPE_ERROR(G_OBJECT_TYPE((GObject*)pointer), expected); \
                } break;                                                \
            case TYPE_BOXED:                                            \
            case TYPE_POINTER:                                          \
                if (!g_type_is_a (actual, expected)) {                  \
                    THROW_TYPE_ERROR(actual, expected); \
                } break;                                                \
            case TYPE_UNKNOWN:                                          \
                /* if this is the NULL pointer we let it pass    */     \
                /* otherwise we emit a warning and let it pass as well */ \
                if (pointer != NULL)  fprintf (stderr, "alice-gtk warning: object of unknown type encountered (expected %s)!\n", getGType (expected)); \
                /* let it pass */                                       \
                break;                                                  \
            default:                                                    \
                Assert(false);                                          \
                break;                                                  \
        }                                                               \
    }

static inline void print_type(char *s, void *obj) {
  GObject *p = reinterpret_cast<GObject*>(obj);
  GTypeQuery q;
  memset(&q, 0, sizeof(q));
  g_type_query(G_OBJECT_TYPE(p), &q);
  g_message("%s: %p (type %s), refcnt: %d", s, p, q.type_name, 
	    G_OBJECT(p)->ref_count);
}

static inline const char *getObjectType(int type) {
  switch (type & ~FLAG_OWN) {
  case TYPE_GTK_OBJECT: return "TYPE_GTK_OBJECT";
  case TYPE_G_OBJECT: return "TYPE_G_OBJECT";
  case TYPE_BOXED: return "TYPE_BOXED";
  case TYPE_POINTER: return "TYPE_POINTER";
  case TYPE_UNKNOWN: return "TYPE_UNKNOWN";
  default: return "STRANGE_TYPE";
  }
}

// Increase reference count of a pointer, depending on type.
static inline void __refObject(void *p, int type) {
  if (!p) return;
//    g_message("reffing: %p (type %s)", p, getObjectType(type));
  switch (type) {
  case TYPE_GTK_OBJECT: 
    g_object_ref(G_OBJECT(p));
    //(see GTK documentation for purpose of gtk_object_sink)
    gtk_object_sink(GTK_OBJECT(p)); 
    break;
  case TYPE_G_OBJECT: 
    g_object_ref(p);
    break;
  default:
    break;
  }
}

static inline void __refObject(word wParent) {
  Tuple *parent = Tuple::FromWord(wParent);
  if (parent != INVALID_POINTER) {
    __refObject(Store::DirectWordToUnmanagedPointer(parent->Sel(0)),
		Store::DirectWordToInt(parent->Sel(1)) && ~FLAG_OWN);
  }
}

// Decrease reference count of a pointer, depending on type.
static inline void __unrefObject(void *p, int type) {
  if (!p) return;
//    g_message("unreffing: %p (type %s)", p, getObjectType(type));
  switch (type & ~FLAG_OWN) {
  case TYPE_GTK_OBJECT: 
  case TYPE_G_OBJECT: 
    g_object_unref(G_OBJECT(p));
    break;
  case TYPE_POINTER:
  case TYPE_BOXED:
  case TYPE_UNKNOWN:
    if (type & FLAG_OWN) delete (int*)p;
    break;
  default:
    break;
  }
}

static inline void __unrefObject(word wParent) {
  Tuple *parent = Tuple::FromWord(wParent);
  if (parent != INVALID_POINTER) {
    __unrefObject(Store::DirectWordToUnmanagedPointer(parent->Sel(0)),
		  Store::DirectWordToInt(parent->Sel(1)));
  }
}

// Manage parental relations to ensure parent objects are freed last
static inline void __parentObject(word wContainer, word wWidget) {
  Tuple *widget = Tuple::FromWord(wWidget);
  // Release old container object
  __unrefObject(widget->Sel(2));
  // Strengthen new container object
  __refObject(wContainer);
  // TODO: tuple with update?
  STATIC_CAST(Block *, widget)->ReplaceArgUnchecked(2, wContainer);
}

// Convert a C pointer to an object tuple.
word OBJECT_TO_WORD(const void *p, int type, GType gtype);

static inline word G_OBJECT_TO_WORD (const void *p) {
    GObject *ob = (GObject*)p;
    if (ob == 0) {
        return OBJECT_TO_WORD (p, TYPE_UNKNOWN, 0);
    } else {
        GType gt    = G_OBJECT_TYPE(ob);
        int   t     = g_type_is_a (gt, GTK_TYPE_OBJECT) ? TYPE_GTK_OBJECT : TYPE_G_OBJECT;
        return OBJECT_TO_WORD (p, t, gt);
    }
}
    
static inline word OBJECT_TO_WORD(const void *p, int type) {
    return OBJECT_TO_WORD(p, type, 0);
}

static inline word OBJECT_TO_WORD(const void *p) {
  return OBJECT_TO_WORD(p, TYPE_UNKNOWN, 0);
}

/*
#define FUNCTION_TO_WORD(f) OBJECT_TO_WORD((void*)f, TYPE_UNKNOWN)

const char *Alice_Gtk_OBJECT_TO_WORD = "Alice.Gtk.OBJECT_TO_WORD";

static static word LazyBrokerLookup(const void *objectPointer, int type, GType gtype) {
  word value = Broker::Lookup(String::New(Alice_Gtk_OBJECT_TO_WORD));
  if (value == (word) 0)
    Error("LazyBrokerLookup: OBJECT_TO_WORD not registered");
  void *pointer = Store::DirectWordToUnmanagedPointer(value);
  Assert(pointer != INVALID_POINTER);
  OBJECT_TO_WORD_instance = (word (*)(const void *, int, GType)) pointer;
  return OBJECT_TO_WORD_instance(objectPointer, type, gtype);
}

static void InitLocalInstance() {
  OBJECT_TO_WORD_instance = (word (*)(const void *, int, GType)) LazyBrokerLookup;
}
*/

/***********************************************************************/

#define DECLARE_C_ARG_ARRAY(v, length, x, lengthType, elemType, convElem)        \
    DECLARE_VECTOR(v##__vec, x);                        \
    lengthType length = v##__vec->GetLength (); \
    elemType v[v##__vec->GetLength ()]; \
    { for (u_int v##__i = 0; v##__i < v##__vec->GetLength (); v##__i++) { \
      word elem_alice = v##__vec->Sub (v##__i);                         \
      convElem;                                                         \
      v[v##__i] = (elemType)elem_c;                                               \
    } }
                                                                            
// MACROS FOR GLIST/GSLIST HANDLING
        
#define DECLARE_GLIB_LIST(l, x, ltype, ltype2, F)           \
  ltype *l = NULL;                                          \
  {                                                         \
    DECLARE_LIST_ELEMS(l##__tagval, l##__length, x,         \
      { F(l##__value,l##__tagval->Sel(0));                  \
        l = ltype2##_append(l, l##__value);                 \
      } );                                                  \
  }

#define DECLARE_ZERO_TERMINATED_ARRAY(v, x, elemType, convElem) \
    DECLARE_VECTOR(v##__vec, x);                                \
    elemType v[v##__vec->GetLength () + 1];                         \
    { for (u_int v##__i = 0; v##__i < v##__vec->GetLength (); v##__i++) {       \
        word elem_alice = v##__vec->Sub (v##__i);                               \
        convElem;                                                               \
        v[v##__i] = (elemType)elem_c;                                           \
      }                                                                         \
      v[v##__vec->GetLength ()] = NULL;                                         \
    }

                                                                            
// Create a GList/GSList from an alice list,
// and use F (can be DECLARE_INT,...) to convert each list member
#define DECLARE_GLIST(l, x, F) DECLARE_GLIB_LIST(l, x, GList, g_list, F)
#define DECLARE_GSLIST(l, x, F) DECLARE_GLIB_LIST(l, x, GSList, g_slist, F)

#define __RETURN_GLIB_LIST(lname,ltype,convertfun)            \
  word tail = Store::IntToWord(Types::nil);                 \
  for (guint i = ltype##_length(lname); i > 0; i--) {       \
    TagVal *cons = TagVal::New(0,2);                        \
    cons->Init(0,convertfun(ltype##_nth_data(lname,i-1)));  \
    cons->Init(1,tail);                                     \
    tail = cons->ToWord();                                  \
  }                                                         \
  return tail;

// Return a GList/GSList.
inline word GLIST_OBJECT_TO_WORD(GList *list) {
  __RETURN_GLIB_LIST(list, g_list, OBJECT_TO_WORD);
}

inline word GSLIST_OBJECT_TO_WORD(GSList *list) {
  __RETURN_GLIB_LIST(list, g_slist, OBJECT_TO_WORD);
}

inline word GLIST_STRING_TO_WORD(GList *list) {
  __RETURN_GLIB_LIST(list, g_list, STRING_TO_WORD);
}

inline word GSLIST_STRING_TO_WORD(GSList *list) {
  __RETURN_GLIB_LIST(list, g_slist, STRING_TO_WORD);
}

/***********************************************************************/
// MACROS FOR ELLIPSES/VA_LIST HANDLING

#define VDATA_MAX_LEN 1024

#define __PUT_VALUE(vtype, F, x, pos) {    \
  F(value, x);                             \
  memcpy(pos, &value, sizeof(vtype));      \
  pos += sizeof(vtype);                    \
}

#define __PUT_VALIST_ITEM(pos, end, tvw) {          \
  TagVal *tv = TagVal::FromWord(tvw);               \
  if (pos < end) {                                  \
    switch (tv->GetTag()) {                         \
    case gtkBOOL: __PUT_VALUE(bool, DECLARE_BOOL, tv->Sel(0), pos); break;   \
    case gtkEVENT:  break; \
    case gtkINT:  __PUT_VALUE(int,  DECLARE_INT, tv->Sel(0), pos); break;    \
    case gtkLIST:   break; \
    case gtkOBJECT: __PUT_VALUE(void*,DECLARE_OBJECT,tv->Sel(0),pos); break; \
    case gtkREAL: __PUT_VALUE(double,DECLARE_CDOUBLE,tv->Sel(0),pos); break; \
    case gtkSTRING: __PUT_VALUE(char*,DECLARE_CSTRING,tv->Sel(0),pos); break;\
    }                                                                        \
  }                                                                          \
}

#define DECLARE_VALIST(l, x)                                \
  gint8 l[VDATA_MAX_LEN+20];                                \
  memset(l, 0, sizeof(l));                                  \
  {                                                         \
    gint8 *l##__pos = l, *l##__end = &(l[VDATA_MAX_LEN]);   \
    DECLARE_LIST_ELEMS(l##__tagval, l##__length, x,         \
      __PUT_VALIST_ITEM(l##__pos, l##__end, l##__tagval->Sel(0)) ); \
  }                                                       

#define DECLARE_ELLIPSES(l, x)            \
  double l[2];                            \
  memset(l, 0, sizeof(l));                \
  {                                       \
    gint8 *l##__pos = (gint8*)l, *l##__end = (gint8*)&(l[1]); \
    __PUT_VALIST_ITEM(l##__pos, l##__end, x);                 \
  }                                                         

// old version: ellipses with up to 20 args (highly platform-dependent)
//#define ELLIP_MAX_ARGS 20
//#define DECLARE_ELLIPSES(l, x)                              \
//  int l[ELLIP_MAX_ARGS+1];                                  \
//  memset(l, 0, sizeof(l));                                  \
//  {                                                         \
//    gint8 *l##__pos = (gint8*)l, *l##__end = (gint8*)&(l[ELLIP_MAX_ARGS]);  \
//    DECLARE_LIST_ELEMS(l##__tagval, l##__length, x,         \
//      __PUT_VALIST_ITEM(l##__pos, l##__end, l##__tagval) ); \
//  }                                                         

/***********************************************************************/
// MACROS FOR ENUM HANDLING

#define DECLARE_ENUM DECLARE_INT
#define ENUM_TO_WORD INT_TO_WORD

GnomeCanvasItem *alice_gnome_canvas_item_new (GnomeCanvasGroup *gr, GtkType t);

word NativeCore_SignalConnect (void *ob, char *sig, bool after);
    
void specialDeleteRangeEvent (GObject *obj, GtkTextIter *i1, GtkTextIter *i2, gpointer);
#endif
