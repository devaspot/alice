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
word GdkInterpTypetToWord(GdkInterpType v) {
    unsigned r = 0;
        if (v  == GDK_INTERP_BILINEAR) {
            r = 0;
        } else 
        if (v  == GDK_INTERP_HYPER) {
            r = 1;
        } else 
        if (v  == GDK_INTERP_NEAREST) {
            r = 2;
        } else 
        if (v  == GDK_INTERP_TILES) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkInterpType GdkInterpTypetFromWord(word w) {
    GdkInterpType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_INTERP_BILINEAR;
            break;
        case 1: r = GDK_INTERP_HYPER;
            break;
        case 2: r = GDK_INTERP_NEAREST;
            break;
        case 3: r = GDK_INTERP_TILES;
            break;
        default:
            Error ("GdkInterpTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_InterpTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkInterpTypetFromWord(x0));
} END
DEFINE1(Gdk_InterpTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkInterpTypetToWord((GdkInterpType)i));
} END
DEFINE0(Gdk_InterpTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_INTERP_TYPE));
} END
word GdkPixbufErrortToWord(GdkPixbufError v) {
    unsigned r = 0;
        if (v  == GDK_PIXBUF_ERROR_CORRUPT_IMAGE) {
            r = 0;
        } else 
        if (v  == GDK_PIXBUF_ERROR_FAILED) {
            r = 1;
        } else 
        if (v  == GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY) {
            r = 2;
        } else 
        if (v  == GDK_PIXBUF_ERROR_UNKNOWN_TYPE) {
            r = 3;
        } else 
        if (v  == GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION) {
            r = 4;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkPixbufError GdkPixbufErrortFromWord(word w) {
    GdkPixbufError r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_PIXBUF_ERROR_CORRUPT_IMAGE;
            break;
        case 1: r = GDK_PIXBUF_ERROR_FAILED;
            break;
        case 2: r = GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY;
            break;
        case 3: r = GDK_PIXBUF_ERROR_UNKNOWN_TYPE;
            break;
        case 4: r = GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION;
            break;
        default:
            Error ("GdkPixbufErrortFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_PixbufErrorToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkPixbufErrortFromWord(x0));
} END
DEFINE1(Gdk_PixbufErrorFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkPixbufErrortToWord((GdkPixbufError)i));
} END
DEFINE0(Gdk_PixbufErrorGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_PIXBUF_ERROR));
} END
word GdkColorspacetToWord(GdkColorspace v) {
    unsigned r = 0;
        if (v  == GDK_COLORSPACE_RGB) {
            r = 0;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkColorspace GdkColorspacetFromWord(word w) {
    GdkColorspace r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_COLORSPACE_RGB;
            break;
        default:
            Error ("GdkColorspacetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_ColorspaceToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkColorspacetFromWord(x0));
} END
DEFINE1(Gdk_ColorspaceFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkColorspacetToWord((GdkColorspace)i));
} END
DEFINE0(Gdk_ColorspaceGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_COLORSPACE));
} END
word GdkPixbufAlphaModetToWord(GdkPixbufAlphaMode v) {
    unsigned r = 0;
        if (v  == GDK_PIXBUF_ALPHA_BILEVEL) {
            r = 0;
        } else 
        if (v  == GDK_PIXBUF_ALPHA_FULL) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkPixbufAlphaMode GdkPixbufAlphaModetFromWord(word w) {
    GdkPixbufAlphaMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_PIXBUF_ALPHA_BILEVEL;
            break;
        case 1: r = GDK_PIXBUF_ALPHA_FULL;
            break;
        default:
            Error ("GdkPixbufAlphaModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_PixbufAlphaModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkPixbufAlphaModetFromWord(x0));
} END
DEFINE1(Gdk_PixbufAlphaModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkPixbufAlphaModetToWord((GdkPixbufAlphaMode)i));
} END
DEFINE0(Gdk_PixbufAlphaModeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_PIXBUF_ALPHA_MODE));
} END
word GdkWindowEdgetToWord(GdkWindowEdge v) {
    unsigned r = 0;
        if (v  == GDK_WINDOW_EDGE_EAST) {
            r = 0;
        } else 
        if (v  == GDK_WINDOW_EDGE_NORTH) {
            r = 1;
        } else 
        if (v  == GDK_WINDOW_EDGE_NORTH_EAST) {
            r = 2;
        } else 
        if (v  == GDK_WINDOW_EDGE_NORTH_WEST) {
            r = 3;
        } else 
        if (v  == GDK_WINDOW_EDGE_SOUTH) {
            r = 4;
        } else 
        if (v  == GDK_WINDOW_EDGE_SOUTH_EAST) {
            r = 5;
        } else 
        if (v  == GDK_WINDOW_EDGE_SOUTH_WEST) {
            r = 6;
        } else 
        if (v  == GDK_WINDOW_EDGE_WEST) {
            r = 7;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkWindowEdge GdkWindowEdgetFromWord(word w) {
    GdkWindowEdge r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_WINDOW_EDGE_EAST;
            break;
        case 1: r = GDK_WINDOW_EDGE_NORTH;
            break;
        case 2: r = GDK_WINDOW_EDGE_NORTH_EAST;
            break;
        case 3: r = GDK_WINDOW_EDGE_NORTH_WEST;
            break;
        case 4: r = GDK_WINDOW_EDGE_SOUTH;
            break;
        case 5: r = GDK_WINDOW_EDGE_SOUTH_EAST;
            break;
        case 6: r = GDK_WINDOW_EDGE_SOUTH_WEST;
            break;
        case 7: r = GDK_WINDOW_EDGE_WEST;
            break;
        default:
            Error ("GdkWindowEdgetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_WindowEdgeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkWindowEdgetFromWord(x0));
} END
DEFINE1(Gdk_WindowEdgeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowEdgetToWord((GdkWindowEdge)i));
} END
DEFINE0(Gdk_WindowEdgeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_EDGE));
} END
word GdkGravitytToWord(GdkGravity v) {
    unsigned r = 0;
        if (v  == GDK_GRAVITY_CENTER) {
            r = 0;
        } else 
        if (v  == GDK_GRAVITY_EAST) {
            r = 1;
        } else 
        if (v  == GDK_GRAVITY_NORTH) {
            r = 2;
        } else 
        if (v  == GDK_GRAVITY_NORTH_EAST) {
            r = 3;
        } else 
        if (v  == GDK_GRAVITY_NORTH_WEST) {
            r = 4;
        } else 
        if (v  == GDK_GRAVITY_SOUTH) {
            r = 5;
        } else 
        if (v  == GDK_GRAVITY_SOUTH_EAST) {
            r = 6;
        } else 
        if (v  == GDK_GRAVITY_SOUTH_WEST) {
            r = 7;
        } else 
        if (v  == GDK_GRAVITY_STATIC) {
            r = 8;
        } else 
        if (v  == GDK_GRAVITY_WEST) {
            r = 9;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkGravity GdkGravitytFromWord(word w) {
    GdkGravity r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_GRAVITY_CENTER;
            break;
        case 1: r = GDK_GRAVITY_EAST;
            break;
        case 2: r = GDK_GRAVITY_NORTH;
            break;
        case 3: r = GDK_GRAVITY_NORTH_EAST;
            break;
        case 4: r = GDK_GRAVITY_NORTH_WEST;
            break;
        case 5: r = GDK_GRAVITY_SOUTH;
            break;
        case 6: r = GDK_GRAVITY_SOUTH_EAST;
            break;
        case 7: r = GDK_GRAVITY_SOUTH_WEST;
            break;
        case 8: r = GDK_GRAVITY_STATIC;
            break;
        case 9: r = GDK_GRAVITY_WEST;
            break;
        default:
            Error ("GdkGravitytFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_GravityToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkGravitytFromWord(x0));
} END
DEFINE1(Gdk_GravityFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkGravitytToWord((GdkGravity)i));
} END
DEFINE0(Gdk_GravityGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_GRAVITY));
} END
word GdkWMFunctiontToWord(GdkWMFunction v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_FUNC_ALL) == GDK_FUNC_ALL) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_FUNC_CLOSE) == GDK_FUNC_CLOSE) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_FUNC_MAXIMIZE) == GDK_FUNC_MAXIMIZE) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_FUNC_MINIMIZE) == GDK_FUNC_MINIMIZE) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_FUNC_MOVE) == GDK_FUNC_MOVE) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_FUNC_RESIZE) == GDK_FUNC_RESIZE) {
            w = alice_cons (Store::IntToWord (5), w);
        }
    return w;
}
GdkWMFunction GdkWMFunctiontFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_FUNC_ALL;
                break;
            case 1: r |= GDK_FUNC_CLOSE;
                break;
            case 2: r |= GDK_FUNC_MAXIMIZE;
                break;
            case 3: r |= GDK_FUNC_MINIMIZE;
                break;
            case 4: r |= GDK_FUNC_MOVE;
                break;
            case 5: r |= GDK_FUNC_RESIZE;
                break;
            default:
                Error ("GdkWMFunctiontFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkWMFunction)r;
}
DEFINE1(Gdk_WMFunctionToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkWMFunctiontFromWord(x0));
} END
DEFINE1(Gdk_WMFunctionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWMFunctiontToWord((GdkWMFunction)i));
} END
DEFINE0(Gdk_WMFunctionGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WM_FUNCTION));
} END
word GdkWMDecorationtToWord(GdkWMDecoration v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_DECOR_ALL) == GDK_DECOR_ALL) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_DECOR_BORDER) == GDK_DECOR_BORDER) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_DECOR_MAXIMIZE) == GDK_DECOR_MAXIMIZE) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_DECOR_MENU) == GDK_DECOR_MENU) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_DECOR_MINIMIZE) == GDK_DECOR_MINIMIZE) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_DECOR_RESIZEH) == GDK_DECOR_RESIZEH) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_DECOR_TITLE) == GDK_DECOR_TITLE) {
            w = alice_cons (Store::IntToWord (6), w);
        }
    return w;
}
GdkWMDecoration GdkWMDecorationtFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_DECOR_ALL;
                break;
            case 1: r |= GDK_DECOR_BORDER;
                break;
            case 2: r |= GDK_DECOR_MAXIMIZE;
                break;
            case 3: r |= GDK_DECOR_MENU;
                break;
            case 4: r |= GDK_DECOR_MINIMIZE;
                break;
            case 5: r |= GDK_DECOR_RESIZEH;
                break;
            case 6: r |= GDK_DECOR_TITLE;
                break;
            default:
                Error ("GdkWMDecorationtFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkWMDecoration)r;
}
DEFINE1(Gdk_WMDecorationToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkWMDecorationtFromWord(x0));
} END
DEFINE1(Gdk_WMDecorationFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWMDecorationtToWord((GdkWMDecoration)i));
} END
DEFINE0(Gdk_WMDecorationGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WM_DECORATION));
} END
word GdkWindowTypeHinttToWord(GdkWindowTypeHint v) {
    unsigned r = 0;
        if (v  == GDK_WINDOW_TYPE_HINT_DESKTOP) {
            r = 0;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_DIALOG) {
            r = 1;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_DOCK) {
            r = 2;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_MENU) {
            r = 3;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_NORMAL) {
            r = 4;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_SPLASHSCREEN) {
            r = 5;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_TOOLBAR) {
            r = 6;
        } else 
        if (v  == GDK_WINDOW_TYPE_HINT_UTILITY) {
            r = 7;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkWindowTypeHint GdkWindowTypeHinttFromWord(word w) {
    GdkWindowTypeHint r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_WINDOW_TYPE_HINT_DESKTOP;
            break;
        case 1: r = GDK_WINDOW_TYPE_HINT_DIALOG;
            break;
        case 2: r = GDK_WINDOW_TYPE_HINT_DOCK;
            break;
        case 3: r = GDK_WINDOW_TYPE_HINT_MENU;
            break;
        case 4: r = GDK_WINDOW_TYPE_HINT_NORMAL;
            break;
        case 5: r = GDK_WINDOW_TYPE_HINT_SPLASHSCREEN;
            break;
        case 6: r = GDK_WINDOW_TYPE_HINT_TOOLBAR;
            break;
        case 7: r = GDK_WINDOW_TYPE_HINT_UTILITY;
            break;
        default:
            Error ("GdkWindowTypeHinttFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_WindowTypeHintToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkWindowTypeHinttFromWord(x0));
} END
DEFINE1(Gdk_WindowTypeHintFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowTypeHinttToWord((GdkWindowTypeHint)i));
} END
DEFINE0(Gdk_WindowTypeHintGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_TYPE_HINT));
} END
word GdkWindowHintstToWord(GdkWindowHints v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_HINT_ASPECT) == GDK_HINT_ASPECT) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_HINT_BASE_SIZE) == GDK_HINT_BASE_SIZE) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_HINT_MAX_SIZE) == GDK_HINT_MAX_SIZE) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_HINT_MIN_SIZE) == GDK_HINT_MIN_SIZE) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_HINT_POS) == GDK_HINT_POS) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_HINT_RESIZE_INC) == GDK_HINT_RESIZE_INC) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_HINT_USER_POS) == GDK_HINT_USER_POS) {
            w = alice_cons (Store::IntToWord (6), w);
        }
        if ((v & GDK_HINT_USER_SIZE) == GDK_HINT_USER_SIZE) {
            w = alice_cons (Store::IntToWord (7), w);
        }
        if ((v & GDK_HINT_WIN_GRAVITY) == GDK_HINT_WIN_GRAVITY) {
            w = alice_cons (Store::IntToWord (8), w);
        }
    return w;
}
GdkWindowHints GdkWindowHintstFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_HINT_ASPECT;
                break;
            case 1: r |= GDK_HINT_BASE_SIZE;
                break;
            case 2: r |= GDK_HINT_MAX_SIZE;
                break;
            case 3: r |= GDK_HINT_MIN_SIZE;
                break;
            case 4: r |= GDK_HINT_POS;
                break;
            case 5: r |= GDK_HINT_RESIZE_INC;
                break;
            case 6: r |= GDK_HINT_USER_POS;
                break;
            case 7: r |= GDK_HINT_USER_SIZE;
                break;
            case 8: r |= GDK_HINT_WIN_GRAVITY;
                break;
            default:
                Error ("GdkWindowHintstFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkWindowHints)r;
}
DEFINE1(Gdk_WindowHintsToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkWindowHintstFromWord(x0));
} END
DEFINE1(Gdk_WindowHintsFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowHintstToWord((GdkWindowHints)i));
} END
DEFINE0(Gdk_WindowHintsGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_HINTS));
} END
word GdkWindowAttributesTypetToWord(GdkWindowAttributesType v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_WA_COLORMAP) == GDK_WA_COLORMAP) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_WA_CURSOR) == GDK_WA_CURSOR) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_WA_NOREDIR) == GDK_WA_NOREDIR) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_WA_TITLE) == GDK_WA_TITLE) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_WA_VISUAL) == GDK_WA_VISUAL) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_WA_WMCLASS) == GDK_WA_WMCLASS) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_WA_X) == GDK_WA_X) {
            w = alice_cons (Store::IntToWord (6), w);
        }
        if ((v & GDK_WA_Y) == GDK_WA_Y) {
            w = alice_cons (Store::IntToWord (7), w);
        }
    return w;
}
GdkWindowAttributesType GdkWindowAttributesTypetFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_WA_COLORMAP;
                break;
            case 1: r |= GDK_WA_CURSOR;
                break;
            case 2: r |= GDK_WA_NOREDIR;
                break;
            case 3: r |= GDK_WA_TITLE;
                break;
            case 4: r |= GDK_WA_VISUAL;
                break;
            case 5: r |= GDK_WA_WMCLASS;
                break;
            case 6: r |= GDK_WA_X;
                break;
            case 7: r |= GDK_WA_Y;
                break;
            default:
                Error ("GdkWindowAttributesTypetFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkWindowAttributesType)r;
}
DEFINE1(Gdk_WindowAttributesTypeToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkWindowAttributesTypetFromWord(x0));
} END
DEFINE1(Gdk_WindowAttributesTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowAttributesTypetToWord((GdkWindowAttributesType)i));
} END
DEFINE0(Gdk_WindowAttributesTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_ATTRIBUTES_TYPE));
} END
word GdkWindowTypetToWord(GdkWindowType v) {
    unsigned r = 0;
        if (v  == GDK_WINDOW_CHILD) {
            r = 0;
        } else 
        if (v  == GDK_WINDOW_DIALOG) {
            r = 1;
        } else 
        if (v  == GDK_WINDOW_FOREIGN) {
            r = 2;
        } else 
        if (v  == GDK_WINDOW_ROOT) {
            r = 3;
        } else 
        if (v  == GDK_WINDOW_TEMP) {
            r = 4;
        } else 
        if (v  == GDK_WINDOW_TOPLEVEL) {
            r = 5;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkWindowType GdkWindowTypetFromWord(word w) {
    GdkWindowType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_WINDOW_CHILD;
            break;
        case 1: r = GDK_WINDOW_DIALOG;
            break;
        case 2: r = GDK_WINDOW_FOREIGN;
            break;
        case 3: r = GDK_WINDOW_ROOT;
            break;
        case 4: r = GDK_WINDOW_TEMP;
            break;
        case 5: r = GDK_WINDOW_TOPLEVEL;
            break;
        default:
            Error ("GdkWindowTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_WindowTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkWindowTypetFromWord(x0));
} END
DEFINE1(Gdk_WindowTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowTypetToWord((GdkWindowType)i));
} END
DEFINE0(Gdk_WindowTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_TYPE));
} END
word GdkWindowClasstToWord(GdkWindowClass v) {
    unsigned r = 0;
        if (v  == GDK_INPUT_ONLY) {
            r = 0;
        } else 
        if (v  == GDK_INPUT_OUTPUT) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkWindowClass GdkWindowClasstFromWord(word w) {
    GdkWindowClass r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_INPUT_ONLY;
            break;
        case 1: r = GDK_INPUT_OUTPUT;
            break;
        default:
            Error ("GdkWindowClasstFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_WindowClassToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkWindowClasstFromWord(x0));
} END
DEFINE1(Gdk_WindowClassFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowClasstToWord((GdkWindowClass)i));
} END
DEFINE0(Gdk_WindowClassGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_CLASS));
} END
word GdkVisualTypetToWord(GdkVisualType v) {
    unsigned r = 0;
        if (v  == GDK_VISUAL_DIRECT_COLOR) {
            r = 0;
        } else 
        if (v  == GDK_VISUAL_GRAYSCALE) {
            r = 1;
        } else 
        if (v  == GDK_VISUAL_PSEUDO_COLOR) {
            r = 2;
        } else 
        if (v  == GDK_VISUAL_STATIC_COLOR) {
            r = 3;
        } else 
        if (v  == GDK_VISUAL_STATIC_GRAY) {
            r = 4;
        } else 
        if (v  == GDK_VISUAL_TRUE_COLOR) {
            r = 5;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkVisualType GdkVisualTypetFromWord(word w) {
    GdkVisualType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_VISUAL_DIRECT_COLOR;
            break;
        case 1: r = GDK_VISUAL_GRAYSCALE;
            break;
        case 2: r = GDK_VISUAL_PSEUDO_COLOR;
            break;
        case 3: r = GDK_VISUAL_STATIC_COLOR;
            break;
        case 4: r = GDK_VISUAL_STATIC_GRAY;
            break;
        case 5: r = GDK_VISUAL_TRUE_COLOR;
            break;
        default:
            Error ("GdkVisualTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_VisualTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkVisualTypetFromWord(x0));
} END
DEFINE1(Gdk_VisualTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkVisualTypetToWord((GdkVisualType)i));
} END
DEFINE0(Gdk_VisualTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_VISUAL_TYPE));
} END
word GdkGrabStatustToWord(GdkGrabStatus v) {
    unsigned r = 0;
        if (v  == GDK_GRAB_ALREADY_GRABBED) {
            r = 0;
        } else 
        if (v  == GDK_GRAB_FROZEN) {
            r = 1;
        } else 
        if (v  == GDK_GRAB_INVALID_TIME) {
            r = 2;
        } else 
        if (v  == GDK_GRAB_NOT_VIEWABLE) {
            r = 3;
        } else 
        if (v  == GDK_GRAB_SUCCESS) {
            r = 4;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkGrabStatus GdkGrabStatustFromWord(word w) {
    GdkGrabStatus r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_GRAB_ALREADY_GRABBED;
            break;
        case 1: r = GDK_GRAB_FROZEN;
            break;
        case 2: r = GDK_GRAB_INVALID_TIME;
            break;
        case 3: r = GDK_GRAB_NOT_VIEWABLE;
            break;
        case 4: r = GDK_GRAB_SUCCESS;
            break;
        default:
            Error ("GdkGrabStatustFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_GrabStatusToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkGrabStatustFromWord(x0));
} END
DEFINE1(Gdk_GrabStatusFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkGrabStatustToWord((GdkGrabStatus)i));
} END
DEFINE0(Gdk_GrabStatusGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_GRAB_STATUS));
} END
word GdkStatustToWord(GdkStatus v) {
    unsigned r = 0;
        if (v  == GDK_ERROR) {
            r = 0;
        } else 
        if (v  == GDK_ERROR_FILE) {
            r = 1;
        } else 
        if (v  == GDK_ERROR_MEM) {
            r = 2;
        } else 
        if (v  == GDK_ERROR_PARAM) {
            r = 3;
        } else 
        if (v  == GDK_OK) {
            r = 4;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkStatus GdkStatustFromWord(word w) {
    GdkStatus r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_ERROR;
            break;
        case 1: r = GDK_ERROR_FILE;
            break;
        case 2: r = GDK_ERROR_MEM;
            break;
        case 3: r = GDK_ERROR_PARAM;
            break;
        case 4: r = GDK_OK;
            break;
        default:
            Error ("GdkStatustFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_StatusToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkStatustFromWord(x0));
} END
DEFINE1(Gdk_StatusFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkStatustToWord((GdkStatus)i));
} END
DEFINE0(Gdk_StatusGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_STATUS));
} END
word GdkInputConditiontToWord(GdkInputCondition v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_INPUT_EXCEPTION) == GDK_INPUT_EXCEPTION) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_INPUT_READ) == GDK_INPUT_READ) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_INPUT_WRITE) == GDK_INPUT_WRITE) {
            w = alice_cons (Store::IntToWord (2), w);
        }
    return w;
}
GdkInputCondition GdkInputConditiontFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_INPUT_EXCEPTION;
                break;
            case 1: r |= GDK_INPUT_READ;
                break;
            case 2: r |= GDK_INPUT_WRITE;
                break;
            default:
                Error ("GdkInputConditiontFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkInputCondition)r;
}
DEFINE1(Gdk_InputConditionToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkInputConditiontFromWord(x0));
} END
DEFINE1(Gdk_InputConditionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkInputConditiontToWord((GdkInputCondition)i));
} END
DEFINE0(Gdk_InputConditionGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_INPUT_CONDITION));
} END
word GdkModifierTypetToWord(GdkModifierType v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_BUTTON1_MASK) == GDK_BUTTON1_MASK) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_BUTTON2_MASK) == GDK_BUTTON2_MASK) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_BUTTON3_MASK) == GDK_BUTTON3_MASK) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_BUTTON4_MASK) == GDK_BUTTON4_MASK) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_BUTTON5_MASK) == GDK_BUTTON5_MASK) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_CONTROL_MASK) == GDK_CONTROL_MASK) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_LOCK_MASK) == GDK_LOCK_MASK) {
            w = alice_cons (Store::IntToWord (6), w);
        }
        if ((v & GDK_MOD1_MASK) == GDK_MOD1_MASK) {
            w = alice_cons (Store::IntToWord (7), w);
        }
        if ((v & GDK_MOD2_MASK) == GDK_MOD2_MASK) {
            w = alice_cons (Store::IntToWord (8), w);
        }
        if ((v & GDK_MOD3_MASK) == GDK_MOD3_MASK) {
            w = alice_cons (Store::IntToWord (9), w);
        }
        if ((v & GDK_MOD4_MASK) == GDK_MOD4_MASK) {
            w = alice_cons (Store::IntToWord (10), w);
        }
        if ((v & GDK_MOD5_MASK) == GDK_MOD5_MASK) {
            w = alice_cons (Store::IntToWord (11), w);
        }
        if ((v & GDK_MODIFIER_MASK) == GDK_MODIFIER_MASK) {
            w = alice_cons (Store::IntToWord (12), w);
        }
        if ((v & GDK_RELEASE_MASK) == GDK_RELEASE_MASK) {
            w = alice_cons (Store::IntToWord (13), w);
        }
        if ((v & GDK_SHIFT_MASK) == GDK_SHIFT_MASK) {
            w = alice_cons (Store::IntToWord (14), w);
        }
    return w;
}
GdkModifierType GdkModifierTypetFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_BUTTON1_MASK;
                break;
            case 1: r |= GDK_BUTTON2_MASK;
                break;
            case 2: r |= GDK_BUTTON3_MASK;
                break;
            case 3: r |= GDK_BUTTON4_MASK;
                break;
            case 4: r |= GDK_BUTTON5_MASK;
                break;
            case 5: r |= GDK_CONTROL_MASK;
                break;
            case 6: r |= GDK_LOCK_MASK;
                break;
            case 7: r |= GDK_MOD1_MASK;
                break;
            case 8: r |= GDK_MOD2_MASK;
                break;
            case 9: r |= GDK_MOD3_MASK;
                break;
            case 10: r |= GDK_MOD4_MASK;
                break;
            case 11: r |= GDK_MOD5_MASK;
                break;
            case 12: r |= GDK_MODIFIER_MASK;
                break;
            case 13: r |= GDK_RELEASE_MASK;
                break;
            case 14: r |= GDK_SHIFT_MASK;
                break;
            default:
                Error ("GdkModifierTypetFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkModifierType)r;
}
DEFINE1(Gdk_ModifierTypeToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkModifierTypetFromWord(x0));
} END
DEFINE1(Gdk_ModifierTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkModifierTypetToWord((GdkModifierType)i));
} END
DEFINE0(Gdk_ModifierTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_MODIFIER_TYPE));
} END
word GdkByteOrdertToWord(GdkByteOrder v) {
    unsigned r = 0;
        if (v  == GDK_LSB_FIRST) {
            r = 0;
        } else 
        if (v  == GDK_MSB_FIRST) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkByteOrder GdkByteOrdertFromWord(word w) {
    GdkByteOrder r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_LSB_FIRST;
            break;
        case 1: r = GDK_MSB_FIRST;
            break;
        default:
            Error ("GdkByteOrdertFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_ByteOrderToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkByteOrdertFromWord(x0));
} END
DEFINE1(Gdk_ByteOrderFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkByteOrdertToWord((GdkByteOrder)i));
} END
DEFINE0(Gdk_ByteOrderGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_BYTE_ORDER));
} END
word GdkRgbDithertToWord(GdkRgbDither v) {
    unsigned r = 0;
        if (v  == GDK_RGB_DITHER_MAX) {
            r = 0;
        } else 
        if (v  == GDK_RGB_DITHER_NONE) {
            r = 1;
        } else 
        if (v  == GDK_RGB_DITHER_NORMAL) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkRgbDither GdkRgbDithertFromWord(word w) {
    GdkRgbDither r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_RGB_DITHER_MAX;
            break;
        case 1: r = GDK_RGB_DITHER_NONE;
            break;
        case 2: r = GDK_RGB_DITHER_NORMAL;
            break;
        default:
            Error ("GdkRgbDithertFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_RgbDitherToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkRgbDithertFromWord(x0));
} END
DEFINE1(Gdk_RgbDitherFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkRgbDithertToWord((GdkRgbDither)i));
} END
DEFINE0(Gdk_RgbDitherGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_RGB_DITHER));
} END
word GdkOverlapTypetToWord(GdkOverlapType v) {
    unsigned r = 0;
        if (v  == GDK_OVERLAP_RECTANGLE_IN) {
            r = 0;
        } else 
        if (v  == GDK_OVERLAP_RECTANGLE_OUT) {
            r = 1;
        } else 
        if (v  == GDK_OVERLAP_RECTANGLE_PART) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkOverlapType GdkOverlapTypetFromWord(word w) {
    GdkOverlapType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_OVERLAP_RECTANGLE_IN;
            break;
        case 1: r = GDK_OVERLAP_RECTANGLE_OUT;
            break;
        case 2: r = GDK_OVERLAP_RECTANGLE_PART;
            break;
        default:
            Error ("GdkOverlapTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_OverlapTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkOverlapTypetFromWord(x0));
} END
DEFINE1(Gdk_OverlapTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkOverlapTypetToWord((GdkOverlapType)i));
} END
DEFINE0(Gdk_OverlapTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_OVERLAP_TYPE));
} END
word GdkFillRuletToWord(GdkFillRule v) {
    unsigned r = 0;
        if (v  == GDK_EVEN_ODD_RULE) {
            r = 0;
        } else 
        if (v  == GDK_WINDING_RULE) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkFillRule GdkFillRuletFromWord(word w) {
    GdkFillRule r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_EVEN_ODD_RULE;
            break;
        case 1: r = GDK_WINDING_RULE;
            break;
        default:
            Error ("GdkFillRuletFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_FillRuleToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkFillRuletFromWord(x0));
} END
DEFINE1(Gdk_FillRuleFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkFillRuletToWord((GdkFillRule)i));
} END
DEFINE0(Gdk_FillRuleGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_FILL_RULE));
} END
word GdkPropModetToWord(GdkPropMode v) {
    unsigned r = 0;
        if (v  == GDK_PROP_MODE_APPEND) {
            r = 0;
        } else 
        if (v  == GDK_PROP_MODE_PREPEND) {
            r = 1;
        } else 
        if (v  == GDK_PROP_MODE_REPLACE) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkPropMode GdkPropModetFromWord(word w) {
    GdkPropMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_PROP_MODE_APPEND;
            break;
        case 1: r = GDK_PROP_MODE_PREPEND;
            break;
        case 2: r = GDK_PROP_MODE_REPLACE;
            break;
        default:
            Error ("GdkPropModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_PropModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkPropModetFromWord(x0));
} END
DEFINE1(Gdk_PropModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkPropModetToWord((GdkPropMode)i));
} END
DEFINE0(Gdk_PropModeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_PROP_MODE));
} END
word GdkAxisUsetToWord(GdkAxisUse v) {
    unsigned r = 0;
        if (v  == GDK_AXIS_IGNORE) {
            r = 0;
        } else 
        if (v  == GDK_AXIS_LAST) {
            r = 1;
        } else 
        if (v  == GDK_AXIS_PRESSURE) {
            r = 2;
        } else 
        if (v  == GDK_AXIS_WHEEL) {
            r = 3;
        } else 
        if (v  == GDK_AXIS_X) {
            r = 4;
        } else 
        if (v  == GDK_AXIS_XTILT) {
            r = 5;
        } else 
        if (v  == GDK_AXIS_Y) {
            r = 6;
        } else 
        if (v  == GDK_AXIS_YTILT) {
            r = 7;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkAxisUse GdkAxisUsetFromWord(word w) {
    GdkAxisUse r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_AXIS_IGNORE;
            break;
        case 1: r = GDK_AXIS_LAST;
            break;
        case 2: r = GDK_AXIS_PRESSURE;
            break;
        case 3: r = GDK_AXIS_WHEEL;
            break;
        case 4: r = GDK_AXIS_X;
            break;
        case 5: r = GDK_AXIS_XTILT;
            break;
        case 6: r = GDK_AXIS_Y;
            break;
        case 7: r = GDK_AXIS_YTILT;
            break;
        default:
            Error ("GdkAxisUsetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_AxisUseToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkAxisUsetFromWord(x0));
} END
DEFINE1(Gdk_AxisUseFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkAxisUsetToWord((GdkAxisUse)i));
} END
DEFINE0(Gdk_AxisUseGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_AXIS_USE));
} END
word GdkInputModetToWord(GdkInputMode v) {
    unsigned r = 0;
        if (v  == GDK_MODE_DISABLED) {
            r = 0;
        } else 
        if (v  == GDK_MODE_SCREEN) {
            r = 1;
        } else 
        if (v  == GDK_MODE_WINDOW) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkInputMode GdkInputModetFromWord(word w) {
    GdkInputMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_MODE_DISABLED;
            break;
        case 1: r = GDK_MODE_SCREEN;
            break;
        case 2: r = GDK_MODE_WINDOW;
            break;
        default:
            Error ("GdkInputModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_InputModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkInputModetFromWord(x0));
} END
DEFINE1(Gdk_InputModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkInputModetToWord((GdkInputMode)i));
} END
DEFINE0(Gdk_InputModeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_INPUT_MODE));
} END
word GdkInputSourcetToWord(GdkInputSource v) {
    unsigned r = 0;
        if (v  == GDK_SOURCE_CURSOR) {
            r = 0;
        } else 
        if (v  == GDK_SOURCE_ERASER) {
            r = 1;
        } else 
        if (v  == GDK_SOURCE_MOUSE) {
            r = 2;
        } else 
        if (v  == GDK_SOURCE_PEN) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkInputSource GdkInputSourcetFromWord(word w) {
    GdkInputSource r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_SOURCE_CURSOR;
            break;
        case 1: r = GDK_SOURCE_ERASER;
            break;
        case 2: r = GDK_SOURCE_MOUSE;
            break;
        case 3: r = GDK_SOURCE_PEN;
            break;
        default:
            Error ("GdkInputSourcetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_InputSourceToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkInputSourcetFromWord(x0));
} END
DEFINE1(Gdk_InputSourceFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkInputSourcetToWord((GdkInputSource)i));
} END
DEFINE0(Gdk_InputSourceGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_INPUT_SOURCE));
} END
word GdkExtensionModetToWord(GdkExtensionMode v) {
    unsigned r = 0;
        if (v  == GDK_EXTENSION_EVENTS_ALL) {
            r = 0;
        } else 
        if (v  == GDK_EXTENSION_EVENTS_CURSOR) {
            r = 1;
        } else 
        if (v  == GDK_EXTENSION_EVENTS_NONE) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkExtensionMode GdkExtensionModetFromWord(word w) {
    GdkExtensionMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_EXTENSION_EVENTS_ALL;
            break;
        case 1: r = GDK_EXTENSION_EVENTS_CURSOR;
            break;
        case 2: r = GDK_EXTENSION_EVENTS_NONE;
            break;
        default:
            Error ("GdkExtensionModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_ExtensionModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkExtensionModetFromWord(x0));
} END
DEFINE1(Gdk_ExtensionModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkExtensionModetToWord((GdkExtensionMode)i));
} END
DEFINE0(Gdk_ExtensionModeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_EXTENSION_MODE));
} END
word GdkImageTypetToWord(GdkImageType v) {
    unsigned r = 0;
        if (v  == GDK_IMAGE_FASTEST) {
            r = 0;
        } else 
        if (v  == GDK_IMAGE_NORMAL) {
            r = 1;
        } else 
        if (v  == GDK_IMAGE_SHARED) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkImageType GdkImageTypetFromWord(word w) {
    GdkImageType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_IMAGE_FASTEST;
            break;
        case 1: r = GDK_IMAGE_NORMAL;
            break;
        case 2: r = GDK_IMAGE_SHARED;
            break;
        default:
            Error ("GdkImageTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_ImageTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkImageTypetFromWord(x0));
} END
DEFINE1(Gdk_ImageTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkImageTypetToWord((GdkImageType)i));
} END
DEFINE0(Gdk_ImageTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_IMAGE_TYPE));
} END
word GdkGCValuesMasktToWord(GdkGCValuesMask v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_GC_BACKGROUND) == GDK_GC_BACKGROUND) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_GC_CAP_STYLE) == GDK_GC_CAP_STYLE) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_GC_CLIP_MASK) == GDK_GC_CLIP_MASK) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_GC_CLIP_X_ORIGIN) == GDK_GC_CLIP_X_ORIGIN) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_GC_CLIP_Y_ORIGIN) == GDK_GC_CLIP_Y_ORIGIN) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_GC_EXPOSURES) == GDK_GC_EXPOSURES) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_GC_FILL) == GDK_GC_FILL) {
            w = alice_cons (Store::IntToWord (6), w);
        }
        if ((v & GDK_GC_FONT) == GDK_GC_FONT) {
            w = alice_cons (Store::IntToWord (7), w);
        }
        if ((v & GDK_GC_FOREGROUND) == GDK_GC_FOREGROUND) {
            w = alice_cons (Store::IntToWord (8), w);
        }
        if ((v & GDK_GC_FUNCTION) == GDK_GC_FUNCTION) {
            w = alice_cons (Store::IntToWord (9), w);
        }
        if ((v & GDK_GC_JOIN_STYLE) == GDK_GC_JOIN_STYLE) {
            w = alice_cons (Store::IntToWord (10), w);
        }
        if ((v & GDK_GC_LINE_STYLE) == GDK_GC_LINE_STYLE) {
            w = alice_cons (Store::IntToWord (11), w);
        }
        if ((v & GDK_GC_LINE_WIDTH) == GDK_GC_LINE_WIDTH) {
            w = alice_cons (Store::IntToWord (12), w);
        }
        if ((v & GDK_GC_STIPPLE) == GDK_GC_STIPPLE) {
            w = alice_cons (Store::IntToWord (13), w);
        }
        if ((v & GDK_GC_SUBWINDOW) == GDK_GC_SUBWINDOW) {
            w = alice_cons (Store::IntToWord (14), w);
        }
        if ((v & GDK_GC_TILE) == GDK_GC_TILE) {
            w = alice_cons (Store::IntToWord (15), w);
        }
        if ((v & GDK_GC_TS_X_ORIGIN) == GDK_GC_TS_X_ORIGIN) {
            w = alice_cons (Store::IntToWord (16), w);
        }
        if ((v & GDK_GC_TS_Y_ORIGIN) == GDK_GC_TS_Y_ORIGIN) {
            w = alice_cons (Store::IntToWord (17), w);
        }
    return w;
}
GdkGCValuesMask GdkGCValuesMasktFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_GC_BACKGROUND;
                break;
            case 1: r |= GDK_GC_CAP_STYLE;
                break;
            case 2: r |= GDK_GC_CLIP_MASK;
                break;
            case 3: r |= GDK_GC_CLIP_X_ORIGIN;
                break;
            case 4: r |= GDK_GC_CLIP_Y_ORIGIN;
                break;
            case 5: r |= GDK_GC_EXPOSURES;
                break;
            case 6: r |= GDK_GC_FILL;
                break;
            case 7: r |= GDK_GC_FONT;
                break;
            case 8: r |= GDK_GC_FOREGROUND;
                break;
            case 9: r |= GDK_GC_FUNCTION;
                break;
            case 10: r |= GDK_GC_JOIN_STYLE;
                break;
            case 11: r |= GDK_GC_LINE_STYLE;
                break;
            case 12: r |= GDK_GC_LINE_WIDTH;
                break;
            case 13: r |= GDK_GC_STIPPLE;
                break;
            case 14: r |= GDK_GC_SUBWINDOW;
                break;
            case 15: r |= GDK_GC_TILE;
                break;
            case 16: r |= GDK_GC_TS_X_ORIGIN;
                break;
            case 17: r |= GDK_GC_TS_Y_ORIGIN;
                break;
            default:
                Error ("GdkGCValuesMasktFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkGCValuesMask)r;
}
DEFINE1(Gdk_GCValuesMaskToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkGCValuesMasktFromWord(x0));
} END
DEFINE1(Gdk_GCValuesMaskFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkGCValuesMasktToWord((GdkGCValuesMask)i));
} END
DEFINE0(Gdk_GCValuesMaskGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_GC_VALUES_MASK));
} END
word GdkSubwindowModetToWord(GdkSubwindowMode v) {
    unsigned r = 0;
        if (v  == GDK_CLIP_BY_CHILDREN) {
            r = 0;
        } else 
        if (v  == GDK_INCLUDE_INFERIORS) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkSubwindowMode GdkSubwindowModetFromWord(word w) {
    GdkSubwindowMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_CLIP_BY_CHILDREN;
            break;
        case 1: r = GDK_INCLUDE_INFERIORS;
            break;
        default:
            Error ("GdkSubwindowModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_SubwindowModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkSubwindowModetFromWord(x0));
} END
DEFINE1(Gdk_SubwindowModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkSubwindowModetToWord((GdkSubwindowMode)i));
} END
DEFINE0(Gdk_SubwindowModeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_SUBWINDOW_MODE));
} END
word GdkLineStyletToWord(GdkLineStyle v) {
    unsigned r = 0;
        if (v  == GDK_LINE_DOUBLE_DASH) {
            r = 0;
        } else 
        if (v  == GDK_LINE_ON_OFF_DASH) {
            r = 1;
        } else 
        if (v  == GDK_LINE_SOLID) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkLineStyle GdkLineStyletFromWord(word w) {
    GdkLineStyle r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_LINE_DOUBLE_DASH;
            break;
        case 1: r = GDK_LINE_ON_OFF_DASH;
            break;
        case 2: r = GDK_LINE_SOLID;
            break;
        default:
            Error ("GdkLineStyletFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_LineStyleToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkLineStyletFromWord(x0));
} END
DEFINE1(Gdk_LineStyleFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkLineStyletToWord((GdkLineStyle)i));
} END
DEFINE0(Gdk_LineStyleGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_LINE_STYLE));
} END
word GdkJoinStyletToWord(GdkJoinStyle v) {
    unsigned r = 0;
        if (v  == GDK_JOIN_BEVEL) {
            r = 0;
        } else 
        if (v  == GDK_JOIN_MITER) {
            r = 1;
        } else 
        if (v  == GDK_JOIN_ROUND) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkJoinStyle GdkJoinStyletFromWord(word w) {
    GdkJoinStyle r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_JOIN_BEVEL;
            break;
        case 1: r = GDK_JOIN_MITER;
            break;
        case 2: r = GDK_JOIN_ROUND;
            break;
        default:
            Error ("GdkJoinStyletFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_JoinStyleToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkJoinStyletFromWord(x0));
} END
DEFINE1(Gdk_JoinStyleFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkJoinStyletToWord((GdkJoinStyle)i));
} END
DEFINE0(Gdk_JoinStyleGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_JOIN_STYLE));
} END
word GdkFunctiontToWord(GdkFunction v) {
    unsigned r = 0;
        if (v  == GDK_AND) {
            r = 0;
        } else 
        if (v  == GDK_AND_INVERT) {
            r = 1;
        } else 
        if (v  == GDK_AND_REVERSE) {
            r = 2;
        } else 
        if (v  == GDK_CLEAR) {
            r = 3;
        } else 
        if (v  == GDK_COPY) {
            r = 4;
        } else 
        if (v  == GDK_COPY_INVERT) {
            r = 5;
        } else 
        if (v  == GDK_EQUIV) {
            r = 6;
        } else 
        if (v  == GDK_INVERT) {
            r = 7;
        } else 
        if (v  == GDK_NAND) {
            r = 8;
        } else 
        if (v  == GDK_NOOP) {
            r = 9;
        } else 
        if (v  == GDK_NOR) {
            r = 10;
        } else 
        if (v  == GDK_OR) {
            r = 11;
        } else 
        if (v  == GDK_OR_INVERT) {
            r = 12;
        } else 
        if (v  == GDK_OR_REVERSE) {
            r = 13;
        } else 
        if (v  == GDK_SET) {
            r = 14;
        } else 
        if (v  == GDK_XOR) {
            r = 15;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkFunction GdkFunctiontFromWord(word w) {
    GdkFunction r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_AND;
            break;
        case 1: r = GDK_AND_INVERT;
            break;
        case 2: r = GDK_AND_REVERSE;
            break;
        case 3: r = GDK_CLEAR;
            break;
        case 4: r = GDK_COPY;
            break;
        case 5: r = GDK_COPY_INVERT;
            break;
        case 6: r = GDK_EQUIV;
            break;
        case 7: r = GDK_INVERT;
            break;
        case 8: r = GDK_NAND;
            break;
        case 9: r = GDK_NOOP;
            break;
        case 10: r = GDK_NOR;
            break;
        case 11: r = GDK_OR;
            break;
        case 12: r = GDK_OR_INVERT;
            break;
        case 13: r = GDK_OR_REVERSE;
            break;
        case 14: r = GDK_SET;
            break;
        case 15: r = GDK_XOR;
            break;
        default:
            Error ("GdkFunctiontFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_FunctionToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkFunctiontFromWord(x0));
} END
DEFINE1(Gdk_FunctionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkFunctiontToWord((GdkFunction)i));
} END
DEFINE0(Gdk_FunctionGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_FUNCTION));
} END
word GdkFilltToWord(GdkFill v) {
    unsigned r = 0;
        if (v  == GDK_OPAQUE_STIPPLED) {
            r = 0;
        } else 
        if (v  == GDK_SOLID) {
            r = 1;
        } else 
        if (v  == GDK_STIPPLED) {
            r = 2;
        } else 
        if (v  == GDK_TILED) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkFill GdkFilltFromWord(word w) {
    GdkFill r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_OPAQUE_STIPPLED;
            break;
        case 1: r = GDK_SOLID;
            break;
        case 2: r = GDK_STIPPLED;
            break;
        case 3: r = GDK_TILED;
            break;
        default:
            Error ("GdkFilltFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_FillToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkFilltFromWord(x0));
} END
DEFINE1(Gdk_FillFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkFilltToWord((GdkFill)i));
} END
DEFINE0(Gdk_FillGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_FILL));
} END
word GdkCapStyletToWord(GdkCapStyle v) {
    unsigned r = 0;
        if (v  == GDK_CAP_BUTT) {
            r = 0;
        } else 
        if (v  == GDK_CAP_NOT_LAST) {
            r = 1;
        } else 
        if (v  == GDK_CAP_PROJECTING) {
            r = 2;
        } else 
        if (v  == GDK_CAP_ROUND) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkCapStyle GdkCapStyletFromWord(word w) {
    GdkCapStyle r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_CAP_BUTT;
            break;
        case 1: r = GDK_CAP_NOT_LAST;
            break;
        case 2: r = GDK_CAP_PROJECTING;
            break;
        case 3: r = GDK_CAP_ROUND;
            break;
        default:
            Error ("GdkCapStyletFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_CapStyleToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkCapStyletFromWord(x0));
} END
DEFINE1(Gdk_CapStyleFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkCapStyletToWord((GdkCapStyle)i));
} END
DEFINE0(Gdk_CapStyleGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_CAP_STYLE));
} END
word GdkFontTypetToWord(GdkFontType v) {
    unsigned r = 0;
        if (v  == GDK_FONT_FONT) {
            r = 0;
        } else 
        if (v  == GDK_FONT_FONTSET) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkFontType GdkFontTypetFromWord(word w) {
    GdkFontType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_FONT_FONT;
            break;
        case 1: r = GDK_FONT_FONTSET;
            break;
        default:
            Error ("GdkFontTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_FontTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkFontTypetFromWord(x0));
} END
DEFINE1(Gdk_FontTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkFontTypetToWord((GdkFontType)i));
} END
DEFINE0(Gdk_FontTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_FONT_TYPE));
} END
word GdkSettingActiontToWord(GdkSettingAction v) {
    unsigned r = 0;
        if (v  == GDK_SETTING_ACTION_CHANGED) {
            r = 0;
        } else 
        if (v  == GDK_SETTING_ACTION_DELETED) {
            r = 1;
        } else 
        if (v  == GDK_SETTING_ACTION_NEW) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkSettingAction GdkSettingActiontFromWord(word w) {
    GdkSettingAction r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_SETTING_ACTION_CHANGED;
            break;
        case 1: r = GDK_SETTING_ACTION_DELETED;
            break;
        case 2: r = GDK_SETTING_ACTION_NEW;
            break;
        default:
            Error ("GdkSettingActiontFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_SettingActionToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkSettingActiontFromWord(x0));
} END
DEFINE1(Gdk_SettingActionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkSettingActiontToWord((GdkSettingAction)i));
} END
DEFINE0(Gdk_SettingActionGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_SETTING_ACTION));
} END
word GdkWindowStatetToWord(GdkWindowState v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_WINDOW_STATE_ABOVE) == GDK_WINDOW_STATE_ABOVE) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_WINDOW_STATE_BELOW) == GDK_WINDOW_STATE_BELOW) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_WINDOW_STATE_FULLSCREEN) == GDK_WINDOW_STATE_FULLSCREEN) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_WINDOW_STATE_ICONIFIED) == GDK_WINDOW_STATE_ICONIFIED) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_WINDOW_STATE_MAXIMIZED) == GDK_WINDOW_STATE_MAXIMIZED) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_WINDOW_STATE_STICKY) == GDK_WINDOW_STATE_STICKY) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_WINDOW_STATE_WITHDRAWN) == GDK_WINDOW_STATE_WITHDRAWN) {
            w = alice_cons (Store::IntToWord (6), w);
        }
    return w;
}
GdkWindowState GdkWindowStatetFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_WINDOW_STATE_ABOVE;
                break;
            case 1: r |= GDK_WINDOW_STATE_BELOW;
                break;
            case 2: r |= GDK_WINDOW_STATE_FULLSCREEN;
                break;
            case 3: r |= GDK_WINDOW_STATE_ICONIFIED;
                break;
            case 4: r |= GDK_WINDOW_STATE_MAXIMIZED;
                break;
            case 5: r |= GDK_WINDOW_STATE_STICKY;
                break;
            case 6: r |= GDK_WINDOW_STATE_WITHDRAWN;
                break;
            default:
                Error ("GdkWindowStatetFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkWindowState)r;
}
DEFINE1(Gdk_WindowStateToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkWindowStatetFromWord(x0));
} END
DEFINE1(Gdk_WindowStateFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkWindowStatetToWord((GdkWindowState)i));
} END
DEFINE0(Gdk_WindowStateGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_WINDOW_STATE));
} END
word GdkPropertyStatetToWord(GdkPropertyState v) {
    unsigned r = 0;
        if (v  == GDK_PROPERTY_DELETE) {
            r = 0;
        } else 
        if (v  == GDK_PROPERTY_NEW_VALUE) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkPropertyState GdkPropertyStatetFromWord(word w) {
    GdkPropertyState r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_PROPERTY_DELETE;
            break;
        case 1: r = GDK_PROPERTY_NEW_VALUE;
            break;
        default:
            Error ("GdkPropertyStatetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_PropertyStateToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkPropertyStatetFromWord(x0));
} END
DEFINE1(Gdk_PropertyStateFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkPropertyStatetToWord((GdkPropertyState)i));
} END
DEFINE0(Gdk_PropertyStateGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_PROPERTY_STATE));
} END
word GdkCrossingModetToWord(GdkCrossingMode v) {
    unsigned r = 0;
        if (v  == GDK_CROSSING_GRAB) {
            r = 0;
        } else 
        if (v  == GDK_CROSSING_NORMAL) {
            r = 1;
        } else 
        if (v  == GDK_CROSSING_UNGRAB) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkCrossingMode GdkCrossingModetFromWord(word w) {
    GdkCrossingMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_CROSSING_GRAB;
            break;
        case 1: r = GDK_CROSSING_NORMAL;
            break;
        case 2: r = GDK_CROSSING_UNGRAB;
            break;
        default:
            Error ("GdkCrossingModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_CrossingModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkCrossingModetFromWord(x0));
} END
DEFINE1(Gdk_CrossingModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkCrossingModetToWord((GdkCrossingMode)i));
} END
DEFINE0(Gdk_CrossingModeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_CROSSING_MODE));
} END
word GdkNotifyTypetToWord(GdkNotifyType v) {
    unsigned r = 0;
        if (v  == GDK_NOTIFY_ANCESTOR) {
            r = 0;
        } else 
        if (v  == GDK_NOTIFY_INFERIOR) {
            r = 1;
        } else 
        if (v  == GDK_NOTIFY_NONLINEAR) {
            r = 2;
        } else 
        if (v  == GDK_NOTIFY_NONLINEAR_VIRTUAL) {
            r = 3;
        } else 
        if (v  == GDK_NOTIFY_UNKNOWN) {
            r = 4;
        } else 
        if (v  == GDK_NOTIFY_VIRTUAL) {
            r = 5;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkNotifyType GdkNotifyTypetFromWord(word w) {
    GdkNotifyType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_NOTIFY_ANCESTOR;
            break;
        case 1: r = GDK_NOTIFY_INFERIOR;
            break;
        case 2: r = GDK_NOTIFY_NONLINEAR;
            break;
        case 3: r = GDK_NOTIFY_NONLINEAR_VIRTUAL;
            break;
        case 4: r = GDK_NOTIFY_UNKNOWN;
            break;
        case 5: r = GDK_NOTIFY_VIRTUAL;
            break;
        default:
            Error ("GdkNotifyTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_NotifyTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkNotifyTypetFromWord(x0));
} END
DEFINE1(Gdk_NotifyTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkNotifyTypetToWord((GdkNotifyType)i));
} END
DEFINE0(Gdk_NotifyTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_NOTIFY_TYPE));
} END
word GdkScrollDirectiontToWord(GdkScrollDirection v) {
    unsigned r = 0;
        if (v  == GDK_SCROLL_DOWN) {
            r = 0;
        } else 
        if (v  == GDK_SCROLL_LEFT) {
            r = 1;
        } else 
        if (v  == GDK_SCROLL_RIGHT) {
            r = 2;
        } else 
        if (v  == GDK_SCROLL_UP) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkScrollDirection GdkScrollDirectiontFromWord(word w) {
    GdkScrollDirection r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_SCROLL_DOWN;
            break;
        case 1: r = GDK_SCROLL_LEFT;
            break;
        case 2: r = GDK_SCROLL_RIGHT;
            break;
        case 3: r = GDK_SCROLL_UP;
            break;
        default:
            Error ("GdkScrollDirectiontFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_ScrollDirectionToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkScrollDirectiontFromWord(x0));
} END
DEFINE1(Gdk_ScrollDirectionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkScrollDirectiontToWord((GdkScrollDirection)i));
} END
DEFINE0(Gdk_ScrollDirectionGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_SCROLL_DIRECTION));
} END
word GdkVisibilityStatetToWord(GdkVisibilityState v) {
    unsigned r = 0;
        if (v  == GDK_VISIBILITY_FULLY_OBSCURED) {
            r = 0;
        } else 
        if (v  == GDK_VISIBILITY_PARTIAL) {
            r = 1;
        } else 
        if (v  == GDK_VISIBILITY_UNOBSCURED) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkVisibilityState GdkVisibilityStatetFromWord(word w) {
    GdkVisibilityState r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_VISIBILITY_FULLY_OBSCURED;
            break;
        case 1: r = GDK_VISIBILITY_PARTIAL;
            break;
        case 2: r = GDK_VISIBILITY_UNOBSCURED;
            break;
        default:
            Error ("GdkVisibilityStatetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_VisibilityStateToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkVisibilityStatetFromWord(x0));
} END
DEFINE1(Gdk_VisibilityStateFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkVisibilityStatetToWord((GdkVisibilityState)i));
} END
DEFINE0(Gdk_VisibilityStateGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_VISIBILITY_STATE));
} END
word GdkEventMasktToWord(GdkEventMask v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_ALL_EVENTS_MASK) == GDK_ALL_EVENTS_MASK) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_BUTTON1_MOTION_MASK) == GDK_BUTTON1_MOTION_MASK) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_BUTTON2_MOTION_MASK) == GDK_BUTTON2_MOTION_MASK) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_BUTTON3_MOTION_MASK) == GDK_BUTTON3_MOTION_MASK) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_BUTTON_MOTION_MASK) == GDK_BUTTON_MOTION_MASK) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_BUTTON_PRESS_MASK) == GDK_BUTTON_PRESS_MASK) {
            w = alice_cons (Store::IntToWord (5), w);
        }
        if ((v & GDK_BUTTON_RELEASE_MASK) == GDK_BUTTON_RELEASE_MASK) {
            w = alice_cons (Store::IntToWord (6), w);
        }
        if ((v & GDK_ENTER_NOTIFY_MASK) == GDK_ENTER_NOTIFY_MASK) {
            w = alice_cons (Store::IntToWord (7), w);
        }
        if ((v & GDK_EXPOSURE_MASK) == GDK_EXPOSURE_MASK) {
            w = alice_cons (Store::IntToWord (8), w);
        }
        if ((v & GDK_FOCUS_CHANGE_MASK) == GDK_FOCUS_CHANGE_MASK) {
            w = alice_cons (Store::IntToWord (9), w);
        }
        if ((v & GDK_KEY_PRESS_MASK) == GDK_KEY_PRESS_MASK) {
            w = alice_cons (Store::IntToWord (10), w);
        }
        if ((v & GDK_KEY_RELEASE_MASK) == GDK_KEY_RELEASE_MASK) {
            w = alice_cons (Store::IntToWord (11), w);
        }
        if ((v & GDK_LEAVE_NOTIFY_MASK) == GDK_LEAVE_NOTIFY_MASK) {
            w = alice_cons (Store::IntToWord (12), w);
        }
        if ((v & GDK_POINTER_MOTION_HINT_MASK) == GDK_POINTER_MOTION_HINT_MASK) {
            w = alice_cons (Store::IntToWord (13), w);
        }
        if ((v & GDK_POINTER_MOTION_MASK) == GDK_POINTER_MOTION_MASK) {
            w = alice_cons (Store::IntToWord (14), w);
        }
        if ((v & GDK_PROPERTY_CHANGE_MASK) == GDK_PROPERTY_CHANGE_MASK) {
            w = alice_cons (Store::IntToWord (15), w);
        }
        if ((v & GDK_PROXIMITY_IN_MASK) == GDK_PROXIMITY_IN_MASK) {
            w = alice_cons (Store::IntToWord (16), w);
        }
        if ((v & GDK_PROXIMITY_OUT_MASK) == GDK_PROXIMITY_OUT_MASK) {
            w = alice_cons (Store::IntToWord (17), w);
        }
        if ((v & GDK_SCROLL_MASK) == GDK_SCROLL_MASK) {
            w = alice_cons (Store::IntToWord (18), w);
        }
        if ((v & GDK_STRUCTURE_MASK) == GDK_STRUCTURE_MASK) {
            w = alice_cons (Store::IntToWord (19), w);
        }
        if ((v & GDK_SUBSTRUCTURE_MASK) == GDK_SUBSTRUCTURE_MASK) {
            w = alice_cons (Store::IntToWord (20), w);
        }
        if ((v & GDK_VISIBILITY_NOTIFY_MASK) == GDK_VISIBILITY_NOTIFY_MASK) {
            w = alice_cons (Store::IntToWord (21), w);
        }
    return w;
}
GdkEventMask GdkEventMasktFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_ALL_EVENTS_MASK;
                break;
            case 1: r |= GDK_BUTTON1_MOTION_MASK;
                break;
            case 2: r |= GDK_BUTTON2_MOTION_MASK;
                break;
            case 3: r |= GDK_BUTTON3_MOTION_MASK;
                break;
            case 4: r |= GDK_BUTTON_MOTION_MASK;
                break;
            case 5: r |= GDK_BUTTON_PRESS_MASK;
                break;
            case 6: r |= GDK_BUTTON_RELEASE_MASK;
                break;
            case 7: r |= GDK_ENTER_NOTIFY_MASK;
                break;
            case 8: r |= GDK_EXPOSURE_MASK;
                break;
            case 9: r |= GDK_FOCUS_CHANGE_MASK;
                break;
            case 10: r |= GDK_KEY_PRESS_MASK;
                break;
            case 11: r |= GDK_KEY_RELEASE_MASK;
                break;
            case 12: r |= GDK_LEAVE_NOTIFY_MASK;
                break;
            case 13: r |= GDK_POINTER_MOTION_HINT_MASK;
                break;
            case 14: r |= GDK_POINTER_MOTION_MASK;
                break;
            case 15: r |= GDK_PROPERTY_CHANGE_MASK;
                break;
            case 16: r |= GDK_PROXIMITY_IN_MASK;
                break;
            case 17: r |= GDK_PROXIMITY_OUT_MASK;
                break;
            case 18: r |= GDK_SCROLL_MASK;
                break;
            case 19: r |= GDK_STRUCTURE_MASK;
                break;
            case 20: r |= GDK_SUBSTRUCTURE_MASK;
                break;
            case 21: r |= GDK_VISIBILITY_NOTIFY_MASK;
                break;
            default:
                Error ("GdkEventMasktFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkEventMask)r;
}
DEFINE1(Gdk_EventMaskToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkEventMasktFromWord(x0));
} END
DEFINE1(Gdk_EventMaskFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkEventMasktToWord((GdkEventMask)i));
} END
DEFINE0(Gdk_EventMaskGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_EVENT_MASK));
} END
word GdkEventTypetToWord(GdkEventType v) {
    unsigned r = 0;
        if (v  == GDK_2BUTTON_PRESS) {
            r = 0;
        } else 
        if (v  == GDK_3BUTTON_PRESS) {
            r = 1;
        } else 
        if (v  == GDK_BUTTON_PRESS) {
            r = 2;
        } else 
        if (v  == GDK_BUTTON_RELEASE) {
            r = 3;
        } else 
        if (v  == GDK_CLIENT_EVENT) {
            r = 4;
        } else 
        if (v  == GDK_CONFIGURE) {
            r = 5;
        } else 
        if (v  == GDK_DELETE) {
            r = 6;
        } else 
        if (v  == GDK_DESTROY) {
            r = 7;
        } else 
        if (v  == GDK_DRAG_ENTER) {
            r = 8;
        } else 
        if (v  == GDK_DRAG_LEAVE) {
            r = 9;
        } else 
        if (v  == GDK_DRAG_MOTION) {
            r = 10;
        } else 
        if (v  == GDK_DRAG_STATUS) {
            r = 11;
        } else 
        if (v  == GDK_DROP_FINISHED) {
            r = 12;
        } else 
        if (v  == GDK_DROP_START) {
            r = 13;
        } else 
        if (v  == GDK_ENTER_NOTIFY) {
            r = 14;
        } else 
        if (v  == GDK_EXPOSE) {
            r = 15;
        } else 
        if (v  == GDK_FOCUS_CHANGE) {
            r = 16;
        } else 
        if (v  == GDK_KEY_PRESS) {
            r = 17;
        } else 
        if (v  == GDK_KEY_RELEASE) {
            r = 18;
        } else 
        if (v  == GDK_LEAVE_NOTIFY) {
            r = 19;
        } else 
        if (v  == GDK_MAP) {
            r = 20;
        } else 
        if (v  == GDK_MOTION_NOTIFY) {
            r = 21;
        } else 
        if (v  == GDK_NOTHING) {
            r = 22;
        } else 
        if (v  == GDK_NO_EXPOSE) {
            r = 23;
        } else 
        if (v  == GDK_PROPERTY_NOTIFY) {
            r = 24;
        } else 
        if (v  == GDK_PROXIMITY_IN) {
            r = 25;
        } else 
        if (v  == GDK_PROXIMITY_OUT) {
            r = 26;
        } else 
        if (v  == GDK_SCROLL) {
            r = 27;
        } else 
        if (v  == GDK_SELECTION_CLEAR) {
            r = 28;
        } else 
        if (v  == GDK_SELECTION_NOTIFY) {
            r = 29;
        } else 
        if (v  == GDK_SELECTION_REQUEST) {
            r = 30;
        } else 
        if (v  == GDK_SETTING) {
            r = 31;
        } else 
        if (v  == GDK_UNMAP) {
            r = 32;
        } else 
        if (v  == GDK_VISIBILITY_NOTIFY) {
            r = 33;
        } else 
        if (v  == GDK_WINDOW_STATE) {
            r = 34;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkEventType GdkEventTypetFromWord(word w) {
    GdkEventType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_2BUTTON_PRESS;
            break;
        case 1: r = GDK_3BUTTON_PRESS;
            break;
        case 2: r = GDK_BUTTON_PRESS;
            break;
        case 3: r = GDK_BUTTON_RELEASE;
            break;
        case 4: r = GDK_CLIENT_EVENT;
            break;
        case 5: r = GDK_CONFIGURE;
            break;
        case 6: r = GDK_DELETE;
            break;
        case 7: r = GDK_DESTROY;
            break;
        case 8: r = GDK_DRAG_ENTER;
            break;
        case 9: r = GDK_DRAG_LEAVE;
            break;
        case 10: r = GDK_DRAG_MOTION;
            break;
        case 11: r = GDK_DRAG_STATUS;
            break;
        case 12: r = GDK_DROP_FINISHED;
            break;
        case 13: r = GDK_DROP_START;
            break;
        case 14: r = GDK_ENTER_NOTIFY;
            break;
        case 15: r = GDK_EXPOSE;
            break;
        case 16: r = GDK_FOCUS_CHANGE;
            break;
        case 17: r = GDK_KEY_PRESS;
            break;
        case 18: r = GDK_KEY_RELEASE;
            break;
        case 19: r = GDK_LEAVE_NOTIFY;
            break;
        case 20: r = GDK_MAP;
            break;
        case 21: r = GDK_MOTION_NOTIFY;
            break;
        case 22: r = GDK_NOTHING;
            break;
        case 23: r = GDK_NO_EXPOSE;
            break;
        case 24: r = GDK_PROPERTY_NOTIFY;
            break;
        case 25: r = GDK_PROXIMITY_IN;
            break;
        case 26: r = GDK_PROXIMITY_OUT;
            break;
        case 27: r = GDK_SCROLL;
            break;
        case 28: r = GDK_SELECTION_CLEAR;
            break;
        case 29: r = GDK_SELECTION_NOTIFY;
            break;
        case 30: r = GDK_SELECTION_REQUEST;
            break;
        case 31: r = GDK_SETTING;
            break;
        case 32: r = GDK_UNMAP;
            break;
        case 33: r = GDK_VISIBILITY_NOTIFY;
            break;
        case 34: r = GDK_WINDOW_STATE;
            break;
        default:
            Error ("GdkEventTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_EventTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkEventTypetFromWord(x0));
} END
DEFINE1(Gdk_EventTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkEventTypetToWord((GdkEventType)i));
} END
DEFINE0(Gdk_EventTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_EVENT_TYPE));
} END
word GdkFilterReturntToWord(GdkFilterReturn v) {
    unsigned r = 0;
        if (v  == GDK_FILTER_CONTINUE) {
            r = 0;
        } else 
        if (v  == GDK_FILTER_REMOVE) {
            r = 1;
        } else 
        if (v  == GDK_FILTER_TRANSLATE) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkFilterReturn GdkFilterReturntFromWord(word w) {
    GdkFilterReturn r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_FILTER_CONTINUE;
            break;
        case 1: r = GDK_FILTER_REMOVE;
            break;
        case 2: r = GDK_FILTER_TRANSLATE;
            break;
        default:
            Error ("GdkFilterReturntFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_FilterReturnToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkFilterReturntFromWord(x0));
} END
DEFINE1(Gdk_FilterReturnFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkFilterReturntToWord((GdkFilterReturn)i));
} END
DEFINE0(Gdk_FilterReturnGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_FILTER_RETURN));
} END
word GdkDragProtocoltToWord(GdkDragProtocol v) {
    unsigned r = 0;
        if (v  == GDK_DRAG_PROTO_LOCAL) {
            r = 0;
        } else 
        if (v  == GDK_DRAG_PROTO_MOTIF) {
            r = 1;
        } else 
        if (v  == GDK_DRAG_PROTO_NONE) {
            r = 2;
        } else 
        if (v  == GDK_DRAG_PROTO_OLE2) {
            r = 3;
        } else 
        if (v  == GDK_DRAG_PROTO_ROOTWIN) {
            r = 4;
        } else 
        if (v  == GDK_DRAG_PROTO_WIN32_DROPFILES) {
            r = 5;
        } else 
        if (v  == GDK_DRAG_PROTO_XDND) {
            r = 6;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkDragProtocol GdkDragProtocoltFromWord(word w) {
    GdkDragProtocol r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_DRAG_PROTO_LOCAL;
            break;
        case 1: r = GDK_DRAG_PROTO_MOTIF;
            break;
        case 2: r = GDK_DRAG_PROTO_NONE;
            break;
        case 3: r = GDK_DRAG_PROTO_OLE2;
            break;
        case 4: r = GDK_DRAG_PROTO_ROOTWIN;
            break;
        case 5: r = GDK_DRAG_PROTO_WIN32_DROPFILES;
            break;
        case 6: r = GDK_DRAG_PROTO_XDND;
            break;
        default:
            Error ("GdkDragProtocoltFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_DragProtocolToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkDragProtocoltFromWord(x0));
} END
DEFINE1(Gdk_DragProtocolFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkDragProtocoltToWord((GdkDragProtocol)i));
} END
DEFINE0(Gdk_DragProtocolGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_DRAG_PROTOCOL));
} END
word GdkDragActiontToWord(GdkDragAction v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & GDK_ACTION_ASK) == GDK_ACTION_ASK) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & GDK_ACTION_COPY) == GDK_ACTION_COPY) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & GDK_ACTION_DEFAULT) == GDK_ACTION_DEFAULT) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & GDK_ACTION_LINK) == GDK_ACTION_LINK) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & GDK_ACTION_MOVE) == GDK_ACTION_MOVE) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & GDK_ACTION_PRIVATE) == GDK_ACTION_PRIVATE) {
            w = alice_cons (Store::IntToWord (5), w);
        }
    return w;
}
GdkDragAction GdkDragActiontFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= GDK_ACTION_ASK;
                break;
            case 1: r |= GDK_ACTION_COPY;
                break;
            case 2: r |= GDK_ACTION_DEFAULT;
                break;
            case 3: r |= GDK_ACTION_LINK;
                break;
            case 4: r |= GDK_ACTION_MOVE;
                break;
            case 5: r |= GDK_ACTION_PRIVATE;
                break;
            default:
                Error ("GdkDragActiontFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (GdkDragAction)r;
}
DEFINE1(Gdk_DragActionToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(GdkDragActiontFromWord(x0));
} END
DEFINE1(Gdk_DragActionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkDragActiontToWord((GdkDragAction)i));
} END
DEFINE0(Gdk_DragActionGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_DRAG_ACTION));
} END
word GdkCursorTypetToWord(GdkCursorType v) {
    unsigned r = 0;
        if (v  == GDK_CURSOR_IS_PIXMAP) {
            r = 0;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
GdkCursorType GdkCursorTypetFromWord(word w) {
    GdkCursorType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = GDK_CURSOR_IS_PIXMAP;
            break;
        default:
            Error ("GdkCursorTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Gdk_CursorTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(GdkCursorTypetFromWord(x0));
} END
DEFINE1(Gdk_CursorTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(GdkCursorTypetToWord((GdkCursorType)i));
} END
DEFINE0(Gdk_CursorTypeGetType) {
    RETURN1(Store::IntToWord(GDK_TYPE_CURSOR_TYPE));
} END
GdkRectangle* MK_GdkRectangleNew (
        gint height
        , gint width
        , gint x
        , gint y
        ) {
    GdkRectangle* res_ = new GdkRectangle;
    res_->height = height;
    res_->width = width;
    res_->x = x;
    res_->y = y;
    return res_;
}
DEFINE4(Gdk_Rectanglenew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    GdkRectangle* cres = (GdkRectangle*)MK_GdkRectangleNew(
        (gint)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_RECTANGLE);
    RETURN1(res);
} END
#define DOgetFieldHeight(O) ((O)->height)
#define DOsetFieldHeight(O, V) ((O)->height = (V))
#define DOgetFieldWidth(O) ((O)->width)
#define DOsetFieldWidth(O, V) ((O)->width = (V))
#define DOgetFieldX(O) ((O)->x)
#define DOsetFieldX(O, V) ((O)->x = (V))
#define DOgetFieldY(O) ((O)->y)
#define DOsetFieldY(O, V) ((O)->y = (V))
DEFINE3(Gdk_Rectangleunion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_RECTANGLE);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_RECTANGLE);
    gdk_rectangle_union(
        (GdkRectangle*)a0
        ,(GdkRectangle*)a1
        ,(GdkRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_Rectangleintersect) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_RECTANGLE);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_RECTANGLE);
    gboolean cres = (gboolean)gdk_rectangle_intersect(
        (GdkRectangle*)a0
        ,(GdkRectangle*)a1
        ,(GdkRectangle*)a2
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_RectanglegetFieldY) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    gint cres = (gint)DOgetFieldY(
        (GdkRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_RectanglesetFieldY) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    DECLARE_INT(a1, x1);
    DOsetFieldY(
        (GdkRectangle*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_RectanglegetFieldX) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    gint cres = (gint)DOgetFieldX(
        (GdkRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_RectanglesetFieldX) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    DECLARE_INT(a1, x1);
    DOsetFieldX(
        (GdkRectangle*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_RectanglegetFieldWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    gint cres = (gint)DOgetFieldWidth(
        (GdkRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_RectanglesetFieldWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    DECLARE_INT(a1, x1);
    DOsetFieldWidth(
        (GdkRectangle*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_RectanglegetFieldHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    gint cres = (gint)DOgetFieldHeight(
        (GdkRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_RectanglesetFieldHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_RECTANGLE);
    DECLARE_INT(a1, x1);
    DOsetFieldHeight(
        (GdkRectangle*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldHeight
#undef DOsetFieldHeight
#undef DOgetFieldWidth
#undef DOsetFieldWidth
#undef DOgetFieldX
#undef DOsetFieldX
#undef DOgetFieldY
#undef DOsetFieldY
DEFINE4(Gdk_CursornewFromPixbuf) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXBUF);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    GdkCursor* cres = (GdkCursor*)gdk_cursor_new_from_pixbuf(
        (GdkDisplay*)a0
        ,(GdkPixbuf*)a1
        ,(gint)a2
        ,(gint)a3
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_CURSOR);
    RETURN1(res);
} END
DEFINE6(Gdk_CursornewFromPixmap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXMAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXMAP);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_COLOR);
    DECLARE_OBJECT_OF_TYPE(a3, x3, GDK_TYPE_COLOR);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    GdkCursor* cres = (GdkCursor*)gdk_cursor_new_from_pixmap(
        (GdkPixmap*)a0
        ,(GdkPixmap*)a1
        ,(GdkColor*)a2
        ,(GdkColor*)a3
        ,(gint)a4
        ,(gint)a5
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_CURSOR);
    RETURN1(res);
} END
DEFINE2(Gdk_CursornewForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkCursorType a1 = GdkCursorTypetFromWord(x1);
    GdkCursor* cres = (GdkCursor*)gdk_cursor_new_for_display(
        (GdkDisplay*)a0
        ,(GdkCursorType)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_CURSOR);
    RETURN1(res);
} END
DEFINE1(Gdk_Cursornew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
GdkCursorType a0 = GdkCursorTypetFromWord(x0);
    GdkCursor* cres = (GdkCursor*)gdk_cursor_new(
        (GdkCursorType)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_CURSOR);
    RETURN1(res);
} END
#define DOgetFieldType(O) ((O)->type)
#define DOsetFieldType(O, V) ((O)->type = (V))
DEFINE1(Gdk_CursorgetDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_CURSOR);
    GdkDisplay* cres = (GdkDisplay*)gdk_cursor_get_display(
        (GdkCursor*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_CursorgetFieldType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_CURSOR);
    GdkCursorType cres = (GdkCursorType)DOgetFieldType(
        (GdkCursor*)a0
        );
    word res = GdkCursorTypetToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_CursorsetFieldType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_CURSOR);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkCursorType a1 = GdkCursorTypetFromWord(x1);
    DOsetFieldType(
        (GdkCursor*)a0
        ,(GdkCursorType)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldType
#undef DOsetFieldType
GdkColor* MK_GdkColorNew (
        guint16 blue
        , guint16 green
        , guint16 red
        ) {
    GdkColor* res_ = new GdkColor;
    res_->blue = blue;
    res_->green = green;
    res_->red = red;
    return res_;
}
DEFINE3(Gdk_Colornew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    GdkColor* cres = (GdkColor*)MK_GdkColorNew(
        (guint16)a0
        ,(guint16)a1
        ,(guint16)a2
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_COLOR);
    RETURN1(res);
} END
#define DOgetFieldBlue(O) ((O)->blue)
#define DOsetFieldBlue(O, V) ((O)->blue = (V))
#define DOgetFieldGreen(O) ((O)->green)
#define DOsetFieldGreen(O, V) ((O)->green = (V))
#define DOgetFieldRed(O) ((O)->red)
#define DOsetFieldRed(O, V) ((O)->red = (V))
DEFINE2(Gdk_Colorparse) {
    DECLARE_CSTRING(a0, x0);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gint cres = (gint)gdk_color_parse(
        (const gchar*)a0
        ,(GdkColor*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ColorgetFieldRed) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLOR);
    guint16 cres = (guint16)DOgetFieldRed(
        (GdkColor*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_ColorsetFieldRed) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLOR);
    DECLARE_INT(a1, x1);
    DOsetFieldRed(
        (GdkColor*)a0
        ,(guint16)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_ColorgetFieldGreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLOR);
    guint16 cres = (guint16)DOgetFieldGreen(
        (GdkColor*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_ColorsetFieldGreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLOR);
    DECLARE_INT(a1, x1);
    DOsetFieldGreen(
        (GdkColor*)a0
        ,(guint16)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_ColorgetFieldBlue) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLOR);
    guint16 cres = (guint16)DOgetFieldBlue(
        (GdkColor*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_ColorsetFieldBlue) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLOR);
    DECLARE_INT(a1, x1);
    DOsetFieldBlue(
        (GdkColor*)a0
        ,(guint16)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldBlue
#undef DOsetFieldBlue
#undef DOgetFieldGreen
#undef DOsetFieldGreen
#undef DOgetFieldRed
#undef DOsetFieldRed
DEFINE1(Gdk_Fontload) {
    DECLARE_CSTRING(a0, x0);
    GdkFont* cres = (GdkFont*)gdk_font_load(
        (const gchar*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_FONT);
    RETURN1(res);
} END
#define DOgetFieldAscent(O) ((O)->ascent)
#define DOsetFieldAscent(O, V) ((O)->ascent = (V))
#define DOgetFieldDescent(O) ((O)->descent)
#define DOsetFieldDescent(O, V) ((O)->descent = (V))
#define DOgetFieldType(O) ((O)->type)
#define DOsetFieldType(O, V) ((O)->type = (V))
DEFINE7(Gdk_FontstringExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT_AS(gint, tmp0, x2);
               gint* a2 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x3);
               gint* a3 = (gint*)&tmp1;
    DECLARE_INT_AS(gint, tmp2, x4);
               gint* a4 = (gint*)&tmp2;
    DECLARE_INT_AS(gint, tmp3, x5);
               gint* a5 = (gint*)&tmp3;
    DECLARE_INT_AS(gint, tmp4, x6);
               gint* a6 = (gint*)&tmp4;
    gdk_string_extents(
        (GdkFont*)a0
        ,(const gchar*)a1
        ,(gint*)a2
        ,(gint*)a3
        ,(gint*)a4
        ,(gint*)a5
        ,(gint*)a6
        );
    word r2 = Store::IntToWord(*a2);
    word r3 = Store::IntToWord(*a3);
    word r4 = Store::IntToWord(*a4);
    word r5 = Store::IntToWord(*a5);
    word r6 = Store::IntToWord(*a6);
    RETURN5(r2,r3,r4,r5,r6);
} END
DEFINE8(Gdk_Fontextents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT_AS(gint, tmp0, x3);
               gint* a3 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x4);
               gint* a4 = (gint*)&tmp1;
    DECLARE_INT_AS(gint, tmp2, x5);
               gint* a5 = (gint*)&tmp2;
    DECLARE_INT_AS(gint, tmp3, x6);
               gint* a6 = (gint*)&tmp3;
    DECLARE_INT_AS(gint, tmp4, x7);
               gint* a7 = (gint*)&tmp4;
    gdk_text_extents(
        (GdkFont*)a0
        ,(const gchar*)a1
        ,(gint)a2
        ,(gint*)a3
        ,(gint*)a4
        ,(gint*)a5
        ,(gint*)a6
        ,(gint*)a7
        );
    word r3 = Store::IntToWord(*a3);
    word r4 = Store::IntToWord(*a4);
    word r5 = Store::IntToWord(*a5);
    word r6 = Store::IntToWord(*a6);
    word r7 = Store::IntToWord(*a7);
    RETURN5(r3,r4,r5,r6,r7);
} END
DEFINE2(Gdk_FontcharHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_INT(a1, x1);
    gint cres = (gint)gdk_char_height(
        (GdkFont*)a0
        ,(gchar)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Gdk_Fontheight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    gint cres = (gint)gdk_text_height(
        (GdkFont*)a0
        ,(const gchar*)a1
        ,(gint)a2
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontstringHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    gint cres = (gint)gdk_string_height(
        (GdkFont*)a0
        ,(const gchar*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontcharMeasure) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_INT(a1, x1);
    gint cres = (gint)gdk_char_measure(
        (GdkFont*)a0
        ,(gchar)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Gdk_Fontmeasure) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    gint cres = (gint)gdk_text_measure(
        (GdkFont*)a0
        ,(const gchar*)a1
        ,(gint)a2
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontstringMeasure) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    gint cres = (gint)gdk_string_measure(
        (GdkFont*)a0
        ,(const gchar*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontcharWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_INT(a1, x1);
    gint cres = (gint)gdk_char_width(
        (GdkFont*)a0
        ,(gchar)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Gdk_Fontwidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    gint cres = (gint)gdk_text_width(
        (GdkFont*)a0
        ,(const gchar*)a1
        ,(gint)a2
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontstringWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_CSTRING(a1, x1);
    gint cres = (gint)gdk_string_width(
        (GdkFont*)a0
        ,(const gchar*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_FontfromDescription) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    GdkFont* cres = (GdkFont*)gdk_font_from_description(
        (PangoFontDescription*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_FONT);
    RETURN1(res);
} END
DEFINE2(Gdk_FontfromDescriptionForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    GdkFont* cres = (GdkFont*)gdk_font_from_description_for_display(
        (GdkDisplay*)a0
        ,(PangoFontDescription*)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_FONT);
    RETURN1(res);
} END
DEFINE2(Gdk_FontloadForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_CSTRING(a1, x1);
    GdkFont* cres = (GdkFont*)gdk_font_load_for_display(
        (GdkDisplay*)a0
        ,(const gchar*)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_FONT);
    RETURN1(res);
} END
DEFINE1(Gdk_Fontid) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    gint cres = (gint)gdk_font_id(
        (GdkFont*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_FontgetFieldType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    GdkFontType cres = (GdkFontType)DOgetFieldType(
        (GdkFont*)a0
        );
    word res = GdkFontTypetToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontsetFieldType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkFontType a1 = GdkFontTypetFromWord(x1);
    DOsetFieldType(
        (GdkFont*)a0
        ,(GdkFontType)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_FontgetFieldDescent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    gint cres = (gint)DOgetFieldDescent(
        (GdkFont*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontsetFieldDescent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_INT(a1, x1);
    DOsetFieldDescent(
        (GdkFont*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_FontgetFieldAscent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    gint cres = (gint)DOgetFieldAscent(
        (GdkFont*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_FontsetFieldAscent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_FONT);
    DECLARE_INT(a1, x1);
    DOsetFieldAscent(
        (GdkFont*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldAscent
#undef DOsetFieldAscent
#undef DOgetFieldDescent
#undef DOsetFieldDescent
#undef DOgetFieldType
#undef DOsetFieldType
DEFINE1(Gdk_Eventnew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
GdkEventType a0 = GdkEventTypetFromWord(x0);
    GdkEvent* cres = (GdkEvent*)gdk_event_new(
        (GdkEventType)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE1(Gdk_EventgetScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    GdkScreen* cres = (GdkScreen*)gdk_event_get_screen(
        (GdkEvent*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_EventsetScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_SCREEN);
    gdk_event_set_screen(
        (GdkEvent*)a0
        ,(GdkScreen*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_EventgetAxis) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkAxisUse a1 = GdkAxisUsetFromWord(x1);
    DECLARE_DOUBLE_AS(gdouble, tmp0, x2);
               gdouble* a2 = (gdouble*)&tmp0;
    gboolean cres = (gboolean)gdk_event_get_axis(
        (GdkEvent*)a0
        ,(GdkAxisUse)a1
        ,(gdouble*)a2
        );
    word res = BOOL_TO_WORD(cres);
    word r2 = Real::New(*a2)->ToWord ();
    RETURN2(res,r2);
} END
DEFINE3(Gdk_EventgetRootCoords) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    DECLARE_DOUBLE_AS(gdouble, tmp0, x1);
               gdouble* a1 = (gdouble*)&tmp0;
    DECLARE_DOUBLE_AS(gdouble, tmp1, x2);
               gdouble* a2 = (gdouble*)&tmp1;
    gboolean cres = (gboolean)gdk_event_get_root_coords(
        (GdkEvent*)a0
        ,(gdouble*)a1
        ,(gdouble*)a2
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = Real::New(*a1)->ToWord ();
    word r2 = Real::New(*a2)->ToWord ();
    RETURN3(res,r1,r2);
} END
DEFINE3(Gdk_EventgetCoords) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    DECLARE_DOUBLE_AS(gdouble, tmp0, x1);
               gdouble* a1 = (gdouble*)&tmp0;
    DECLARE_DOUBLE_AS(gdouble, tmp1, x2);
               gdouble* a2 = (gdouble*)&tmp1;
    gboolean cres = (gboolean)gdk_event_get_coords(
        (GdkEvent*)a0
        ,(gdouble*)a1
        ,(gdouble*)a2
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = Real::New(*a1)->ToWord ();
    word r2 = Real::New(*a2)->ToWord ();
    RETURN3(res,r1,r2);
} END
DEFINE2(Gdk_EventgetState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkModifierType tmp2 = GdkModifierTypetFromWord(x1);GdkModifierType *a1 = &tmp2;
    gboolean cres = (gboolean)gdk_event_get_state(
        (GdkEvent*)a0
        ,(GdkModifierType*)a1
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = GdkModifierTypetToWord(*a1);
    RETURN2(res,r1);
} END
DEFINE1(Gdk_EventgetTime) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    guint32 cres = (guint32)gdk_event_get_time(
        (GdkEvent*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_Eventfree) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    gdk_event_free(
        (GdkEvent*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Eventcopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    GdkEvent* cres = (GdkEvent*)gdk_event_copy(
        (GdkEvent*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE1(Gdk_Eventput) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_EVENT);
    gdk_event_put(
        (GdkEvent*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_EventgetGraphicsExpose) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkEvent* cres = (GdkEvent*)gdk_event_get_graphics_expose(
        (GdkWindow*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE0(Gdk_Eventpeek) {
    GdkEvent* cres = (GdkEvent*)gdk_event_peek(
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE0(Gdk_Eventget) {
    GdkEvent* cres = (GdkEvent*)gdk_event_get(
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE0(Gdk_EventgetType) {
    GType cres = (GType)gdk_event_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufFormatisWritable) {
    DECLARE_OBJECT(a0, x0);
    gboolean cres = (gboolean)gdk_pixbuf_format_is_writable(
        (GdkPixbufFormat*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufFormatgetExtensions) {
    DECLARE_OBJECT(a0, x0);
    gchar** cres = (gchar**)gdk_pixbuf_format_get_extensions(
        (GdkPixbufFormat*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufFormatgetMimeTypes) {
    DECLARE_OBJECT(a0, x0);
    gchar** cres = (gchar**)gdk_pixbuf_format_get_mime_types(
        (GdkPixbufFormat*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufFormatgetDescription) {
    DECLARE_OBJECT(a0, x0);
    gchar* cres = (gchar*)gdk_pixbuf_format_get_description(
        (GdkPixbufFormat*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufFormatgetName) {
    DECLARE_OBJECT(a0, x0);
    gchar* cres = (gchar*)gdk_pixbuf_format_get_name(
        (GdkPixbufFormat*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE4(Gdk_BitmapcreateFromData) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    GdkBitmap* cres = (GdkBitmap*)gdk_bitmap_create_from_data(
        (GdkDrawable*)a0
        ,(const gchar*)a1
        ,(gint)a2
        ,(gint)a3
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualgetBestWithBoth) {
    DECLARE_INT(a0, x0);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkVisualType a1 = GdkVisualTypetFromWord(x1);
    GdkVisual* cres = (GdkVisual*)gdk_visual_get_best_with_both(
        (gint)a0
        ,(GdkVisualType)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
#define DOgetFieldBitsPerRgb(O) ((O)->bits_per_rgb)
#define DOsetFieldBitsPerRgb(O, V) ((O)->bits_per_rgb = (V))
#define DOgetFieldBlueMask(O) ((O)->blue_mask)
#define DOsetFieldBlueMask(O, V) ((O)->blue_mask = (V))
#define DOgetFieldBluePrec(O) ((O)->blue_prec)
#define DOsetFieldBluePrec(O, V) ((O)->blue_prec = (V))
#define DOgetFieldBlueShift(O) ((O)->blue_shift)
#define DOsetFieldBlueShift(O, V) ((O)->blue_shift = (V))
#define DOgetFieldByteOrder(O) ((O)->byte_order)
#define DOsetFieldByteOrder(O, V) ((O)->byte_order = (V))
#define DOgetFieldColormapSize(O) ((O)->colormap_size)
#define DOsetFieldColormapSize(O, V) ((O)->colormap_size = (V))
#define DOgetFieldDepth(O) ((O)->depth)
#define DOsetFieldDepth(O, V) ((O)->depth = (V))
#define DOgetFieldGreenMask(O) ((O)->green_mask)
#define DOsetFieldGreenMask(O, V) ((O)->green_mask = (V))
#define DOgetFieldGreenPrec(O) ((O)->green_prec)
#define DOsetFieldGreenPrec(O, V) ((O)->green_prec = (V))
#define DOgetFieldGreenShift(O) ((O)->green_shift)
#define DOsetFieldGreenShift(O, V) ((O)->green_shift = (V))
#define DOgetFieldRedMask(O) ((O)->red_mask)
#define DOsetFieldRedMask(O, V) ((O)->red_mask = (V))
#define DOgetFieldRedPrec(O) ((O)->red_prec)
#define DOsetFieldRedPrec(O, V) ((O)->red_prec = (V))
#define DOgetFieldRedShift(O) ((O)->red_shift)
#define DOsetFieldRedShift(O, V) ((O)->red_shift = (V))
#define DOgetFieldType(O) ((O)->type)
#define DOsetFieldType(O, V) ((O)->type = (V))
DEFINE1(Gdk_VisualgetScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    GdkScreen* cres = (GdkScreen*)gdk_visual_get_screen(
        (GdkVisual*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_VisualgetBestWithType) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
GdkVisualType a0 = GdkVisualTypetFromWord(x0);
    GdkVisual* cres = (GdkVisual*)gdk_visual_get_best_with_type(
        (GdkVisualType)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_VisualgetBestWithDepth) {
    DECLARE_INT(a0, x0);
    GdkVisual* cres = (GdkVisual*)gdk_visual_get_best_with_depth(
        (gint)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_VisualgetBest) {
    GdkVisual* cres = (GdkVisual*)gdk_visual_get_best(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_VisualgetSystem) {
    GdkVisual* cres = (GdkVisual*)gdk_visual_get_system(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_VisualgetBestType) {
    GdkVisualType cres = (GdkVisualType)gdk_visual_get_best_type(
        );
    word res = GdkVisualTypetToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_VisualgetBestDepth) {
    gint cres = (gint)gdk_visual_get_best_depth(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_VisualgetFieldType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    GdkVisualType cres = (GdkVisualType)DOgetFieldType(
        (GdkVisual*)a0
        );
    word res = GdkVisualTypetToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkVisualType a1 = GdkVisualTypetFromWord(x1);
    DOsetFieldType(
        (GdkVisual*)a0
        ,(GdkVisualType)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldRedShift) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldRedShift(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldRedShift) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldRedShift(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldRedPrec) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldRedPrec(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldRedPrec) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldRedPrec(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldRedMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    guint32 cres = (guint32)DOgetFieldRedMask(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldRedMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldRedMask(
        (GdkVisual*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldGreenShift) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldGreenShift(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldGreenShift) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldGreenShift(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldGreenPrec) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldGreenPrec(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldGreenPrec) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldGreenPrec(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldGreenMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    guint32 cres = (guint32)DOgetFieldGreenMask(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldGreenMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldGreenMask(
        (GdkVisual*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldDepth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldDepth(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldDepth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldDepth(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldColormapSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldColormapSize(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldColormapSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldColormapSize(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldByteOrder) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    GdkByteOrder cres = (GdkByteOrder)DOgetFieldByteOrder(
        (GdkVisual*)a0
        );
    word res = GdkByteOrdertToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldByteOrder) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkByteOrder a1 = GdkByteOrdertFromWord(x1);
    DOsetFieldByteOrder(
        (GdkVisual*)a0
        ,(GdkByteOrder)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldBlueShift) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldBlueShift(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldBlueShift) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldBlueShift(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldBluePrec) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldBluePrec(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldBluePrec) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldBluePrec(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldBlueMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    guint32 cres = (guint32)DOgetFieldBlueMask(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldBlueMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldBlueMask(
        (GdkVisual*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_VisualgetFieldBitsPerRgb) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    gint cres = (gint)DOgetFieldBitsPerRgb(
        (GdkVisual*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_VisualsetFieldBitsPerRgb) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_INT(a1, x1);
    DOsetFieldBitsPerRgb(
        (GdkVisual*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldBitsPerRgb
#undef DOsetFieldBitsPerRgb
#undef DOgetFieldBlueMask
#undef DOsetFieldBlueMask
#undef DOgetFieldBluePrec
#undef DOsetFieldBluePrec
#undef DOgetFieldBlueShift
#undef DOsetFieldBlueShift
#undef DOgetFieldByteOrder
#undef DOsetFieldByteOrder
#undef DOgetFieldColormapSize
#undef DOsetFieldColormapSize
#undef DOgetFieldDepth
#undef DOsetFieldDepth
#undef DOgetFieldGreenMask
#undef DOsetFieldGreenMask
#undef DOgetFieldGreenPrec
#undef DOsetFieldGreenPrec
#undef DOgetFieldGreenShift
#undef DOsetFieldGreenShift
#undef DOgetFieldRedMask
#undef DOsetFieldRedMask
#undef DOgetFieldRedPrec
#undef DOsetFieldRedPrec
#undef DOgetFieldRedShift
#undef DOsetFieldRedShift
#undef DOgetFieldType
#undef DOsetFieldType
DEFINE1(Gdk_ScreenalternativeDialogButtonOrder) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gboolean cres = (gboolean)gtk_alternative_dialog_button_order(
        (GdkScreen*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_ScreengetSetting) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    DECLARE_CSTRING(a1, x1);
    GValue* a2 = new GValue; memset(a2, 0, sizeof(GValue));
    gboolean cres = (gboolean)gdk_screen_get_setting(
        (GdkScreen*)a0
        ,(const gchar*)a1
        ,(GValue*)a2
        );
    word res = BOOL_TO_WORD(cres);
    word r2 = OBJECT_TO_WORD (a2, TYPE_BOXED | FLAG_OWN, G_TYPE_VALUE);
    RETURN2(res,r2);
} END
DEFINE0(Gdk_ScreengetDefault) {
    GdkScreen* cres = (GdkScreen*)gdk_screen_get_default(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_ScreenbroadcastClientMessage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_EVENT);
    gdk_screen_broadcast_client_message(
        (GdkScreen*)a0
        ,(GdkEvent*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_ScreengetMonitorAtWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    gint cres = (gint)gdk_screen_get_monitor_at_window(
        (GdkScreen*)a0
        ,(GdkWindow*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Gdk_ScreengetMonitorAtPoint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gint cres = (gint)gdk_screen_get_monitor_at_point(
        (GdkScreen*)a0
        ,(gint)a1
        ,(gint)a2
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Gdk_ScreengetMonitorGeometry) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    DECLARE_INT(a1, x1);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_RECTANGLE);
    gdk_screen_get_monitor_geometry(
        (GdkScreen*)a0
        ,(gint)a1
        ,(GdkRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_ScreengetNMonitors) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gint cres = (gint)gdk_screen_get_n_monitors(
        (GdkScreen*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreenmakeDisplayName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gchar* cres = (gchar*)gdk_screen_make_display_name(
        (GdkScreen*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetToplevelWindows) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GList* cres = (GList*)gdk_screen_get_toplevel_windows(
        (GdkScreen*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreenlistVisuals) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GList* cres = (GList*)gdk_screen_list_visuals(
        (GdkScreen*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetHeightMm) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gint cres = (gint)gdk_screen_get_height_mm(
        (GdkScreen*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetWidthMm) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gint cres = (gint)gdk_screen_get_width_mm(
        (GdkScreen*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gint cres = (gint)gdk_screen_get_height(
        (GdkScreen*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gint cres = (gint)gdk_screen_get_width(
        (GdkScreen*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetNumber) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    gint cres = (gint)gdk_screen_get_number(
        (GdkScreen*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkDisplay* cres = (GdkDisplay*)gdk_screen_get_display(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetRootWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkWindow* cres = (GdkWindow*)gdk_screen_get_root_window(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetRgbVisual) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkVisual* cres = (GdkVisual*)gdk_screen_get_rgb_visual(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetRgbColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkColormap* cres = (GdkColormap*)gdk_screen_get_rgb_colormap(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetSystemVisual) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkVisual* cres = (GdkVisual*)gdk_screen_get_system_visual(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ScreengetSystemColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkColormap* cres = (GdkColormap*)gdk_screen_get_system_colormap(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_ScreensetDefaultColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    gdk_screen_set_default_colormap(
        (GdkScreen*)a0
        ,(GdkColormap*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_ScreengetDefaultColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_SCREEN);
    GdkColormap* cres = (GdkColormap*)gdk_screen_get_default_colormap(
        (GdkScreen*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_ScreengetType) {
    GType cres = (GType)gdk_screen_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_ScreenheightMm) {
    gint cres = (gint)gdk_screen_height_mm(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_ScreenwidthMm) {
    gint cres = (gint)gdk_screen_width_mm(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_Screenheight) {
    gint cres = (gint)gdk_screen_height(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_Screenwidth) {
    gint cres = (gint)gdk_screen_width(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufLoadernewWithType) {
    DECLARE_CSTRING(a0, x0);
    GError *tmp0 = 0; GError **a1 = &tmp0;
    GdkPixbufLoader* cres = (GdkPixbufLoader*)gdk_pixbuf_loader_new_with_type(
        (const char*)a0
        ,a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    if ((*a1) != NULL) {char message[strlen((*a1)->message)];g_error_free(*a1);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufLoadergetFormat) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_LOADER);
    GdkPixbufFormat* cres = (GdkPixbufFormat*)gdk_pixbuf_loader_get_format(
        (GdkPixbufLoader*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE3(Gdk_PixbufLoadersetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_LOADER);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_pixbuf_loader_set_size(
        (GdkPixbufLoader*)a0
        ,(int)a1
        ,(int)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_PixbufLoaderclose) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_LOADER);
    GError *tmp0 = 0; GError **a1 = &tmp0;
    gboolean cres = (gboolean)gdk_pixbuf_loader_close(
        (GdkPixbufLoader*)a0
        ,a1
        );
    word res = BOOL_TO_WORD(cres);
    if ((*a1) != NULL) {char message[strlen((*a1)->message)];g_error_free(*a1);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufLoadergetAnimation) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_LOADER);
    GdkPixbufAnimation* cres = (GdkPixbufAnimation*)gdk_pixbuf_loader_get_animation(
        (GdkPixbufLoader*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufLoadergetPixbuf) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_LOADER);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_loader_get_pixbuf(
        (GdkPixbufLoader*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_PixbufLoaderwrite) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_LOADER);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    GError *tmp0 = 0; GError **a3 = &tmp0;
    gboolean cres = (gboolean)gdk_pixbuf_loader_write(
        (GdkPixbufLoader*)a0
        ,(const guchar*)a1
        ,(gsize)a2
        ,a3
        );
    word res = BOOL_TO_WORD(cres);
    if ((*a3) != NULL) {char message[strlen((*a3)->message)];g_error_free(*a3);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufLoadernewWithMimeType) {
    DECLARE_CSTRING(a0, x0);
    GError *tmp0 = 0; GError **a1 = &tmp0;
    GdkPixbufLoader* cres = (GdkPixbufLoader*)gdk_pixbuf_loader_new_with_mime_type(
        (const char*)a0
        ,a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    if ((*a1) != NULL) {char message[strlen((*a1)->message)];g_error_free(*a1);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE0(Gdk_PixbufLoadernew) {
    GdkPixbufLoader* cres = (GdkPixbufLoader*)gdk_pixbuf_loader_new(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_PixbufLoadergetType) {
    GType cres = (GType)gdk_pixbuf_loader_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_PixbufAnimationIteradvance) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION_ITER);
    DECLARE_OBJECT(a1, x1);
    gboolean cres = (gboolean)gdk_pixbuf_animation_iter_advance(
        (GdkPixbufAnimationIter*)a0
        ,(const GTimeVal*)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationIteronCurrentlyLoadingFrame) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION_ITER);
    gboolean cres = (gboolean)gdk_pixbuf_animation_iter_on_currently_loading_frame(
        (GdkPixbufAnimationIter*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationItergetPixbuf) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION_ITER);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_animation_iter_get_pixbuf(
        (GdkPixbufAnimationIter*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationItergetDelayTime) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION_ITER);
    int cres = (int)gdk_pixbuf_animation_iter_get_delay_time(
        (GdkPixbufAnimationIter*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_PixbufAnimationItergetType) {
    GType cres = (GType)gdk_pixbuf_animation_iter_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationnewFromFile) {
    DECLARE_CSTRING(a0, x0);
    GError *tmp0 = 0; GError **a1 = &tmp0;
    GdkPixbufAnimation* cres = (GdkPixbufAnimation*)gdk_pixbuf_animation_new_from_file(
        (const char*)a0
        ,a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    if ((*a1) != NULL) {char message[strlen((*a1)->message)];g_error_free(*a1);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE2(Gdk_PixbufAnimationgetIter) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION);
    DECLARE_OBJECT(a1, x1);
    GdkPixbufAnimationIter* cres = (GdkPixbufAnimationIter*)gdk_pixbuf_animation_get_iter(
        (GdkPixbufAnimation*)a0
        ,(const GTimeVal*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationgetStaticImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_animation_get_static_image(
        (GdkPixbufAnimation*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationisStaticImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION);
    gboolean cres = (gboolean)gdk_pixbuf_animation_is_static_image(
        (GdkPixbufAnimation*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationgetHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION);
    int cres = (int)gdk_pixbuf_animation_get_height(
        (GdkPixbufAnimation*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufAnimationgetWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF_ANIMATION);
    int cres = (int)gdk_pixbuf_animation_get_width(
        (GdkPixbufAnimation*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_PixbufAnimationgetType) {
    GType cres = (GType)gdk_pixbuf_animation_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE5(Gdk_Pixbufnew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
GdkColorspace a0 = GdkColorspacetFromWord(x0);
    DECLARE_BOOL(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new(
        (GdkColorspace)a0
        ,(gboolean)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_PixbufgetFileInfo) {
    DECLARE_CSTRING(a0, x0);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    GdkPixbufFormat* cres = (GdkPixbufFormat*)gdk_pixbuf_get_file_info(
        (const gchar*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN3(res,r1,r2);
} END
DEFINE0(Gdk_PixbufgetFormats) {
    GSList* cres = (GSList*)gdk_pixbuf_get_formats(
        );
    word res = GSLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_PixbufgetOption) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_CSTRING(a1, x1);
    const char* cres = (const char*)gdk_pixbuf_get_option(
        (GdkPixbuf*)a0
        ,(const char*)a1
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE8(Gdk_PixbufcompositeColorSimple) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    if (Store::WordToInt(x3) == INVALID_INT) {REQUEST(x3);}
GdkInterpType a3 = GdkInterpTypetFromWord(x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_composite_color_simple(
        (GdkPixbuf*)a0
        ,(int)a1
        ,(int)a2
        ,(GdkInterpType)a3
        ,(int)a4
        ,(int)a5
        ,(guint32)a6
        ,(guint32)a7
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE4(Gdk_PixbufscaleSimple) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    if (Store::WordToInt(x3) == INVALID_INT) {REQUEST(x3);}
GdkInterpType a3 = GdkInterpTypetFromWord(x3);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_scale_simple(
        (GdkPixbuf*)a0
        ,(int)a1
        ,(int)a2
        ,(GdkInterpType)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE17(Gdk_PixbufcompositeColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXBUF);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_CDOUBLE(a6, x6);
    DECLARE_CDOUBLE(a7, x7);
    DECLARE_CDOUBLE(a8, x8);
    DECLARE_CDOUBLE(a9, x9);
    if (Store::WordToInt(x10) == INVALID_INT) {REQUEST(x10);}
GdkInterpType a10 = GdkInterpTypetFromWord(x10);
    DECLARE_INT(a11, x11);
    DECLARE_INT(a12, x12);
    DECLARE_INT(a13, x13);
    DECLARE_INT(a14, x14);
    DECLARE_INT(a15, x15);
    DECLARE_INT(a16, x16);
    gdk_pixbuf_composite_color(
        (GdkPixbuf*)a0
        ,(GdkPixbuf*)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(double)a6
        ,(double)a7
        ,(double)a8
        ,(double)a9
        ,(GdkInterpType)a10
        ,(int)a11
        ,(int)a12
        ,(int)a13
        ,(int)a14
        ,(guint32)a15
        ,(guint32)a16
        );
    RETURN_UNIT;
} END
DEFINE12(Gdk_Pixbufcomposite) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXBUF);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_CDOUBLE(a6, x6);
    DECLARE_CDOUBLE(a7, x7);
    DECLARE_CDOUBLE(a8, x8);
    DECLARE_CDOUBLE(a9, x9);
    if (Store::WordToInt(x10) == INVALID_INT) {REQUEST(x10);}
GdkInterpType a10 = GdkInterpTypetFromWord(x10);
    DECLARE_INT(a11, x11);
    gdk_pixbuf_composite(
        (GdkPixbuf*)a0
        ,(GdkPixbuf*)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(double)a6
        ,(double)a7
        ,(double)a8
        ,(double)a9
        ,(GdkInterpType)a10
        ,(int)a11
        );
    RETURN_UNIT;
} END
DEFINE11(Gdk_Pixbufscale) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXBUF);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_CDOUBLE(a6, x6);
    DECLARE_CDOUBLE(a7, x7);
    DECLARE_CDOUBLE(a8, x8);
    DECLARE_CDOUBLE(a9, x9);
    if (Store::WordToInt(x10) == INVALID_INT) {REQUEST(x10);}
GdkInterpType a10 = GdkInterpTypetFromWord(x10);
    gdk_pixbuf_scale(
        (GdkPixbuf*)a0
        ,(GdkPixbuf*)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(double)a6
        ,(double)a7
        ,(double)a8
        ,(double)a9
        ,(GdkInterpType)a10
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_PixbufsaturateAndPixelate) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXBUF);
    DECLARE_CFLOAT(a2, x2);
    DECLARE_BOOL(a3, x3);
    gdk_pixbuf_saturate_and_pixelate(
        (GdkPixbuf*)a0
        ,(GdkPixbuf*)a1
        ,(gfloat)a2
        ,(gboolean)a3
        );
    RETURN_UNIT;
} END
DEFINE8(Gdk_PixbufcopyArea) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_OBJECT_OF_TYPE(a5, x5, GDK_TYPE_PIXBUF);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    gdk_pixbuf_copy_area(
        (GdkPixbuf*)a0
        ,(int)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        ,(GdkPixbuf*)a5
        ,(int)a6
        ,(int)a7
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_PixbufaddAlpha) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_BOOL(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_add_alpha(
        (GdkPixbuf*)a0
        ,(gboolean)a1
        ,(guchar)a2
        ,(guchar)a3
        ,(guchar)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE5(Gdk_Pixbufsavev) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_CSTRING(a1, x1);
    DECLARE_CSTRING(a2, x2);
    DECLARE_ZERO_TERMINATED_ARRAY(a3, x3, char*, DECLARE_CSTRING(elem_c, elem_alice));
    DECLARE_ZERO_TERMINATED_ARRAY(a4, x4, char*, DECLARE_CSTRING(elem_c, elem_alice));
    GError *tmp0 = 0; GError **a5 = &tmp0;
    gboolean cres = (gboolean)gdk_pixbuf_savev(
        (GdkPixbuf*)a0
        ,(const char*)a1
        ,(const char*)a2
        ,(char**)a3
        ,(char**)a4
        ,a5
        );
    word res = BOOL_TO_WORD(cres);
    if ((*a5) != NULL) {char message[strlen((*a5)->message)];g_error_free(*a5);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE3(Gdk_Pixbufsave) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_CSTRING(a1, x1);
    DECLARE_CSTRING(a2, x2);
    GError *tmp0 = 0; GError **a3 = &tmp0;
    gboolean cres = (gboolean)gdk_pixbuf_save(
        (GdkPixbuf*)a0
        ,(const char*)a1
        ,(const char*)a2
        ,a3
        , NULL
        );
    word res = BOOL_TO_WORD(cres);
    if ((*a3) != NULL) {char message[strlen((*a3)->message)];g_error_free(*a3);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE2(Gdk_Pixbuffill) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_INT(a1, x1);
    gdk_pixbuf_fill(
        (GdkPixbuf*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_Pixbufsubpixbuf) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new_subpixbuf(
        (GdkPixbuf*)a0
        ,(int)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_PixbufnewFromInline) {
    DECLARE_INT(a0, x0);
    DECLARE_CSTRING(a1, x1);
    DECLARE_BOOL(a2, x2);
    GError *tmp0 = 0; GError **a3 = &tmp0;
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new_from_inline(
        (gint)a0
        ,(const guchar*)a1
        ,(gboolean)a2
        ,a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    if ((*a3) != NULL) {char message[strlen((*a3)->message)];g_error_free(*a3);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufnewFromXpmData) {
    DECLARE_ZERO_TERMINATED_ARRAY(a0, x0, char*, DECLARE_CSTRING(elem_c, elem_alice));
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new_from_xpm_data(
        (const char**)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE9(Gdk_PixbufnewFromData) {
    DECLARE_CSTRING(a0, x0);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkColorspace a1 = GdkColorspacetFromWord(x1);
    DECLARE_BOOL(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_OBJECT (a7, x7);
    DECLARE_OBJECT(a8, x8);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new_from_data(
        (const guchar*)a0
        ,(GdkColorspace)a1
        ,(gboolean)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(int)a6
        ,(GdkPixbufDestroyNotify)a7
        ,(gpointer)a8
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_PixbufnewFromFileAtSize) {
    DECLARE_CSTRING(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    GError *tmp0 = 0; GError **a3 = &tmp0;
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new_from_file_at_size(
        (const char*)a0
        ,(int)a1
        ,(int)a2
        ,a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    if ((*a3) != NULL) {char message[strlen((*a3)->message)];g_error_free(*a3);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufnewFromFile) {
    DECLARE_CSTRING(a0, x0);
    GError *tmp0 = 0; GError **a1 = &tmp0;
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_new_from_file(
        (const char*)a0
        ,a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    if ((*a1) != NULL) {char message[strlen((*a1)->message)];g_error_free(*a1);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE1(Gdk_Pixbufcopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_copy(
        (GdkPixbuf*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetRowstride) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    int cres = (int)gdk_pixbuf_get_rowstride(
        (GdkPixbuf*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetHeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    int cres = (int)gdk_pixbuf_get_height(
        (GdkPixbuf*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    int cres = (int)gdk_pixbuf_get_width(
        (GdkPixbuf*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetPixels) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    guchar* cres = (guchar*)gdk_pixbuf_get_pixels(
        (GdkPixbuf*)a0
        );
    word res = String::New (cres != 0 ? ((const char*)cres) : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetBitsPerSample) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    int cres = (int)gdk_pixbuf_get_bits_per_sample(
        (GdkPixbuf*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetHasAlpha) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    gboolean cres = (gboolean)gdk_pixbuf_get_has_alpha(
        (GdkPixbuf*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetNChannels) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    int cres = (int)gdk_pixbuf_get_n_channels(
        (GdkPixbuf*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_PixbufgetColorspace) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    GdkColorspace cres = (GdkColorspace)gdk_pixbuf_get_colorspace(
        (GdkPixbuf*)a0
        );
    word res = GdkColorspacetToWord(cres);
    RETURN1(res);
} END
DEFINE9(Gdk_PixbufgetFromImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_IMAGE);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_COLORMAP);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_get_from_image(
        (GdkPixbuf*)a0
        ,(GdkImage*)a1
        ,(GdkColormap*)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(int)a6
        ,(int)a7
        ,(int)a8
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE9(Gdk_PixbufgetFromDrawable) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_COLORMAP);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    GdkPixbuf* cres = (GdkPixbuf*)gdk_pixbuf_get_from_drawable(
        (GdkPixbuf*)a0
        ,(GdkDrawable*)a1
        ,(GdkColormap*)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(int)a6
        ,(int)a7
        ,(int)a8
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_PixbufrenderPixmapAndMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    GdkPixmap* tmp0 = 0; GdkPixmap** a1 = &tmp0;
    GdkBitmap* tmp1 = 0; GdkBitmap** a2 = &tmp1;
    DECLARE_INT(a3, x1);
    gdk_pixbuf_render_pixmap_and_mask(
        (GdkPixbuf*)a0
        ,(GdkPixmap**)a1
        ,(GdkBitmap**)a2
        ,(int)a3
        );
    word r1 = OBJECT_TO_WORD(*a1,TYPE_G_OBJECT);
    word r2 = OBJECT_TO_WORD(*a2, TYPE_BOXED);
    RETURN2(r1,r2);
} END
DEFINE13(Gdk_PixbufrenderToDrawableAlpha) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_DRAWABLE);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    if (Store::WordToInt(x8) == INVALID_INT) {REQUEST(x8);}
GdkPixbufAlphaMode a8 = GdkPixbufAlphaModetFromWord(x8);
    DECLARE_INT(a9, x9);
    if (Store::WordToInt(x10) == INVALID_INT) {REQUEST(x10);}
GdkRgbDither a10 = GdkRgbDithertFromWord(x10);
    DECLARE_INT(a11, x11);
    DECLARE_INT(a12, x12);
    gdk_pixbuf_render_to_drawable_alpha(
        (GdkPixbuf*)a0
        ,(GdkDrawable*)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(int)a6
        ,(int)a7
        ,(GdkPixbufAlphaMode)a8
        ,(int)a9
        ,(GdkRgbDither)a10
        ,(gint)a11
        ,(gint)a12
        );
    RETURN_UNIT;
} END
DEFINE12(Gdk_PixbufrenderToDrawable) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_PIXBUF);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_GC);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    if (Store::WordToInt(x9) == INVALID_INT) {REQUEST(x9);}
GdkRgbDither a9 = GdkRgbDithertFromWord(x9);
    DECLARE_INT(a10, x10);
    DECLARE_INT(a11, x11);
    gdk_pixbuf_render_to_drawable(
        (GdkPixbuf*)a0
        ,(GdkDrawable*)a1
        ,(GdkGC*)a2
        ,(int)a3
        ,(int)a4
        ,(int)a5
        ,(int)a6
        ,(int)a7
        ,(int)a8
        ,(GdkRgbDither)a9
        ,(gint)a10
        ,(gint)a11
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_KeymapgetDirection) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_KEYMAP);
    PangoDirection cres = (PangoDirection)gdk_keymap_get_direction(
        (GdkKeymap*)a0
        );
    word res = PangoDirectiontToWord(cres);
    RETURN1(res);
} END
DEFINE8(Gdk_KeymaptranslateKeyboardState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_KEYMAP);
    DECLARE_INT(a1, x1);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x2, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x2);}
});
GdkModifierType a2 = GdkModifierTypetFromWord(x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT_AS(guint, tmp2, x4);
               int* a4 = (int*)&tmp2;
    DECLARE_INT_AS(gint, tmp3, x5);
               gint* a5 = (gint*)&tmp3;
    DECLARE_INT_AS(gint, tmp4, x6);
               gint* a6 = (gint*)&tmp4;
    DECLARE_LIST_ELEMS(tmp5, tmp6, x7, 
{ if (Store::WordToInt(tmp5->Sel(0)) == INVALID_INT)
{REQUEST(x7);}
});
GdkModifierType tmp7 = GdkModifierTypetFromWord(x7);GdkModifierType *a7 = &tmp7;
    gboolean cres = (gboolean)gdk_keymap_translate_keyboard_state(
        (GdkKeymap*)a0
        ,(guint)a1
        ,(GdkModifierType)a2
        ,(gint)a3
        ,(guint*)a4
        ,(gint*)a5
        ,(gint*)a6
        ,(GdkModifierType*)a7
        );
    word res = BOOL_TO_WORD(cres);
    word r4 = Store::IntToWord(*a4);
    word r5 = Store::IntToWord(*a5);
    word r6 = Store::IntToWord(*a6);
    word r7 = GdkModifierTypetToWord(*a7);
    RETURN5(res,r4,r5,r6,r7);
} END
DEFINE1(Gdk_KeymapgetForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    GdkKeymap* cres = (GdkKeymap*)gdk_keymap_get_for_display(
        (GdkDisplay*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_KeymapgetDefault) {
    GdkKeymap* cres = (GdkKeymap*)gdk_keymap_get_default(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_KeymapgetType) {
    GType cres = (GType)gdk_keymap_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE4(Gdk_Imagenew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
GdkImageType a0 = GdkImageTypetFromWord(x0);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_VISUAL);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    GdkImage* cres = (GdkImage*)gdk_image_new(
        (GdkImageType)a0
        ,(GdkVisual*)a1
        ,(gint)a2
        ,(gint)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ImagegetColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_IMAGE);
    GdkColormap* cres = (GdkColormap*)gdk_image_get_colormap(
        (GdkImage*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_ImagesetColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_IMAGE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    gdk_image_set_colormap(
        (GdkImage*)a0
        ,(GdkColormap*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_ImagegetPixel) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_IMAGE);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    guint32 cres = (guint32)gdk_image_get_pixel(
        (GdkImage*)a0
        ,(gint)a1
        ,(gint)a2
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE4(Gdk_ImageputPixel) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_IMAGE);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gdk_image_put_pixel(
        (GdkImage*)a0
        ,(gint)a1
        ,(gint)a2
        ,(guint32)a3
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_ImagegetType) {
    GType cres = (GType)gdk_image_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_GCnew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkGC* cres = (GdkGC*)gdk_gc_new(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_GCsetRgbBgColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gdk_gc_set_rgb_bg_color(
        (GdkGC*)a0
        ,(GdkColor*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetRgbFgColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gdk_gc_set_rgb_fg_color(
        (GdkGC*)a0
        ,(GdkColor*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_GCgetColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    GdkColormap* cres = (GdkColormap*)gdk_gc_get_colormap(
        (GdkGC*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_GCsetColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    gdk_gc_set_colormap(
        (GdkGC*)a0
        ,(GdkColormap*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCcopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    gdk_gc_copy(
        (GdkGC*)a0
        ,(GdkGC*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_GCoffset) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_gc_offset(
        (GdkGC*)a0
        ,(gint)a1
        ,(gint)a2
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_GCsetLineAttributes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_INT(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
GdkLineStyle a2 = GdkLineStyletFromWord(x2);
    if (Store::WordToInt(x3) == INVALID_INT) {REQUEST(x3);}
GdkCapStyle a3 = GdkCapStyletFromWord(x3);
    if (Store::WordToInt(x4) == INVALID_INT) {REQUEST(x4);}
GdkJoinStyle a4 = GdkJoinStyletFromWord(x4);
    gdk_gc_set_line_attributes(
        (GdkGC*)a0
        ,(gint)a1
        ,(GdkLineStyle)a2
        ,(GdkCapStyle)a3
        ,(GdkJoinStyle)a4
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetExposures) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_BOOL(a1, x1);
    gdk_gc_set_exposures(
        (GdkGC*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetSubwindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkSubwindowMode a1 = GdkSubwindowModetFromWord(x1);
    gdk_gc_set_subwindow(
        (GdkGC*)a0
        ,(GdkSubwindowMode)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetClipRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT(a1, x1);
    gdk_gc_set_clip_region(
        (GdkGC*)a0
        ,(GdkRegion*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetClipRectangle) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_RECTANGLE);
    gdk_gc_set_clip_rectangle(
        (GdkGC*)a0
        ,(GdkRectangle*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetClipMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT(a1, x1);
    gdk_gc_set_clip_mask(
        (GdkGC*)a0
        ,(GdkBitmap*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_GCsetClipOrigin) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_gc_set_clip_origin(
        (GdkGC*)a0
        ,(gint)a1
        ,(gint)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_GCsetTsOrigin) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_gc_set_ts_origin(
        (GdkGC*)a0
        ,(gint)a1
        ,(gint)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetStipple) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXMAP);
    gdk_gc_set_stipple(
        (GdkGC*)a0
        ,(GdkPixmap*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetTile) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXMAP);
    gdk_gc_set_tile(
        (GdkGC*)a0
        ,(GdkPixmap*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetFill) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkFill a1 = GdkFilltFromWord(x1);
    gdk_gc_set_fill(
        (GdkGC*)a0
        ,(GdkFill)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetFont) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_FONT);
    gdk_gc_set_font(
        (GdkGC*)a0
        ,(GdkFont*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetBackground) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gdk_gc_set_background(
        (GdkGC*)a0
        ,(GdkColor*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_GCsetForeground) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gdk_gc_set_foreground(
        (GdkGC*)a0
        ,(GdkColor*)a1
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_GCgetType) {
    GType cres = (GType)gdk_gc_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE4(Gdk_Pixmapnew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    GdkPixmap* cres = (GdkPixmap*)gdk_pixmap_new(
        (GdkDrawable*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE4(Gdk_PixmapcolormapCreateFromXpmD) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    GdkBitmap* tmp0 = 0; GdkBitmap** a2 = &tmp0;
    DECLARE_OBJECT_OF_TYPE(a3, x2, GDK_TYPE_COLOR);
    DECLARE_ZERO_TERMINATED_ARRAY(a4, x3, gchar*, DECLARE_CSTRING(elem_c, elem_alice));
    GdkPixmap* cres = (GdkPixmap*)gdk_pixmap_colormap_create_from_xpm_d(
        (GdkDrawable*)a0
        ,(GdkColormap*)a1
        ,(GdkBitmap**)a2
        ,(GdkColor*)a3
        ,(gchar**)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r2 = OBJECT_TO_WORD(*a2, TYPE_BOXED);
    RETURN2(res,r2);
} END
DEFINE3(Gdk_PixmapcreateFromXpmD) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkBitmap* tmp0 = 0; GdkBitmap** a1 = &tmp0;
    DECLARE_OBJECT_OF_TYPE(a2, x1, GDK_TYPE_COLOR);
    DECLARE_ZERO_TERMINATED_ARRAY(a3, x2, gchar*, DECLARE_CSTRING(elem_c, elem_alice));
    GdkPixmap* cres = (GdkPixmap*)gdk_pixmap_create_from_xpm_d(
        (GdkDrawable*)a0
        ,(GdkBitmap**)a1
        ,(GdkColor*)a2
        ,(gchar**)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r1 = OBJECT_TO_WORD(*a1, TYPE_BOXED);
    RETURN2(res,r1);
} END
DEFINE4(Gdk_PixmapcolormapCreateFromXpm) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    GdkBitmap* tmp0 = 0; GdkBitmap** a2 = &tmp0;
    DECLARE_OBJECT_OF_TYPE(a3, x2, GDK_TYPE_COLOR);
    DECLARE_CSTRING(a4, x3);
    GdkPixmap* cres = (GdkPixmap*)gdk_pixmap_colormap_create_from_xpm(
        (GdkDrawable*)a0
        ,(GdkColormap*)a1
        ,(GdkBitmap**)a2
        ,(GdkColor*)a3
        ,(const gchar*)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r2 = OBJECT_TO_WORD(*a2, TYPE_BOXED);
    RETURN2(res,r2);
} END
DEFINE3(Gdk_PixmapcreateFromXpm) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkBitmap* tmp0 = 0; GdkBitmap** a1 = &tmp0;
    DECLARE_OBJECT_OF_TYPE(a2, x1, GDK_TYPE_COLOR);
    DECLARE_CSTRING(a3, x2);
    GdkPixmap* cres = (GdkPixmap*)gdk_pixmap_create_from_xpm(
        (GdkDrawable*)a0
        ,(GdkBitmap**)a1
        ,(GdkColor*)a2
        ,(const gchar*)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r1 = OBJECT_TO_WORD(*a1, TYPE_BOXED);
    RETURN2(res,r1);
} END
DEFINE7(Gdk_PixmapcreateFromData) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_OBJECT_OF_TYPE(a5, x5, GDK_TYPE_COLOR);
    DECLARE_OBJECT_OF_TYPE(a6, x6, GDK_TYPE_COLOR);
    GdkPixmap* cres = (GdkPixmap*)gdk_pixmap_create_from_data(
        (GdkDrawable*)a0
        ,(const gchar*)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(GdkColor*)a5
        ,(GdkColor*)a6
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_PixmapgetType) {
    GType cres = (GType)gdk_pixmap_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowconfigureFinished) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_configure_finished(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowenableSynchronizedConfigure) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_enable_synchronized_configure(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetFocusOnMap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_focus_on_map(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetAcceptFocus) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_accept_focus(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_WindowgetInternalPaintInfo) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkDrawable* tmp0 = 0; GdkDrawable** a1 = &tmp0;
    DECLARE_INT_AS(gint, tmp1, x1);
               gint* a2 = (gint*)&tmp1;
    DECLARE_INT_AS(gint, tmp2, x2);
               gint* a3 = (gint*)&tmp2;
    gdk_window_get_internal_paint_info(
        (GdkWindow*)a0
        ,(GdkDrawable**)a1
        ,(gint*)a2
        ,(gint*)a3
        );
    word r1 = OBJECT_TO_WORD(*a1,TYPE_G_OBJECT);
    word r2 = Store::IntToWord(*a2);
    word r3 = Store::IntToWord(*a3);
    RETURN3(r1,r2,r3);
} END
DEFINE1(Gdk_WindowsetDebugUpdates) {
    DECLARE_BOOL(a0, x0);
    gdk_window_set_debug_updates(
        (gboolean)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowprocessUpdates) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_process_updates(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_WindowprocessAllUpdates) {
    gdk_window_process_all_updates(
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowthawUpdates) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_thaw_updates(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowfreezeUpdates) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_freeze_updates(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowgetUpdateArea) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkRegion* cres = (GdkRegion*)gdk_window_get_update_area(
        (GdkWindow*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE3(Gdk_WindowinvalidateRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT(a1, x1);
    DECLARE_BOOL(a2, x2);
    gdk_window_invalidate_region(
        (GdkWindow*)a0
        ,(GdkRegion*)a1
        ,(gboolean)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_WindowinvalidateRect) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_RECTANGLE);
    DECLARE_BOOL(a2, x2);
    gdk_window_invalidate_rect(
        (GdkWindow*)a0
        ,(GdkRectangle*)a1
        ,(gboolean)a2
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_WindowbeginMoveDrag) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    gdk_window_begin_move_drag(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(guint32)a4
        );
    RETURN_UNIT;
} END
DEFINE6(Gdk_WindowbeginResizeDrag) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkWindowEdge a1 = GdkWindowEdgetFromWord(x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    gdk_window_begin_resize_drag(
        (GdkWindow*)a0
        ,(GdkWindowEdge)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(guint32)a5
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowregisterDnd) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_register_dnd(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowunfullscreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_unfullscreen(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowfullscreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_fullscreen(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowunmaximize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_unmaximize(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowmaximize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_maximize(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowunstick) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_unstick(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowstick) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_stick(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowdeiconify) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_deiconify(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowiconify) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_iconify(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_WindowgetToplevels) {
    GList* cres = (GList*)gdk_window_get_toplevels(
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_WindowgetDecorations) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkWMDecoration tmp2 = GdkWMDecorationtFromWord(x1);GdkWMDecoration *a1 = &tmp2;
    gboolean cres = (gboolean)gdk_window_get_decorations(
        (GdkWindow*)a0
        ,(GdkWMDecoration*)a1
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = GdkWMDecorationtToWord(*a1);
    RETURN2(res,r1);
} END
DEFINE2(Gdk_WindowsetDecorations) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkWMDecoration a1 = GdkWMDecorationtFromWord(x1);
    gdk_window_set_decorations(
        (GdkWindow*)a0
        ,(GdkWMDecoration)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowgetGroup) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkWindow* cres = (GdkWindow*)gdk_window_get_group(
        (GdkWindow*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_WindowsetGroup) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    gdk_window_set_group(
        (GdkWindow*)a0
        ,(GdkWindow*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetIconName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_CSTRING(a1, x1);
    gdk_window_set_icon_name(
        (GdkWindow*)a0
        ,(const gchar*)a1
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_WindowsetIcon) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_PIXMAP);
    DECLARE_OBJECT(a3, x3);
    gdk_window_set_icon(
        (GdkWindow*)a0
        ,(GdkWindow*)a1
        ,(GdkPixmap*)a2
        ,(GdkBitmap*)a3
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetIconList) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_GLIST(a1, x1, DECLARE_OBJECT);
    gdk_window_set_icon_list(
        (GdkWindow*)a0
        ,(GList*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetEvents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkEventMask a1 = GdkEventMasktFromWord(x1);
    gdk_window_set_events(
        (GdkWindow*)a0
        ,(GdkEventMask)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowgetEvents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkEventMask cres = (GdkEventMask)gdk_window_get_events(
        (GdkWindow*)a0
        );
    word res = GdkEventMasktToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowpeekChildren) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GList* cres = (GList*)gdk_window_peek_children(
        (GdkWindow*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowgetChildren) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GList* cres = (GList*)gdk_window_get_children(
        (GdkWindow*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowgetToplevel) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkWindow* cres = (GdkWindow*)gdk_window_get_toplevel(
        (GdkWindow*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowgetParent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkWindow* cres = (GdkWindow*)gdk_window_get_parent(
        (GdkWindow*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE4(Gdk_WindowgetPointer) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    DECLARE_LIST_ELEMS(tmp2, tmp3, x3, 
{ if (Store::WordToInt(tmp2->Sel(0)) == INVALID_INT)
{REQUEST(x3);}
});
GdkModifierType tmp4 = GdkModifierTypetFromWord(x3);GdkModifierType *a3 = &tmp4;
    GdkWindow* cres = (GdkWindow*)gdk_window_get_pointer(
        (GdkWindow*)a0
        ,(gint*)a1
        ,(gint*)a2
        ,(GdkModifierType*)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    word r3 = GdkModifierTypetToWord(*a3);
    RETURN4(res,r1,r2,r3);
} END
DEFINE2(Gdk_WindowgetFrameExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_RECTANGLE);
    gdk_window_get_frame_extents(
        (GdkWindow*)a0
        ,(GdkRectangle*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_WindowgetRootOrigin) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    gdk_window_get_root_origin(
        (GdkWindow*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE3(Gdk_WindowgetDeskrelativeOrigin) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    gboolean cres = (gboolean)gdk_window_get_deskrelative_origin(
        (GdkWindow*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN3(res,r1,r2);
} END
DEFINE3(Gdk_WindowgetOrigin) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    gint cres = (gint)gdk_window_get_origin(
        (GdkWindow*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word res = Store::IntToWord(cres);
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN3(res,r1,r2);
} END
DEFINE3(Gdk_WindowgetPosition) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    gdk_window_get_position(
        (GdkWindow*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE6(Gdk_WindowgetGeometry) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    DECLARE_INT_AS(gint, tmp2, x3);
               gint* a3 = (gint*)&tmp2;
    DECLARE_INT_AS(gint, tmp3, x4);
               gint* a4 = (gint*)&tmp3;
    DECLARE_INT_AS(gint, tmp4, x5);
               gint* a5 = (gint*)&tmp4;
    gdk_window_get_geometry(
        (GdkWindow*)a0
        ,(gint*)a1
        ,(gint*)a2
        ,(gint*)a3
        ,(gint*)a4
        ,(gint*)a5
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    word r3 = Store::IntToWord(*a3);
    word r4 = Store::IntToWord(*a4);
    word r5 = Store::IntToWord(*a5);
    RETURN5(r1,r2,r3,r4,r5);
} END
DEFINE2(Gdk_WindowsetCursor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_CURSOR);
    gdk_window_set_cursor(
        (GdkWindow*)a0
        ,(GdkCursor*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_WindowsetBackPixmap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXMAP);
    DECLARE_BOOL(a2, x2);
    gdk_window_set_back_pixmap(
        (GdkWindow*)a0
        ,(GdkPixmap*)a1
        ,(gboolean)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetBackground) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gdk_window_set_background(
        (GdkWindow*)a0
        ,(GdkColor*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetTransientFor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    gdk_window_set_transient_for(
        (GdkWindow*)a0
        ,(GdkWindow*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetRole) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_CSTRING(a1, x1);
    gdk_window_set_role(
        (GdkWindow*)a0
        ,(const gchar*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetTitle) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_CSTRING(a1, x1);
    gdk_window_set_title(
        (GdkWindow*)a0
        ,(const gchar*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowendPaint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_end_paint(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowbeginPaintRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT(a1, x1);
    gdk_window_begin_paint_region(
        (GdkWindow*)a0
        ,(GdkRegion*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowbeginPaintRect) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_RECTANGLE);
    gdk_window_begin_paint_rect(
        (GdkWindow*)a0
        ,(GdkRectangle*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetSkipPagerHint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_skip_pager_hint(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetSkipTaskbarHint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_skip_taskbar_hint(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetModalHint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_modal_hint(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetTypeHint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkWindowTypeHint a1 = GdkWindowTypeHinttFromWord(x1);
    gdk_window_set_type_hint(
        (GdkWindow*)a0
        ,(GdkWindowTypeHint)a1
        );
    RETURN_UNIT;
} END
DEFINE8(Gdk_WindowsetHints) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    gdk_window_set_hints(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(gint)a6
        ,(gint)a7
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetStaticGravities) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gboolean cres = (gboolean)gdk_window_set_static_gravities(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowgetState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkWindowState cres = (GdkWindowState)gdk_window_get_state(
        (GdkWindow*)a0
        );
    word res = GdkWindowStatetToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowisViewable) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gboolean cres = (gboolean)gdk_window_is_viewable(
        (GdkWindow*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowisVisible) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gboolean cres = (gboolean)gdk_window_is_visible(
        (GdkWindow*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_WindowmergeChildShapes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_merge_child_shapes(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowsetChildShapes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_set_child_shapes(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_WindowshapeCombineMask) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gdk_window_shape_combine_mask(
        (GdkWindow*)a0
        ,(GdkBitmap*)a1
        ,(gint)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_Windowscroll) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_window_scroll(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetOverrideRedirect) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_override_redirect(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetUserData) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT(a1, x1);
    gdk_window_set_user_data(
        (GdkWindow*)a0
        ,(gpointer)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_Windowfocus) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    gdk_window_focus(
        (GdkWindow*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowlowerWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_lower(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_WindowraiseWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_raise(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_WindowclearAreaE) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    gdk_window_clear_area_e(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_WindowclearArea) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    gdk_window_clear_area(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowclear) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_clear(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_Windowreparent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gdk_window_reparent(
        (GdkWindow*)a0
        ,(GdkWindow*)a1
        ,(gint)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_WindowmoveResize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    gdk_window_move_resize(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_Windowresize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_window_resize(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_Windowmove) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_window_move(
        (GdkWindow*)a0
        ,(gint)a1
        ,(gint)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowwithdraw) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_withdraw(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowhide) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_hide(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Windowshow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_show(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowatPointer) {
    DECLARE_INT_AS(gint, tmp0, x0);
               gint* a0 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x1);
               gint* a1 = (gint*)&tmp1;
    GdkWindow* cres = (GdkWindow*)gdk_window_at_pointer(
        (gint*)a0
        ,(gint*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r0 = Store::IntToWord(*a0);
    word r1 = Store::IntToWord(*a1);
    RETURN3(res,r0,r1);
} END
DEFINE1(Gdk_WindowgetWindowType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    GdkWindowType cres = (GdkWindowType)gdk_window_get_window_type(
        (GdkWindow*)a0
        );
    word res = GdkWindowTypetToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_Windowdestroy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    gdk_window_destroy(
        (GdkWindow*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetKeepBelow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_keep_below(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowsetKeepAbove) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    gdk_window_set_keep_above(
        (GdkWindow*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_WindowobjectGetType) {
    GType cres = (GType)gdk_window_object_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE4(Gdk_WindowselectionConvert) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    DECLARE_WORD32(tmp1, x2); GdkAtom a2 = (GdkAtom)tmp1;
    DECLARE_INT(a3, x3);
    gdk_selection_convert(
        (GdkWindow*)a0
        ,(GdkAtom)a1
        ,(GdkAtom)a2
        ,(guint32)a3
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowpropertyDelete) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    gdk_property_delete(
        (GdkWindow*)a0
        ,(GdkAtom)a1
        );
    RETURN_UNIT;
} END
DEFINE7(Gdk_WindowpropertyChange) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    DECLARE_WORD32(tmp1, x2); GdkAtom a2 = (GdkAtom)tmp1;
    DECLARE_INT(a3, x3);
    if (Store::WordToInt(x4) == INVALID_INT) {REQUEST(x4);}
GdkPropMode a4 = GdkPropModetFromWord(x4);
    DECLARE_CSTRING(a5, x5);
    DECLARE_INT(a6, x6);
    gdk_property_change(
        (GdkWindow*)a0
        ,(GdkAtom)a1
        ,(GdkAtom)a2
        ,(gint)a3
        ,(GdkPropMode)a4
        ,(const guchar*)a5
        ,(gint)a6
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_WindowinputSetExtensionEvents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_INT(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
GdkExtensionMode a2 = GdkExtensionModetFromWord(x2);
    gdk_input_set_extension_events(
        (GdkWindow*)a0
        ,(gint)a1
        ,(GdkExtensionMode)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_WindowdragBegin) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_GLIST(a1, x1, DECLARE_OBJECT);
    GdkDragContext* cres = (GdkDragContext*)gdk_drag_begin(
        (GdkWindow*)a0
        ,(GList*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE9(Gdk_DrawabledrawGrayImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    if (Store::WordToInt(x6) == INVALID_INT) {REQUEST(x6);}
GdkRgbDither a6 = GdkRgbDithertFromWord(x6);
    DECLARE_CSTRING(a7, x7);
    DECLARE_INT(a8, x8);
    gdk_draw_gray_image(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(GdkRgbDither)a6
        ,(guchar*)a7
        ,(gint)a8
        );
    RETURN_UNIT;
} END
DEFINE9(Gdk_DrawabledrawRgb32Image) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    if (Store::WordToInt(x6) == INVALID_INT) {REQUEST(x6);}
GdkRgbDither a6 = GdkRgbDithertFromWord(x6);
    DECLARE_CSTRING(a7, x7);
    DECLARE_INT(a8, x8);
    gdk_draw_rgb_32_image(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(GdkRgbDither)a6
        ,(guchar*)a7
        ,(gint)a8
        );
    RETURN_UNIT;
} END
DEFINE11(Gdk_DrawabledrawRgbImageDithalign) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    if (Store::WordToInt(x6) == INVALID_INT) {REQUEST(x6);}
GdkRgbDither a6 = GdkRgbDithertFromWord(x6);
    DECLARE_CSTRING(a7, x7);
    DECLARE_INT(a8, x8);
    DECLARE_INT(a9, x9);
    DECLARE_INT(a10, x10);
    gdk_draw_rgb_image_dithalign(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(GdkRgbDither)a6
        ,(guchar*)a7
        ,(gint)a8
        ,(gint)a9
        ,(gint)a10
        );
    RETURN_UNIT;
} END
DEFINE9(Gdk_DrawabledrawRgbImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    if (Store::WordToInt(x6) == INVALID_INT) {REQUEST(x6);}
GdkRgbDither a6 = GdkRgbDithertFromWord(x6);
    DECLARE_CSTRING(a7, x7);
    DECLARE_INT(a8, x8);
    gdk_draw_rgb_image(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(GdkRgbDither)a6
        ,(guchar*)a7
        ,(gint)a8
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_DrawableimageGet) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    GdkImage* cres = (GdkImage*)gdk_image_get(
        (GdkDrawable*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetVisibleRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkRegion* cres = (GdkRegion*)gdk_drawable_get_visible_region(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetClipRegion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkRegion* cres = (GdkRegion*)gdk_drawable_get_clip_region(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE5(Gdk_DrawablegetImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    GdkImage* cres = (GdkImage*)gdk_drawable_get_image(
        (GdkDrawable*)a0
        ,(gint)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE5(Gdk_DrawabledrawLayout) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_OBJECT_OF_TYPE(a4, x4, PANGO_TYPE_LAYOUT);
    gdk_draw_layout(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(PangoLayout*)a4
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_DrawabledrawLayoutLine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_OBJECT(a4, x4);
    gdk_draw_layout_line(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(PangoLayoutLine*)a4
        );
    RETURN_UNIT;
} END
DEFINE6(Gdk_DrawabledrawGlyphs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a2, x2, PANGO_TYPE_FONT);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_OBJECT_OF_TYPE(a5, x5, PANGO_TYPE_GLYPH_STRING);
    gdk_draw_glyphs(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(PangoFont*)a2
        ,(gint)a3
        ,(gint)a4
        ,(PangoGlyphString*)a5
        );
    RETURN_UNIT;
} END
DEFINE12(Gdk_DrawabledrawPixbuf) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_PIXBUF);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    if (Store::WordToInt(x9) == INVALID_INT) {REQUEST(x9);}
GdkRgbDither a9 = GdkRgbDithertFromWord(x9);
    DECLARE_INT(a10, x10);
    DECLARE_INT(a11, x11);
    gdk_draw_pixbuf(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(GdkPixbuf*)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(gint)a6
        ,(gint)a7
        ,(gint)a8
        ,(GdkRgbDither)a9
        ,(gint)a10
        ,(gint)a11
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DrawabledrawLines) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_OBJECT(a2, x2);
    DECLARE_INT(a3, x3);
    gdk_draw_lines(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(GdkPoint*)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DrawabledrawPoints) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_OBJECT(a2, x2);
    DECLARE_INT(a3, x3);
    gdk_draw_points(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(GdkPoint*)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE9(Gdk_DrawabledrawImage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_IMAGE);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    gdk_draw_image(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(GdkImage*)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(gint)a6
        ,(gint)a7
        ,(gint)a8
        );
    RETURN_UNIT;
} END
DEFINE9(Gdk_DrawabledrawDrawable) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_DRAWABLE);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    gdk_draw_drawable(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(GdkDrawable*)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(gint)a6
        ,(gint)a7
        ,(gint)a8
        );
    RETURN_UNIT;
} END
DEFINE7(Gdk_DrawabledrawText) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_FONT);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_GC);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_CSTRING(a5, x5);
    DECLARE_INT(a6, x6);
    gdk_draw_text(
        (GdkDrawable*)a0
        ,(GdkFont*)a1
        ,(GdkGC*)a2
        ,(gint)a3
        ,(gint)a4
        ,(const gchar*)a5
        ,(gint)a6
        );
    RETURN_UNIT;
} END
DEFINE6(Gdk_DrawabledrawString) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_FONT);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_GC);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_CSTRING(a5, x5);
    gdk_draw_string(
        (GdkDrawable*)a0
        ,(GdkFont*)a1
        ,(GdkGC*)a2
        ,(gint)a3
        ,(gint)a4
        ,(const gchar*)a5
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_DrawabledrawPolygon) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_BOOL(a2, x2);
    DECLARE_OBJECT(a3, x3);
    DECLARE_INT(a4, x4);
    gdk_draw_polygon(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gboolean)a2
        ,(GdkPoint*)a3
        ,(gint)a4
        );
    RETURN_UNIT;
} END
DEFINE9(Gdk_DrawabledrawArc) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_BOOL(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    DECLARE_INT(a7, x7);
    DECLARE_INT(a8, x8);
    gdk_draw_arc(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gboolean)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(gint)a6
        ,(gint)a7
        ,(gint)a8
        );
    RETURN_UNIT;
} END
DEFINE7(Gdk_DrawabledrawRectangle) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_BOOL(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    gdk_draw_rectangle(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gboolean)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        ,(gint)a6
        );
    RETURN_UNIT;
} END
DEFINE6(Gdk_DrawabledrawLine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    gdk_draw_line(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(gint)a4
        ,(gint)a5
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DrawabledrawPoint) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gdk_draw_point(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Drawableunref) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    gdk_drawable_unref(
        (GdkDrawable*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Drawablereference) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkDrawable* cres = (GdkDrawable*)gdk_drawable_ref(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkDisplay* cres = (GdkDisplay*)gdk_drawable_get_display(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkScreen* cres = (GdkScreen*)gdk_drawable_get_screen(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetDepth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    gint cres = (gint)gdk_drawable_get_depth(
        (GdkDrawable*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetVisual) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkVisual* cres = (GdkVisual*)gdk_drawable_get_visual(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DrawablegetColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    GdkColormap* cres = (GdkColormap*)gdk_drawable_get_colormap(
        (GdkDrawable*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_DrawablesetColormap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    gdk_drawable_set_colormap(
        (GdkDrawable*)a0
        ,(GdkColormap*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_DrawablegetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    gdk_drawable_get_size(
        (GdkDrawable*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE2(Gdk_DrawablegetData) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_CSTRING(a1, x1);
    gpointer cres = (gpointer)gdk_drawable_get_data(
        (GdkDrawable*)a0
        ,(const gchar*)a1
        );
    word res = OBJECT_TO_WORD(cres, TYPE_POINTER);
    RETURN1(res);
} END
DEFINE4(Gdk_DrawablesetData) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_CSTRING(a1, x1);
    DECLARE_OBJECT(a2, x2);
    GDestroyNotify a3 = 0; // FIXME not possible in seam
    gdk_drawable_set_data(
        (GdkDrawable*)a0
        ,(const gchar*)a1
        ,(gpointer)a2
        ,(GDestroyNotify)a3
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_DrawablegetType) {
    GType cres = (GType)gdk_drawable_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_DragContextnew) {
    GdkDragContext* cres = (GdkDragContext*)gdk_drag_context_new(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
#define DOgetFieldAction(O) ((O)->action)
#define DOsetFieldAction(O, V) ((O)->action = (V))
#define DOgetFieldActions(O) ((O)->actions)
#define DOsetFieldActions(O, V) ((O)->actions = (V))
#define DOgetFieldDestWindow(O) ((O)->dest_window)
#define DOsetFieldDestWindow(O, V) ((O)->dest_window = (V))
#define DOgetFieldIsSource(O) ((O)->is_source)
#define DOsetFieldIsSource(O, V) ((O)->is_source = (V))
#define DOgetFieldProtocol(O) ((O)->protocol)
#define DOsetFieldProtocol(O, V) ((O)->protocol = (V))
#define DOgetFieldSourceWindow(O) ((O)->source_window)
#define DOsetFieldSourceWindow(O, V) ((O)->source_window = (V))
#define DOgetFieldStartTime(O) ((O)->start_time)
#define DOsetFieldStartTime(O, V) ((O)->start_time = (V))
#define DOgetFieldSuggestedAction(O) ((O)->suggested_action)
#define DOsetFieldSuggestedAction(O, V) ((O)->suggested_action = (V))
#define DOgetFieldTargets(O) ((O)->targets)
#define DOsetFieldTargets(O, V) ((O)->targets = (V))
DEFINE1(Gdk_DragContextsetIconDefault) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    gtk_drag_set_icon_default(
        (GdkDragContext*)a0
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DragContextsetIconStock) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gtk_drag_set_icon_stock(
        (GdkDragContext*)a0
        ,(const gchar*)a1
        ,(gint)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DragContextsetIconPixbuf) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_PIXBUF);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gtk_drag_set_icon_pixbuf(
        (GdkDragContext*)a0
        ,(GdkPixbuf*)a1
        ,(gint)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE6(Gdk_DragContextsetIconPixmap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLORMAP);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_PIXMAP);
    DECLARE_OBJECT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT(a5, x5);
    gtk_drag_set_icon_pixmap(
        (GdkDragContext*)a0
        ,(GdkColormap*)a1
        ,(GdkPixmap*)a2
        ,(GdkBitmap*)a3
        ,(gint)a4
        ,(gint)a5
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DragContextsetIconWidget) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GTK_TYPE_WIDGET);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    gtk_drag_set_icon_widget(
        (GdkDragContext*)a0
        ,(GtkWidget*)a1
        ,(gint)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetSourceWidget) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GtkWidget* cres = (GtkWidget*)gtk_drag_get_source_widget(
        (GdkDragContext*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_GTK_OBJECT);
    RETURN1(res);
} END
DEFINE4(Gdk_DragContextfinish) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_BOOL(a1, x1);
    DECLARE_BOOL(a2, x2);
    DECLARE_INT(a3, x3);
    gtk_drag_finish(
        (GdkDragContext*)a0
        ,(gboolean)a1
        ,(gboolean)a2
        ,(guint32)a3
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextdragDropSucceeded) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    gboolean cres = (gboolean)gdk_drag_drop_succeeded(
        (GdkDragContext*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextdragAbort) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_INT(a1, x1);
    gdk_drag_abort(
        (GdkDragContext*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_DragContextdragDrop) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_INT(a1, x1);
    gdk_drag_drop(
        (GdkDragContext*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE8(Gdk_DragContextdragMotion) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
GdkDragProtocol a2 = GdkDragProtocoltFromWord(x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x5, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x5);}
});
GdkDragAction a5 = GdkDragActiontFromWord(x5);
    DECLARE_LIST_ELEMS(tmp2, tmp3, x6, 
{ if (Store::WordToInt(tmp2->Sel(0)) == INVALID_INT)
{REQUEST(x6);}
});
GdkDragAction a6 = GdkDragActiontFromWord(x6);
    DECLARE_INT(a7, x7);
    gboolean cres = (gboolean)gdk_drag_motion(
        (GdkDragContext*)a0
        ,(GdkWindow*)a1
        ,(GdkDragProtocol)a2
        ,(gint)a3
        ,(gint)a4
        ,(GdkDragAction)a5
        ,(GdkDragAction)a6
        ,(guint32)a7
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE6(Gdk_DragContextdragFindWindowForScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_SCREEN);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    GdkWindow* tmp0 = 0; GdkWindow** a5 = &tmp0;
    if (Store::WordToInt(x5) == INVALID_INT) {REQUEST(x5);}
GdkDragProtocol tmp1 = GdkDragProtocoltFromWord(x5);GdkDragProtocol *a6 = &tmp1;
    gdk_drag_find_window_for_screen(
        (GdkDragContext*)a0
        ,(GdkWindow*)a1
        ,(GdkScreen*)a2
        ,(gint)a3
        ,(gint)a4
        ,(GdkWindow**)a5
        ,(GdkDragProtocol*)a6
        );
    word r5 = OBJECT_TO_WORD(*a5,TYPE_G_OBJECT);
    word r6 = GdkDragProtocoltToWord(*a6);
    RETURN2(r5,r6);
} END
DEFINE5(Gdk_DragContextdragFindWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    GdkWindow* tmp0 = 0; GdkWindow** a4 = &tmp0;
    if (Store::WordToInt(x4) == INVALID_INT) {REQUEST(x4);}
GdkDragProtocol tmp1 = GdkDragProtocoltFromWord(x4);GdkDragProtocol *a5 = &tmp1;
    gdk_drag_find_window(
        (GdkDragContext*)a0
        ,(GdkWindow*)a1
        ,(gint)a2
        ,(gint)a3
        ,(GdkWindow**)a4
        ,(GdkDragProtocol*)a5
        );
    word r4 = OBJECT_TO_WORD(*a4,TYPE_G_OBJECT);
    word r5 = GdkDragProtocoltToWord(*a5);
    RETURN2(r4,r5);
} END
DEFINE1(Gdk_DragContextdragGetSelection) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkAtom cres = (GdkAtom)gdk_drag_get_selection(
        (GdkDragContext*)a0
        );
    word res = Word32ToWord ((u_int)cres);
    RETURN1(res);
} END
DEFINE3(Gdk_DragContextdropFinish) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_BOOL(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_drop_finish(
        (GdkDragContext*)a0
        ,(gboolean)a1
        ,(guint32)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_DragContextdropReply) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_BOOL(a1, x1);
    DECLARE_INT(a2, x2);
    gdk_drop_reply(
        (GdkDragContext*)a0
        ,(gboolean)a1
        ,(guint32)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_DragContextdragStatus) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkDragAction a1 = GdkDragActiontFromWord(x1);
    DECLARE_INT(a2, x2);
    gdk_drag_status(
        (GdkDragContext*)a0
        ,(GdkDragAction)a1
        ,(guint32)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextunref) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    gdk_drag_context_unref(
        (GdkDragContext*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextreference) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    gdk_drag_context_ref(
        (GdkDragContext*)a0
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_DragContextgetType) {
    GType cres = (GType)gdk_drag_context_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DragContextgetFieldTargets) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GList* cres = (GList*)DOgetFieldTargets(
        (GdkDragContext*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldTargets) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_GLIST(a1, x1, DECLARE_OBJECT);
    DOsetFieldTargets(
        (GdkDragContext*)a0
        ,(GList*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldSuggestedAction) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkDragAction cres = (GdkDragAction)DOgetFieldSuggestedAction(
        (GdkDragContext*)a0
        );
    word res = GdkDragActiontToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldSuggestedAction) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkDragAction a1 = GdkDragActiontFromWord(x1);
    DOsetFieldSuggestedAction(
        (GdkDragContext*)a0
        ,(GdkDragAction)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldStartTime) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    guint32 cres = (guint32)DOgetFieldStartTime(
        (GdkDragContext*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldStartTime) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_INT(a1, x1);
    DOsetFieldStartTime(
        (GdkDragContext*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldSourceWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkWindow* cres = (GdkWindow*)DOgetFieldSourceWindow(
        (GdkDragContext*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldSourceWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DOsetFieldSourceWindow(
        (GdkDragContext*)a0
        ,(GdkWindow*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldProtocol) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkDragProtocol cres = (GdkDragProtocol)DOgetFieldProtocol(
        (GdkDragContext*)a0
        );
    word res = GdkDragProtocoltToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldProtocol) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkDragProtocol a1 = GdkDragProtocoltFromWord(x1);
    DOsetFieldProtocol(
        (GdkDragContext*)a0
        ,(GdkDragProtocol)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldIsSource) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    gboolean cres = (gboolean)DOgetFieldIsSource(
        (GdkDragContext*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldIsSource) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_BOOL(a1, x1);
    DOsetFieldIsSource(
        (GdkDragContext*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldDestWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkWindow* cres = (GdkWindow*)DOgetFieldDestWindow(
        (GdkDragContext*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldDestWindow) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DOsetFieldDestWindow(
        (GdkDragContext*)a0
        ,(GdkWindow*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldActions) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkDragAction cres = (GdkDragAction)DOgetFieldActions(
        (GdkDragContext*)a0
        );
    word res = GdkDragActiontToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldActions) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkDragAction a1 = GdkDragActiontFromWord(x1);
    DOsetFieldActions(
        (GdkDragContext*)a0
        ,(GdkDragAction)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DragContextgetFieldAction) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    GdkDragAction cres = (GdkDragAction)DOgetFieldAction(
        (GdkDragContext*)a0
        );
    word res = GdkDragActiontToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DragContextsetFieldAction) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAG_CONTEXT);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
GdkDragAction a1 = GdkDragActiontFromWord(x1);
    DOsetFieldAction(
        (GdkDragContext*)a0
        ,(GdkDragAction)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldAction
#undef DOsetFieldAction
#undef DOgetFieldActions
#undef DOsetFieldActions
#undef DOgetFieldDestWindow
#undef DOsetFieldDestWindow
#undef DOgetFieldIsSource
#undef DOsetFieldIsSource
#undef DOgetFieldProtocol
#undef DOsetFieldProtocol
#undef DOgetFieldSourceWindow
#undef DOsetFieldSourceWindow
#undef DOgetFieldStartTime
#undef DOsetFieldStartTime
#undef DOgetFieldSuggestedAction
#undef DOsetFieldSuggestedAction
#undef DOgetFieldTargets
#undef DOsetFieldTargets
DEFINE1(Gdk_DisplayManagerlistDisplays) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY_MANAGER);
    GSList* cres = (GSList*)gdk_display_manager_list_displays(
        (GdkDisplayManager*)a0
        );
    word res = GSLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DisplayManagersetDefaultDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY_MANAGER);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_DISPLAY);
    gdk_display_manager_set_default_display(
        (GdkDisplayManager*)a0
        ,(GdkDisplay*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DisplayManagergetDefaultDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY_MANAGER);
    GdkDisplay* cres = (GdkDisplay*)gdk_display_manager_get_default_display(
        (GdkDisplayManager*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_DisplayManagerget) {
    GdkDisplayManager* cres = (GdkDisplayManager*)gdk_display_manager_get(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_DisplayManagergetType) {
    GType cres = (GType)gdk_display_manager_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplayopenDisplay) {
    DECLARE_CSTRING(a0, x0);
    GdkDisplay* cres = (GdkDisplay*)gdk_display_open(
        (const gchar*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaygetDefaultGroup) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    GdkWindow* cres = (GdkWindow*)gdk_display_get_default_group(
        (GdkDisplay*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_DisplaygetMaximalCursorSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT_AS(guint, tmp0, x1);
               int* a1 = (int*)&tmp0;
    DECLARE_INT_AS(guint, tmp1, x2);
               int* a2 = (int*)&tmp1;
    gdk_display_get_maximal_cursor_size(
        (GdkDisplay*)a0
        ,(guint*)a1
        ,(guint*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE1(Gdk_DisplaygetDefaultCursorSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    guint cres = (guint)gdk_display_get_default_cursor_size(
        (GdkDisplay*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaysupportsCursorColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gboolean cres = (gboolean)gdk_display_supports_cursor_color(
        (GdkDisplay*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaysupportsCursorAlpha) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gboolean cres = (gboolean)gdk_display_supports_cursor_alpha(
        (GdkDisplay*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DisplaysetDoubleClickDistance) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    gdk_display_set_double_click_distance(
        (GdkDisplay*)a0
        ,(guint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Displayflush) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gdk_display_flush(
        (GdkDisplay*)a0
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DisplaystoreClipboard) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_INT(a2, x2);
    DECLARE_C_ARG_ARRAY(a3, a3size, x3, gint, GdkAtom, DECLARE_WORD32(tmp0, elem_alice); GdkAtom elem_c = (GdkAtom)tmp0;);
    gdk_display_store_clipboard(
        (GdkDisplay*)a0
        ,(GdkWindow*)a1
        ,(guint32)a2
        ,(GdkAtom*)a3, (gint)a3size
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DisplaysupportsClipboardPersistence) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gboolean cres = (gboolean)gdk_display_supports_clipboard_persistence(
        (GdkDisplay*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DisplayrequestSelectionNotification) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    gboolean cres = (gboolean)gdk_display_request_selection_notification(
        (GdkDisplay*)a0
        ,(GdkAtom)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaysupportsSelectionNotification) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gboolean cres = (gboolean)gdk_display_supports_selection_notification(
        (GdkDisplay*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_DisplayopenDefaultLibgtkOnly) {
    GdkDisplay* cres = (GdkDisplay*)gdk_display_open_default_libgtk_only(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_DisplaygetWindowAtPointer) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x2);
               gint* a2 = (gint*)&tmp1;
    GdkWindow* cres = (GdkWindow*)gdk_display_get_window_at_pointer(
        (GdkDisplay*)a0
        ,(gint*)a1
        ,(gint*)a2
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN3(res,r1,r2);
} END
DEFINE1(Gdk_DisplaygetCorePointer) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    GdkDevice* cres = (GdkDevice*)gdk_display_get_core_pointer(
        (GdkDisplay*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_DisplaygetDefault) {
    GdkDisplay* cres = (GdkDisplay*)gdk_display_get_default(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_DisplaysetDoubleClickTime) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    gdk_display_set_double_click_time(
        (GdkDisplay*)a0
        ,(guint)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_DisplayputEvent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_EVENT);
    gdk_display_put_event(
        (GdkDisplay*)a0
        ,(GdkEvent*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DisplaypeekEvent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    GdkEvent* cres = (GdkEvent*)gdk_display_peek_event(
        (GdkDisplay*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaygetEvent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    GdkEvent* cres = (GdkEvent*)gdk_display_get_event(
        (GdkDisplay*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_EVENT);
    RETURN1(res);
} END
DEFINE1(Gdk_Displayclose) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gdk_display_close(
        (GdkDisplay*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Displaysync) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gdk_display_sync(
        (GdkDisplay*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_Displaybeep) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gdk_display_beep(
        (GdkDisplay*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DisplaypointerIsGrabbed) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gboolean cres = (gboolean)gdk_display_pointer_is_grabbed(
        (GdkDisplay*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DisplaykeyboardUngrab) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    gdk_display_keyboard_ungrab(
        (GdkDisplay*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_DisplaypointerUngrab) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    gdk_display_pointer_ungrab(
        (GdkDisplay*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DisplaygetDefaultScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    GdkScreen* cres = (GdkScreen*)gdk_display_get_default_screen(
        (GdkDisplay*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_DisplaygetScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    GdkScreen* cres = (GdkScreen*)gdk_display_get_screen(
        (GdkDisplay*)a0
        ,(gint)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaygetNScreens) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    gint cres = (gint)gdk_display_get_n_screens(
        (GdkDisplay*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DisplaygetName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    const gchar* cres = (const gchar*)gdk_display_get_name(
        (GdkDisplay*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Gdk_DisplaygetType) {
    GType cres = (GType)gdk_display_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
GdkDevice* MK_GdkDeviceNew (
        GdkDeviceAxis* axes
        , gboolean has_cursor
        , GdkDeviceKey* keys
        , GdkInputMode mode
        , gchar* name
        , gint num_axes
        , gint num_keys
        , GdkInputSource source
        ) {
    GdkDevice* res_ = new GdkDevice;
    res_->axes = axes;
    res_->has_cursor = has_cursor;
    res_->keys = keys;
    res_->mode = mode;
    res_->name = name;
    res_->num_axes = num_axes;
    res_->num_keys = num_keys;
    res_->source = source;
    return res_;
}
DEFINE8(Gdk_Devicenew) {
    DECLARE_OBJECT (a0, x0);
    DECLARE_BOOL(a1, x1);
    DECLARE_OBJECT (a2, x2);
    if (Store::WordToInt(x3) == INVALID_INT) {REQUEST(x3);}
GdkInputMode a3 = GdkInputModetFromWord(x3);
    DECLARE_CSTRING(a4, x4);
    DECLARE_INT(a5, x5);
    DECLARE_INT(a6, x6);
    if (Store::WordToInt(x7) == INVALID_INT) {REQUEST(x7);}
GdkInputSource a7 = GdkInputSourcetFromWord(x7);
    GdkDevice* cres = (GdkDevice*)MK_GdkDeviceNew(
        (GdkDeviceAxis*)a0
        ,(gboolean)a1
        ,(GdkDeviceKey*)a2
        ,(GdkInputMode)a3
        ,(gchar*)a4
        ,(gint)a5
        ,(gint)a6
        ,(GdkInputSource)a7
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
#define DOgetFieldAxes(O) ((O)->axes)
#define DOsetFieldAxes(O, V) ((O)->axes = (V))
#define DOgetFieldHasCursor(O) ((O)->has_cursor)
#define DOsetFieldHasCursor(O, V) ((O)->has_cursor = (V))
#define DOgetFieldKeys(O) ((O)->keys)
#define DOsetFieldKeys(O, V) ((O)->keys = (V))
#define DOgetFieldMode(O) ((O)->mode)
#define DOsetFieldMode(O, V) ((O)->mode = (V))
#define DOgetFieldName(O) ((O)->name)
#define DOsetFieldName(O, V) ((O)->name = (V))
#define DOgetFieldNumAxes(O) ((O)->num_axes)
#define DOsetFieldNumAxes(O, V) ((O)->num_axes = (V))
#define DOgetFieldNumKeys(O) ((O)->num_keys)
#define DOsetFieldNumKeys(O, V) ((O)->num_keys = (V))
#define DOgetFieldSource(O) ((O)->source)
#define DOsetFieldSource(O, V) ((O)->source = (V))
DEFINE0(Gdk_DevicegetCorePointer) {
    GdkDevice* cres = (GdkDevice*)gdk_device_get_core_pointer(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE4(Gdk_DevicegetAxis) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_DOUBLE_AS(gdouble, tmp0, x1);
               gdouble* a1 = (gdouble*)&tmp0;
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
GdkAxisUse a2 = GdkAxisUsetFromWord(x2);
    DECLARE_DOUBLE_AS(gdouble, tmp1, x3);
               gdouble* a3 = (gdouble*)&tmp1;
    gboolean cres = (gboolean)gdk_device_get_axis(
        (GdkDevice*)a0
        ,(gdouble*)a1
        ,(GdkAxisUse)a2
        ,(gdouble*)a3
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = Real::New(*a1)->ToWord ();
    word r3 = Real::New(*a3)->ToWord ();
    RETURN3(res,r1,r3);
} END
DEFINE4(Gdk_DevicegetState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_DOUBLE_AS(gdouble, tmp0, x2);
               gdouble* a2 = (gdouble*)&tmp0;
    DECLARE_LIST_ELEMS(tmp1, tmp2, x3, 
{ if (Store::WordToInt(tmp1->Sel(0)) == INVALID_INT)
{REQUEST(x3);}
});
GdkModifierType tmp3 = GdkModifierTypetFromWord(x3);GdkModifierType *a3 = &tmp3;
    gdk_device_get_state(
        (GdkDevice*)a0
        ,(GdkWindow*)a1
        ,(gdouble*)a2
        ,(GdkModifierType*)a3
        );
    word r2 = Real::New(*a2)->ToWord ();
    word r3 = GdkModifierTypetToWord(*a3);
    RETURN2(r2,r3);
} END
DEFINE3(Gdk_DevicesetAxisUse) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_INT(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
GdkAxisUse a2 = GdkAxisUsetFromWord(x2);
    gdk_device_set_axis_use(
        (GdkDevice*)a0
        ,(guint)a1
        ,(GdkAxisUse)a2
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_DevicesetKey) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x3, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x3);}
});
GdkModifierType a3 = GdkModifierTypetFromWord(x3);
    gdk_device_set_key(
        (GdkDevice*)a0
        ,(guint)a1
        ,(guint)a2
        ,(GdkModifierType)a3
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_DevicesetMode) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkInputMode a1 = GdkInputModetFromWord(x1);
    gboolean cres = (gboolean)gdk_device_set_mode(
        (GdkDevice*)a0
        ,(GdkInputMode)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetSource) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkInputSource a1 = GdkInputSourcetFromWord(x1);
    gdk_device_set_source(
        (GdkDevice*)a0
        ,(GdkInputSource)a1
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_DevicegetType) {
    GType cres = (GType)gdk_device_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_DevicegetFieldSource) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    GdkInputSource cres = (GdkInputSource)DOgetFieldSource(
        (GdkDevice*)a0
        );
    word res = GdkInputSourcetToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldSource) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkInputSource a1 = GdkInputSourcetFromWord(x1);
    DOsetFieldSource(
        (GdkDevice*)a0
        ,(GdkInputSource)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldNumKeys) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    gint cres = (gint)DOgetFieldNumKeys(
        (GdkDevice*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldNumKeys) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_INT(a1, x1);
    DOsetFieldNumKeys(
        (GdkDevice*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldNumAxes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    gint cres = (gint)DOgetFieldNumAxes(
        (GdkDevice*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldNumAxes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_INT(a1, x1);
    DOsetFieldNumAxes(
        (GdkDevice*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    gchar* cres = (gchar*)DOgetFieldName(
        (GdkDevice*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_CSTRING(a1, x1);
    DOsetFieldName(
        (GdkDevice*)a0
        ,(gchar*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldMode) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    GdkInputMode cres = (GdkInputMode)DOgetFieldMode(
        (GdkDevice*)a0
        );
    word res = GdkInputModetToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldMode) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkInputMode a1 = GdkInputModetFromWord(x1);
    DOsetFieldMode(
        (GdkDevice*)a0
        ,(GdkInputMode)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldKeys) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    GdkDeviceKey* cres = (GdkDeviceKey*)DOgetFieldKeys(
        (GdkDevice*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldKeys) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_OBJECT (a1, x1);
    DOsetFieldKeys(
        (GdkDevice*)a0
        ,(GdkDeviceKey*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldHasCursor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    gboolean cres = (gboolean)DOgetFieldHasCursor(
        (GdkDevice*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldHasCursor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_BOOL(a1, x1);
    DOsetFieldHasCursor(
        (GdkDevice*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_DevicegetFieldAxes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    GdkDeviceAxis* cres = (GdkDeviceAxis*)DOgetFieldAxes(
        (GdkDevice*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE2(Gdk_DevicesetFieldAxes) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DEVICE);
    DECLARE_OBJECT (a1, x1);
    DOsetFieldAxes(
        (GdkDevice*)a0
        ,(GdkDeviceAxis*)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldAxes
#undef DOsetFieldAxes
#undef DOgetFieldHasCursor
#undef DOsetFieldHasCursor
#undef DOgetFieldKeys
#undef DOsetFieldKeys
#undef DOgetFieldMode
#undef DOsetFieldMode
#undef DOgetFieldName
#undef DOsetFieldName
#undef DOgetFieldNumAxes
#undef DOsetFieldNumAxes
#undef DOgetFieldNumKeys
#undef DOsetFieldNumKeys
#undef DOgetFieldSource
#undef DOsetFieldSource
DEFINE2(Gdk_Colormapnew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_VISUAL);
    DECLARE_BOOL(a1, x1);
    GdkColormap* cres = (GdkColormap*)gdk_colormap_new(
        (GdkVisual*)a0
        ,(gboolean)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Gdk_Colormapchange) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gint cres = (gint)gdk_color_change(
        (GdkColormap*)a0
        ,(GdkColor*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_Colormapalloc) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gint cres = (gint)gdk_color_alloc(
        (GdkColormap*)a0
        ,(GdkColor*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_Colormapblack) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gint cres = (gint)gdk_color_black(
        (GdkColormap*)a0
        ,(GdkColor*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_Colormapwhite) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    gint cres = (gint)gdk_color_white(
        (GdkColormap*)a0
        ,(GdkColor*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_ColormapgetScreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    GdkScreen* cres = (GdkScreen*)gdk_colormap_get_screen(
        (GdkColormap*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_ColormapgetVisual) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    GdkVisual* cres = (GdkVisual*)gdk_colormap_get_visual(
        (GdkColormap*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Gdk_ColormapqueryColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    DECLARE_INT(a1, x1);
    DECLARE_OBJECT_OF_TYPE(a2, x2, GDK_TYPE_COLOR);
    gdk_colormap_query_color(
        (GdkColormap*)a0
        ,(gulong)a1
        ,(GdkColor*)a2
        );
    RETURN_UNIT;
} END
DEFINE4(Gdk_ColormapallocColor) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_COLORMAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_COLOR);
    DECLARE_BOOL(a2, x2);
    DECLARE_BOOL(a3, x3);
    gboolean cres = (gboolean)gdk_colormap_alloc_color(
        (GdkColormap*)a0
        ,(GdkColor*)a1
        ,(gboolean)a2
        ,(gboolean)a3
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_ColormapgetSystem) {
    GdkColormap* cres = (GdkColormap*)gdk_colormap_get_system(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_ColormapgetType) {
    GType cres = (GType)gdk_colormap_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_PointerisGrabbed) {
    gboolean cres = (gboolean)gdk_pointer_is_grabbed(
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_Pointerungrab) {
    DECLARE_INT(a0, x0);
    gdk_pointer_ungrab(
        (guint32)a0
        );
    RETURN_UNIT;
} END
DEFINE6(Gdk_Pointergrab) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x2, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x2);}
});
GdkEventMask a2 = GdkEventMasktFromWord(x2);
    DECLARE_OBJECT_OF_TYPE(a3, x3, GDK_TYPE_WINDOW);
    DECLARE_OBJECT_OF_TYPE(a4, x4, GDK_TYPE_CURSOR);
    DECLARE_INT(a5, x5);
    GdkGrabStatus cres = (GdkGrabStatus)gdk_pointer_grab(
        (GdkWindow*)a0
        ,(gboolean)a1
        ,(GdkEventMask)a2
        ,(GdkWindow*)a3
        ,(GdkCursor*)a4
        ,(guint32)a5
        );
    word res = GdkGrabStatustToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_KeyvaltoUnicode) {
    DECLARE_INT(a0, x0);
    guint32 cres = (guint32)gdk_keyval_to_unicode(
        (guint)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_KeyvalisLower) {
    DECLARE_INT(a0, x0);
    gboolean cres = (gboolean)gdk_keyval_is_lower(
        (guint)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_KeyvalisUpper) {
    DECLARE_INT(a0, x0);
    gboolean cres = (gboolean)gdk_keyval_is_upper(
        (guint)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_KeyvaltoLower) {
    DECLARE_INT(a0, x0);
    guint cres = (guint)gdk_keyval_to_lower(
        (guint)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_KeyvaltoUpper) {
    DECLARE_INT(a0, x0);
    guint cres = (guint)gdk_keyval_to_upper(
        (guint)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Gdk_KeyvalconvertCase) {
    DECLARE_INT(a0, x0);
    DECLARE_INT_AS(guint, tmp0, x1);
               int* a1 = (int*)&tmp0;
    DECLARE_INT_AS(guint, tmp1, x2);
               int* a2 = (int*)&tmp1;
    gdk_keyval_convert_case(
        (guint)a0
        ,(guint*)a1
        ,(guint*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE1(Gdk_KeyvalfromName) {
    DECLARE_CSTRING(a0, x0);
    guint cres = (guint)gdk_keyval_from_name(
        (const gchar*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_Keyvalname) {
    DECLARE_INT(a0, x0);
    gchar* cres = (gchar*)gdk_keyval_name(
        (guint)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Gdk_Listvisuals) {
    GList* cres = (GList*)gdk_list_visuals(
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_UnicodetoKeyval) {
    DECLARE_INT(a0, x0);
    guint cres = (guint)gdk_unicode_to_keyval(
        (guint32)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE7(Gdk_DrawlayoutWithColors) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_OBJECT_OF_TYPE(a4, x4, PANGO_TYPE_LAYOUT);
    DECLARE_OBJECT_OF_TYPE(a5, x5, GDK_TYPE_COLOR);
    DECLARE_OBJECT_OF_TYPE(a6, x6, GDK_TYPE_COLOR);
    gdk_draw_layout_with_colors(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(PangoLayout*)a4
        ,(GdkColor*)a5
        ,(GdkColor*)a6
        );
    RETURN_UNIT;
} END
DEFINE7(Gdk_DrawlayoutLineWithColors) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DRAWABLE);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_GC);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_OBJECT(a4, x4);
    DECLARE_OBJECT_OF_TYPE(a5, x5, GDK_TYPE_COLOR);
    DECLARE_OBJECT_OF_TYPE(a6, x6, GDK_TYPE_COLOR);
    gdk_draw_layout_line_with_colors(
        (GdkDrawable*)a0
        ,(GdkGC*)a1
        ,(gint)a2
        ,(gint)a3
        ,(PangoLayoutLine*)a4
        ,(GdkColor*)a5
        ,(GdkColor*)a6
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_Deviceslist) {
    GList* cres = (GList*)gdk_devices_list(
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_Fontsetload) {
    DECLARE_CSTRING(a0, x0);
    GdkFont* cres = (GdkFont*)gdk_fontset_load(
        (const gchar*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_FONT);
    RETURN1(res);
} END
DEFINE2(Gdk_FontsetloadForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_CSTRING(a1, x1);
    GdkFont* cres = (GdkFont*)gdk_fontset_load_for_display(
        (GdkDisplay*)a0
        ,(const gchar*)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, GDK_TYPE_FONT);
    RETURN1(res);
} END
DEFINE0(Gdk_Eventspending) {
    gboolean cres = (gboolean)gdk_events_pending(
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_RgbgetVisual) {
    GdkVisual* cres = (GdkVisual*)gdk_rgb_get_visual(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_RgbgetCmap) {
    GdkColormap* cres = (GdkColormap*)gdk_rgb_get_cmap(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_RgbgetColormap) {
    GdkColormap* cres = (GdkColormap*)gdk_rgb_get_colormap(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Gdk_RgbsetMinColors) {
    DECLARE_INT(a0, x0);
    gdk_rgb_set_min_colors(
        (gint)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_RgbsetInstall) {
    DECLARE_BOOL(a0, x0);
    gdk_rgb_set_install(
        (gboolean)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_RgbsetVerbose) {
    DECLARE_BOOL(a0, x0);
    gdk_rgb_set_verbose(
        (gboolean)a0
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_Rgbditherable) {
    gboolean cres = (gboolean)gdk_rgb_ditherable(
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_RgbgcSetBackground) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_INT(a1, x1);
    gdk_rgb_gc_set_background(
        (GdkGC*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_RgbgcSetForeground) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_GC);
    DECLARE_INT(a1, x1);
    gdk_rgb_gc_set_foreground(
        (GdkGC*)a0
        ,(guint32)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_RgbxpixelFromRgb) {
    DECLARE_INT(a0, x0);
    gulong cres = (gulong)gdk_rgb_xpixel_from_rgb(
        (guint32)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Gdk_Threadsinit) {
    gdk_threads_init(
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_Threadsleave) {
    gdk_threads_leave(
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_Threadsenter) {
    gdk_threads_enter(
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_QueryvisualTypes) {
    DECLARE_OBJECT (a0, x0);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    gdk_query_visual_types(
        (GdkVisualType**)a0
        ,(gint*)a1
        );
    word r1 = Store::IntToWord(*a1);
    RETURN1(r1);
} END
DEFINE2(Gdk_Querydepths) {
    DECLARE_OBJECT (a0, x0);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    gdk_query_depths(
        (gint**)a0
        ,(gint*)a1
        );
    word r1 = Store::IntToWord(*a1);
    RETURN1(r1);
} END
DEFINE3(Gdk_DraggetProtocolForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
GdkDragProtocol tmp0 = GdkDragProtocoltFromWord(x2);GdkDragProtocol *a2 = &tmp0;
    guint32 cres = (guint32)gdk_drag_get_protocol_for_display(
        (GdkDisplay*)a0
        ,(guint32)a1
        ,(GdkDragProtocol*)a2
        );
    word res = Store::IntToWord(cres);
    word r2 = GdkDragProtocoltToWord(*a2);
    RETURN2(res,r2);
} END
DEFINE2(Gdk_DraggetProtocol) {
    DECLARE_INT(a0, x0);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
GdkDragProtocol tmp0 = GdkDragProtocoltFromWord(x1);GdkDragProtocol *a1 = &tmp0;
    guint32 cres = (guint32)gdk_drag_get_protocol(
        (guint32)a0
        ,(GdkDragProtocol*)a1
        );
    word res = Store::IntToWord(cres);
    word r1 = GdkDragProtocoltToWord(*a1);
    RETURN2(res,r1);
} END
DEFINE1(Gdk_Keyboardungrab) {
    DECLARE_INT(a0, x0);
    gdk_keyboard_ungrab(
        (guint32)a0
        );
    RETURN_UNIT;
} END
DEFINE3(Gdk_Keyboardgrab) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_BOOL(a1, x1);
    DECLARE_INT(a2, x2);
    GdkGrabStatus cres = (GdkGrabStatus)gdk_keyboard_grab(
        (GdkWindow*)a0
        ,(gboolean)a1
        ,(guint32)a2
        );
    word res = GdkGrabStatustToWord(cres);
    RETURN1(res);
} END
DEFINE2(Gdk_Atomintern) {
    DECLARE_CSTRING(a0, x0);
    DECLARE_BOOL(a1, x1);
    GdkAtom cres = (GdkAtom)gdk_atom_intern(
        (gchar*)a0
        ,(gboolean)a1
        );
    word res = Word32ToWord ((u_int)cres);
    RETURN1(res);
} END
DEFINE1(Gdk_Settingget) {
    DECLARE_CSTRING(a0, x0);
    GValue* a1 = new GValue; memset(a1, 0, sizeof(GValue));
    gboolean cres = (gboolean)gdk_setting_get(
        (const gchar*)a0
        ,(GValue*)a1
        );
    word res = BOOL_TO_WORD(cres);
    word r1 = OBJECT_TO_WORD (a1, TYPE_BOXED | FLAG_OWN, G_TYPE_VALUE);
    RETURN2(res,r1);
} END
DEFINE1(Gdk_SetpointerHooks) {
    DECLARE_OBJECT (a0, x0);
    GdkPointerHooks* cres = (GdkPointerHooks*)gdk_set_pointer_hooks(
        (const GdkPointerHooks*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE1(Gdk_SetsmClientId) {
    DECLARE_CSTRING(a0, x0);
    gdk_set_sm_client_id(
        (const gchar*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_SetshowEvents) {
    DECLARE_BOOL(a0, x0);
    gdk_set_show_events(
        (gboolean)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Gdk_SetdoubleClickTime) {
    DECLARE_INT(a0, x0);
    gdk_set_double_click_time(
        (guint)a0
        );
    RETURN_UNIT;
} END
DEFINE0(Gdk_GetdefaultRootWindow) {
    GdkWindow* cres = (GdkWindow*)gdk_get_default_root_window(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Gdk_GetshowEvents) {
    gboolean cres = (gboolean)gdk_get_show_events(
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE6(Gdk_SelectionsendNotifyForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_INT(a1, x1);
    DECLARE_WORD32(tmp0, x2); GdkAtom a2 = (GdkAtom)tmp0;
    DECLARE_WORD32(tmp1, x3); GdkAtom a3 = (GdkAtom)tmp1;
    DECLARE_WORD32(tmp2, x4); GdkAtom a4 = (GdkAtom)tmp2;
    DECLARE_INT(a5, x5);
    gdk_selection_send_notify_for_display(
        (GdkDisplay*)a0
        ,(guint32)a1
        ,(GdkAtom)a2
        ,(GdkAtom)a3
        ,(GdkAtom)a4
        ,(guint32)a5
        );
    RETURN_UNIT;
} END
DEFINE5(Gdk_SelectionsendNotify) {
    DECLARE_INT(a0, x0);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    DECLARE_WORD32(tmp1, x2); GdkAtom a2 = (GdkAtom)tmp1;
    DECLARE_WORD32(tmp2, x3); GdkAtom a3 = (GdkAtom)tmp2;
    DECLARE_INT(a4, x4);
    gdk_selection_send_notify(
        (guint32)a0
        ,(GdkAtom)a1
        ,(GdkAtom)a2
        ,(GdkAtom)a3
        ,(guint32)a4
        );
    RETURN_UNIT;
} END
DEFINE2(Gdk_SelectionownerGetForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    GdkWindow* cres = (GdkWindow*)gdk_selection_owner_get_for_display(
        (GdkDisplay*)a0
        ,(GdkAtom)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE5(Gdk_SelectionownerSetForDisplay) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_DISPLAY);
    DECLARE_OBJECT_OF_TYPE(a1, x1, GDK_TYPE_WINDOW);
    DECLARE_WORD32(tmp0, x2); GdkAtom a2 = (GdkAtom)tmp0;
    DECLARE_INT(a3, x3);
    DECLARE_BOOL(a4, x4);
    gboolean cres = (gboolean)gdk_selection_owner_set_for_display(
        (GdkDisplay*)a0
        ,(GdkWindow*)a1
        ,(GdkAtom)a2
        ,(guint32)a3
        ,(gboolean)a4
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Gdk_SelectionownerGet) {
    DECLARE_WORD32(tmp0, x0); GdkAtom a0 = (GdkAtom)tmp0;
    GdkWindow* cres = (GdkWindow*)gdk_selection_owner_get(
        (GdkAtom)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE4(Gdk_SelectionownerSet) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, GDK_TYPE_WINDOW);
    DECLARE_WORD32(tmp0, x1); GdkAtom a1 = (GdkAtom)tmp0;
    DECLARE_INT(a2, x2);
    DECLARE_BOOL(a3, x3);
    gboolean cres = (gboolean)gdk_selection_owner_set(
        (GdkWindow*)a0
        ,(GdkAtom)a1
        ,(guint32)a2
        ,(gboolean)a3
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
word NativeGdk_CreateComponent() {
    Record *record = Record::New ((unsigned)669);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SelectionownerSet",Gdk_SelectionownerSet, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SelectionownerGet",Gdk_SelectionownerGet, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SelectionownerSetForDisplay",Gdk_SelectionownerSetForDisplay, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SelectionownerGetForDisplay",Gdk_SelectionownerGetForDisplay, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SelectionsendNotify",Gdk_SelectionsendNotify, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SelectionsendNotifyForDisplay",Gdk_SelectionsendNotifyForDisplay, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GetshowEvents",Gdk_GetshowEvents, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GetdefaultRootWindow",Gdk_GetdefaultRootWindow, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SetdoubleClickTime",Gdk_SetdoubleClickTime, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SetshowEvents",Gdk_SetshowEvents, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SetsmClientId",Gdk_SetsmClientId, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SetpointerHooks",Gdk_SetpointerHooks, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Settingget",Gdk_Settingget, 1, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Atomintern",Gdk_Atomintern, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Keyboardgrab",Gdk_Keyboardgrab, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Keyboardungrab",Gdk_Keyboardungrab, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DraggetProtocol",Gdk_DraggetProtocol, 2, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DraggetProtocolForDisplay",Gdk_DraggetProtocolForDisplay, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Querydepths",Gdk_Querydepths, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "QueryvisualTypes",Gdk_QueryvisualTypes, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Threadsenter",Gdk_Threadsenter, 0, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Threadsleave",Gdk_Threadsleave, 0, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Threadsinit",Gdk_Threadsinit, 0, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbxpixelFromRgb",Gdk_RgbxpixelFromRgb, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbgcSetForeground",Gdk_RgbgcSetForeground, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbgcSetBackground",Gdk_RgbgcSetBackground, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Rgbditherable",Gdk_Rgbditherable, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbsetVerbose",Gdk_RgbsetVerbose, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbsetInstall",Gdk_RgbsetInstall, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbsetMinColors",Gdk_RgbsetMinColors, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbgetColormap",Gdk_RgbgetColormap, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbgetCmap",Gdk_RgbgetCmap, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbgetVisual",Gdk_RgbgetVisual, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventspending",Gdk_Eventspending, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontsetloadForDisplay",Gdk_FontsetloadForDisplay, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontsetload",Gdk_Fontsetload, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Deviceslist",Gdk_Deviceslist, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawlayoutLineWithColors",Gdk_DrawlayoutLineWithColors, 7, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawlayoutWithColors",Gdk_DrawlayoutWithColors, 7, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "UnicodetoKeyval",Gdk_UnicodetoKeyval, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Listvisuals",Gdk_Listvisuals, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Keyvalname",Gdk_Keyvalname, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvalfromName",Gdk_KeyvalfromName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvalconvertCase",Gdk_KeyvalconvertCase, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvaltoUpper",Gdk_KeyvaltoUpper, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvaltoLower",Gdk_KeyvaltoLower, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvalisUpper",Gdk_KeyvalisUpper, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvalisLower",Gdk_KeyvalisLower, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeyvaltoUnicode",Gdk_KeyvaltoUnicode, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pointergrab",Gdk_Pointergrab, 6, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pointerungrab",Gdk_Pointerungrab, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PointerisGrabbed",Gdk_PointerisGrabbed, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColormapgetType",Gdk_ColormapgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColormapgetSystem",Gdk_ColormapgetSystem, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColormapallocColor",Gdk_ColormapallocColor, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColormapqueryColor",Gdk_ColormapqueryColor, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColormapgetVisual",Gdk_ColormapgetVisual, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColormapgetScreen",Gdk_ColormapgetScreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colormapwhite",Gdk_Colormapwhite, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colormapblack",Gdk_Colormapblack, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colormapalloc",Gdk_Colormapalloc, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colormapchange",Gdk_Colormapchange, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colormapnew",Gdk_Colormapnew, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldAxes",Gdk_DevicesetFieldAxes, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldAxes",Gdk_DevicegetFieldAxes, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldHasCursor",Gdk_DevicesetFieldHasCursor, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldHasCursor",Gdk_DevicegetFieldHasCursor, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldKeys",Gdk_DevicesetFieldKeys, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldKeys",Gdk_DevicegetFieldKeys, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldMode",Gdk_DevicesetFieldMode, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldMode",Gdk_DevicegetFieldMode, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldName",Gdk_DevicesetFieldName, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldName",Gdk_DevicegetFieldName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldNumAxes",Gdk_DevicesetFieldNumAxes, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldNumAxes",Gdk_DevicegetFieldNumAxes, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldNumKeys",Gdk_DevicesetFieldNumKeys, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldNumKeys",Gdk_DevicegetFieldNumKeys, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetFieldSource",Gdk_DevicesetFieldSource, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetFieldSource",Gdk_DevicegetFieldSource, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetType",Gdk_DevicegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetSource",Gdk_DevicesetSource, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetMode",Gdk_DevicesetMode, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetKey",Gdk_DevicesetKey, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicesetAxisUse",Gdk_DevicesetAxisUse, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetState",Gdk_DevicegetState, 4, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetAxis",Gdk_DevicegetAxis, 4, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DevicegetCorePointer",Gdk_DevicegetCorePointer, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Devicenew",Gdk_Devicenew, 8, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetType",Gdk_DisplaygetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetName",Gdk_DisplaygetName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetNScreens",Gdk_DisplaygetNScreens, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetScreen",Gdk_DisplaygetScreen, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetDefaultScreen",Gdk_DisplaygetDefaultScreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaypointerUngrab",Gdk_DisplaypointerUngrab, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaykeyboardUngrab",Gdk_DisplaykeyboardUngrab, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaypointerIsGrabbed",Gdk_DisplaypointerIsGrabbed, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Displaybeep",Gdk_Displaybeep, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Displaysync",Gdk_Displaysync, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Displayclose",Gdk_Displayclose, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetEvent",Gdk_DisplaygetEvent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaypeekEvent",Gdk_DisplaypeekEvent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayputEvent",Gdk_DisplayputEvent, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaysetDoubleClickTime",Gdk_DisplaysetDoubleClickTime, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetDefault",Gdk_DisplaygetDefault, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetCorePointer",Gdk_DisplaygetCorePointer, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetWindowAtPointer",Gdk_DisplaygetWindowAtPointer, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayopenDefaultLibgtkOnly",Gdk_DisplayopenDefaultLibgtkOnly, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaysupportsSelectionNotification",Gdk_DisplaysupportsSelectionNotification, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayrequestSelectionNotification",Gdk_DisplayrequestSelectionNotification, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaysupportsClipboardPersistence",Gdk_DisplaysupportsClipboardPersistence, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaystoreClipboard",Gdk_DisplaystoreClipboard, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Displayflush",Gdk_Displayflush, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaysetDoubleClickDistance",Gdk_DisplaysetDoubleClickDistance, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaysupportsCursorAlpha",Gdk_DisplaysupportsCursorAlpha, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaysupportsCursorColor",Gdk_DisplaysupportsCursorColor, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetDefaultCursorSize",Gdk_DisplaygetDefaultCursorSize, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetMaximalCursorSize",Gdk_DisplaygetMaximalCursorSize, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplaygetDefaultGroup",Gdk_DisplaygetDefaultGroup, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayopenDisplay",Gdk_DisplayopenDisplay, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayManagergetType",Gdk_DisplayManagergetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayManagerget",Gdk_DisplayManagerget, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayManagergetDefaultDisplay",Gdk_DisplayManagergetDefaultDisplay, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayManagersetDefaultDisplay",Gdk_DisplayManagersetDefaultDisplay, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DisplayManagerlistDisplays",Gdk_DisplayManagerlistDisplays, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldAction",Gdk_DragContextsetFieldAction, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldAction",Gdk_DragContextgetFieldAction, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldActions",Gdk_DragContextsetFieldActions, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldActions",Gdk_DragContextgetFieldActions, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldDestWindow",Gdk_DragContextsetFieldDestWindow, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldDestWindow",Gdk_DragContextgetFieldDestWindow, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldIsSource",Gdk_DragContextsetFieldIsSource, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldIsSource",Gdk_DragContextgetFieldIsSource, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldProtocol",Gdk_DragContextsetFieldProtocol, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldProtocol",Gdk_DragContextgetFieldProtocol, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldSourceWindow",Gdk_DragContextsetFieldSourceWindow, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldSourceWindow",Gdk_DragContextgetFieldSourceWindow, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldStartTime",Gdk_DragContextsetFieldStartTime, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldStartTime",Gdk_DragContextgetFieldStartTime, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldSuggestedAction",Gdk_DragContextsetFieldSuggestedAction, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldSuggestedAction",Gdk_DragContextgetFieldSuggestedAction, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetFieldTargets",Gdk_DragContextsetFieldTargets, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetFieldTargets",Gdk_DragContextgetFieldTargets, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetType",Gdk_DragContextgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextreference",Gdk_DragContextreference, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextunref",Gdk_DragContextunref, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragStatus",Gdk_DragContextdragStatus, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdropReply",Gdk_DragContextdropReply, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdropFinish",Gdk_DragContextdropFinish, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragGetSelection",Gdk_DragContextdragGetSelection, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragFindWindow",Gdk_DragContextdragFindWindow, 5, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragFindWindowForScreen",Gdk_DragContextdragFindWindowForScreen, 6, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragMotion",Gdk_DragContextdragMotion, 8, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragDrop",Gdk_DragContextdragDrop, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragAbort",Gdk_DragContextdragAbort, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextdragDropSucceeded",Gdk_DragContextdragDropSucceeded, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextfinish",Gdk_DragContextfinish, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextgetSourceWidget",Gdk_DragContextgetSourceWidget, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetIconWidget",Gdk_DragContextsetIconWidget, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetIconPixmap",Gdk_DragContextsetIconPixmap, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetIconPixbuf",Gdk_DragContextsetIconPixbuf, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetIconStock",Gdk_DragContextsetIconStock, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextsetIconDefault",Gdk_DragContextsetIconDefault, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragContextnew",Gdk_DragContextnew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetType",Gdk_DrawablegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablesetData",Gdk_DrawablesetData, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetData",Gdk_DrawablegetData, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetSize",Gdk_DrawablegetSize, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablesetColormap",Gdk_DrawablesetColormap, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetColormap",Gdk_DrawablegetColormap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetVisual",Gdk_DrawablegetVisual, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetDepth",Gdk_DrawablegetDepth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetScreen",Gdk_DrawablegetScreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetDisplay",Gdk_DrawablegetDisplay, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Drawablereference",Gdk_Drawablereference, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Drawableunref",Gdk_Drawableunref, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawPoint",Gdk_DrawabledrawPoint, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawLine",Gdk_DrawabledrawLine, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawRectangle",Gdk_DrawabledrawRectangle, 7, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawArc",Gdk_DrawabledrawArc, 9, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawPolygon",Gdk_DrawabledrawPolygon, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawString",Gdk_DrawabledrawString, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawText",Gdk_DrawabledrawText, 7, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawDrawable",Gdk_DrawabledrawDrawable, 9, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawImage",Gdk_DrawabledrawImage, 9, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawPoints",Gdk_DrawabledrawPoints, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawLines",Gdk_DrawabledrawLines, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawPixbuf",Gdk_DrawabledrawPixbuf, 12, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawGlyphs",Gdk_DrawabledrawGlyphs, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawLayoutLine",Gdk_DrawabledrawLayoutLine, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawLayout",Gdk_DrawabledrawLayout, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetImage",Gdk_DrawablegetImage, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetClipRegion",Gdk_DrawablegetClipRegion, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawablegetVisibleRegion",Gdk_DrawablegetVisibleRegion, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawableimageGet",Gdk_DrawableimageGet, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawRgbImage",Gdk_DrawabledrawRgbImage, 9, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawRgbImageDithalign",Gdk_DrawabledrawRgbImageDithalign, 11, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawRgb32Image",Gdk_DrawabledrawRgb32Image, 9, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DrawabledrawGrayImage",Gdk_DrawabledrawGrayImage, 9, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowdragBegin",Gdk_WindowdragBegin, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowinputSetExtensionEvents",Gdk_WindowinputSetExtensionEvents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowpropertyChange",Gdk_WindowpropertyChange, 7, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowpropertyDelete",Gdk_WindowpropertyDelete, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowselectionConvert",Gdk_WindowselectionConvert, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowobjectGetType",Gdk_WindowobjectGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetKeepAbove",Gdk_WindowsetKeepAbove, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetKeepBelow",Gdk_WindowsetKeepBelow, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowdestroy",Gdk_Windowdestroy, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetWindowType",Gdk_WindowgetWindowType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowatPointer",Gdk_WindowatPointer, 2, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowshow",Gdk_Windowshow, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowhide",Gdk_Windowhide, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowwithdraw",Gdk_Windowwithdraw, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowmove",Gdk_Windowmove, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowresize",Gdk_Windowresize, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowmoveResize",Gdk_WindowmoveResize, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowreparent",Gdk_Windowreparent, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowclear",Gdk_Windowclear, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowclearArea",Gdk_WindowclearArea, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowclearAreaE",Gdk_WindowclearAreaE, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowraiseWindow",Gdk_WindowraiseWindow, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowlowerWindow",Gdk_WindowlowerWindow, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowfocus",Gdk_Windowfocus, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetUserData",Gdk_WindowsetUserData, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetOverrideRedirect",Gdk_WindowsetOverrideRedirect, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowscroll",Gdk_Windowscroll, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowshapeCombineMask",Gdk_WindowshapeCombineMask, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetChildShapes",Gdk_WindowsetChildShapes, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowmergeChildShapes",Gdk_WindowmergeChildShapes, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowisVisible",Gdk_WindowisVisible, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowisViewable",Gdk_WindowisViewable, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetState",Gdk_WindowgetState, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetStaticGravities",Gdk_WindowsetStaticGravities, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetHints",Gdk_WindowsetHints, 8, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetTypeHint",Gdk_WindowsetTypeHint, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetModalHint",Gdk_WindowsetModalHint, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetSkipTaskbarHint",Gdk_WindowsetSkipTaskbarHint, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetSkipPagerHint",Gdk_WindowsetSkipPagerHint, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowbeginPaintRect",Gdk_WindowbeginPaintRect, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowbeginPaintRegion",Gdk_WindowbeginPaintRegion, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowendPaint",Gdk_WindowendPaint, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetTitle",Gdk_WindowsetTitle, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetRole",Gdk_WindowsetRole, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetTransientFor",Gdk_WindowsetTransientFor, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetBackground",Gdk_WindowsetBackground, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetBackPixmap",Gdk_WindowsetBackPixmap, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetCursor",Gdk_WindowsetCursor, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetGeometry",Gdk_WindowgetGeometry, 6, 5);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetPosition",Gdk_WindowgetPosition, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetOrigin",Gdk_WindowgetOrigin, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetDeskrelativeOrigin",Gdk_WindowgetDeskrelativeOrigin, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetRootOrigin",Gdk_WindowgetRootOrigin, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetFrameExtents",Gdk_WindowgetFrameExtents, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetPointer",Gdk_WindowgetPointer, 4, 4);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetParent",Gdk_WindowgetParent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetToplevel",Gdk_WindowgetToplevel, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetChildren",Gdk_WindowgetChildren, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowpeekChildren",Gdk_WindowpeekChildren, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetEvents",Gdk_WindowgetEvents, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetEvents",Gdk_WindowsetEvents, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetIconList",Gdk_WindowsetIconList, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetIcon",Gdk_WindowsetIcon, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetIconName",Gdk_WindowsetIconName, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetGroup",Gdk_WindowsetGroup, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetGroup",Gdk_WindowgetGroup, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetDecorations",Gdk_WindowsetDecorations, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetDecorations",Gdk_WindowgetDecorations, 2, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetToplevels",Gdk_WindowgetToplevels, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowiconify",Gdk_Windowiconify, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowdeiconify",Gdk_Windowdeiconify, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowstick",Gdk_Windowstick, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowunstick",Gdk_Windowunstick, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowmaximize",Gdk_Windowmaximize, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowunmaximize",Gdk_Windowunmaximize, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowfullscreen",Gdk_Windowfullscreen, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Windowunfullscreen",Gdk_Windowunfullscreen, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowregisterDnd",Gdk_WindowregisterDnd, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowbeginResizeDrag",Gdk_WindowbeginResizeDrag, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowbeginMoveDrag",Gdk_WindowbeginMoveDrag, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowinvalidateRect",Gdk_WindowinvalidateRect, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowinvalidateRegion",Gdk_WindowinvalidateRegion, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetUpdateArea",Gdk_WindowgetUpdateArea, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowfreezeUpdates",Gdk_WindowfreezeUpdates, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowthawUpdates",Gdk_WindowthawUpdates, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowprocessAllUpdates",Gdk_WindowprocessAllUpdates, 0, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowprocessUpdates",Gdk_WindowprocessUpdates, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetDebugUpdates",Gdk_WindowsetDebugUpdates, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowgetInternalPaintInfo",Gdk_WindowgetInternalPaintInfo, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetAcceptFocus",Gdk_WindowsetAcceptFocus, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowsetFocusOnMap",Gdk_WindowsetFocusOnMap, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowenableSynchronizedConfigure",Gdk_WindowenableSynchronizedConfigure, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowconfigureFinished",Gdk_WindowconfigureFinished, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixmapgetType",Gdk_PixmapgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixmapcreateFromData",Gdk_PixmapcreateFromData, 7, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixmapcreateFromXpm",Gdk_PixmapcreateFromXpm, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixmapcolormapCreateFromXpm",Gdk_PixmapcolormapCreateFromXpm, 4, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixmapcreateFromXpmD",Gdk_PixmapcreateFromXpmD, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixmapcolormapCreateFromXpmD",Gdk_PixmapcolormapCreateFromXpmD, 4, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixmapnew",Gdk_Pixmapnew, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCgetType",Gdk_GCgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetForeground",Gdk_GCsetForeground, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetBackground",Gdk_GCsetBackground, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetFont",Gdk_GCsetFont, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetFill",Gdk_GCsetFill, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetTile",Gdk_GCsetTile, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetStipple",Gdk_GCsetStipple, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetTsOrigin",Gdk_GCsetTsOrigin, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetClipOrigin",Gdk_GCsetClipOrigin, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetClipMask",Gdk_GCsetClipMask, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetClipRectangle",Gdk_GCsetClipRectangle, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetClipRegion",Gdk_GCsetClipRegion, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetSubwindow",Gdk_GCsetSubwindow, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetExposures",Gdk_GCsetExposures, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetLineAttributes",Gdk_GCsetLineAttributes, 5, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCoffset",Gdk_GCoffset, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCcopy",Gdk_GCcopy, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetColormap",Gdk_GCsetColormap, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCgetColormap",Gdk_GCgetColormap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetRgbFgColor",Gdk_GCsetRgbFgColor, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCsetRgbBgColor",Gdk_GCsetRgbBgColor, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCnew",Gdk_GCnew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImagegetType",Gdk_ImagegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImageputPixel",Gdk_ImageputPixel, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImagegetPixel",Gdk_ImagegetPixel, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImagesetColormap",Gdk_ImagesetColormap, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImagegetColormap",Gdk_ImagegetColormap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Imagenew",Gdk_Imagenew, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeymapgetType",Gdk_KeymapgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeymapgetDefault",Gdk_KeymapgetDefault, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeymapgetForDisplay",Gdk_KeymapgetForDisplay, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeymaptranslateKeyboardState",Gdk_KeymaptranslateKeyboardState, 8, 5);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "KeymapgetDirection",Gdk_KeymapgetDirection, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufrenderToDrawable",Gdk_PixbufrenderToDrawable, 12, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufrenderToDrawableAlpha",Gdk_PixbufrenderToDrawableAlpha, 13, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufrenderPixmapAndMask",Gdk_PixbufrenderPixmapAndMask, 2, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetFromDrawable",Gdk_PixbufgetFromDrawable, 9, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetFromImage",Gdk_PixbufgetFromImage, 9, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetColorspace",Gdk_PixbufgetColorspace, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetNChannels",Gdk_PixbufgetNChannels, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetHasAlpha",Gdk_PixbufgetHasAlpha, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetBitsPerSample",Gdk_PixbufgetBitsPerSample, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetPixels",Gdk_PixbufgetPixels, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetWidth",Gdk_PixbufgetWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetHeight",Gdk_PixbufgetHeight, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetRowstride",Gdk_PixbufgetRowstride, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufcopy",Gdk_Pixbufcopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufnewFromFile",Gdk_PixbufnewFromFile, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufnewFromFileAtSize",Gdk_PixbufnewFromFileAtSize, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufnewFromData",Gdk_PixbufnewFromData, 9, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufnewFromXpmData",Gdk_PixbufnewFromXpmData, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufnewFromInline",Gdk_PixbufnewFromInline, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufsubpixbuf",Gdk_Pixbufsubpixbuf, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbuffill",Gdk_Pixbuffill, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufsave",Gdk_Pixbufsave, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufsavev",Gdk_Pixbufsavev, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufaddAlpha",Gdk_PixbufaddAlpha, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufcopyArea",Gdk_PixbufcopyArea, 8, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufsaturateAndPixelate",Gdk_PixbufsaturateAndPixelate, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufscale",Gdk_Pixbufscale, 11, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufcomposite",Gdk_Pixbufcomposite, 12, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufcompositeColor",Gdk_PixbufcompositeColor, 17, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufscaleSimple",Gdk_PixbufscaleSimple, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufcompositeColorSimple",Gdk_PixbufcompositeColorSimple, 8, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetOption",Gdk_PixbufgetOption, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetFormats",Gdk_PixbufgetFormats, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufgetFileInfo",Gdk_PixbufgetFileInfo, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Pixbufnew",Gdk_Pixbufnew, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationgetType",Gdk_PixbufAnimationgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationgetWidth",Gdk_PixbufAnimationgetWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationgetHeight",Gdk_PixbufAnimationgetHeight, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationisStaticImage",Gdk_PixbufAnimationisStaticImage, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationgetStaticImage",Gdk_PixbufAnimationgetStaticImage, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationgetIter",Gdk_PixbufAnimationgetIter, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationnewFromFile",Gdk_PixbufAnimationnewFromFile, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationItergetType",Gdk_PixbufAnimationItergetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationItergetDelayTime",Gdk_PixbufAnimationItergetDelayTime, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationItergetPixbuf",Gdk_PixbufAnimationItergetPixbuf, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationIteronCurrentlyLoadingFrame",Gdk_PixbufAnimationIteronCurrentlyLoadingFrame, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAnimationIteradvance",Gdk_PixbufAnimationIteradvance, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadergetType",Gdk_PixbufLoadergetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadernew",Gdk_PixbufLoadernew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadernewWithMimeType",Gdk_PixbufLoadernewWithMimeType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoaderwrite",Gdk_PixbufLoaderwrite, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadergetPixbuf",Gdk_PixbufLoadergetPixbuf, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadergetAnimation",Gdk_PixbufLoadergetAnimation, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoaderclose",Gdk_PixbufLoaderclose, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadersetSize",Gdk_PixbufLoadersetSize, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadergetFormat",Gdk_PixbufLoadergetFormat, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufLoadernewWithType",Gdk_PixbufLoadernewWithType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Screenwidth",Gdk_Screenwidth, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Screenheight",Gdk_Screenheight, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreenwidthMm",Gdk_ScreenwidthMm, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreenheightMm",Gdk_ScreenheightMm, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetType",Gdk_ScreengetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetDefaultColormap",Gdk_ScreengetDefaultColormap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreensetDefaultColormap",Gdk_ScreensetDefaultColormap, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetSystemColormap",Gdk_ScreengetSystemColormap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetSystemVisual",Gdk_ScreengetSystemVisual, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetRgbColormap",Gdk_ScreengetRgbColormap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetRgbVisual",Gdk_ScreengetRgbVisual, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetRootWindow",Gdk_ScreengetRootWindow, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetDisplay",Gdk_ScreengetDisplay, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetNumber",Gdk_ScreengetNumber, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetWidth",Gdk_ScreengetWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetHeight",Gdk_ScreengetHeight, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetWidthMm",Gdk_ScreengetWidthMm, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetHeightMm",Gdk_ScreengetHeightMm, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreenlistVisuals",Gdk_ScreenlistVisuals, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetToplevelWindows",Gdk_ScreengetToplevelWindows, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreenmakeDisplayName",Gdk_ScreenmakeDisplayName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetNMonitors",Gdk_ScreengetNMonitors, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetMonitorGeometry",Gdk_ScreengetMonitorGeometry, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetMonitorAtPoint",Gdk_ScreengetMonitorAtPoint, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetMonitorAtWindow",Gdk_ScreengetMonitorAtWindow, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreenbroadcastClientMessage",Gdk_ScreenbroadcastClientMessage, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetDefault",Gdk_ScreengetDefault, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreengetSetting",Gdk_ScreengetSetting, 2, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScreenalternativeDialogButtonOrder",Gdk_ScreenalternativeDialogButtonOrder, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldBitsPerRgb",Gdk_VisualsetFieldBitsPerRgb, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldBitsPerRgb",Gdk_VisualgetFieldBitsPerRgb, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldBlueMask",Gdk_VisualsetFieldBlueMask, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldBlueMask",Gdk_VisualgetFieldBlueMask, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldBluePrec",Gdk_VisualsetFieldBluePrec, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldBluePrec",Gdk_VisualgetFieldBluePrec, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldBlueShift",Gdk_VisualsetFieldBlueShift, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldBlueShift",Gdk_VisualgetFieldBlueShift, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldByteOrder",Gdk_VisualsetFieldByteOrder, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldByteOrder",Gdk_VisualgetFieldByteOrder, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldColormapSize",Gdk_VisualsetFieldColormapSize, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldColormapSize",Gdk_VisualgetFieldColormapSize, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldDepth",Gdk_VisualsetFieldDepth, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldDepth",Gdk_VisualgetFieldDepth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldGreenMask",Gdk_VisualsetFieldGreenMask, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldGreenMask",Gdk_VisualgetFieldGreenMask, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldGreenPrec",Gdk_VisualsetFieldGreenPrec, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldGreenPrec",Gdk_VisualgetFieldGreenPrec, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldGreenShift",Gdk_VisualsetFieldGreenShift, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldGreenShift",Gdk_VisualgetFieldGreenShift, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldRedMask",Gdk_VisualsetFieldRedMask, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldRedMask",Gdk_VisualgetFieldRedMask, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldRedPrec",Gdk_VisualsetFieldRedPrec, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldRedPrec",Gdk_VisualgetFieldRedPrec, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldRedShift",Gdk_VisualsetFieldRedShift, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldRedShift",Gdk_VisualgetFieldRedShift, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualsetFieldType",Gdk_VisualsetFieldType, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetFieldType",Gdk_VisualgetFieldType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetBestDepth",Gdk_VisualgetBestDepth, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetBestType",Gdk_VisualgetBestType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetSystem",Gdk_VisualgetSystem, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetBest",Gdk_VisualgetBest, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetBestWithDepth",Gdk_VisualgetBestWithDepth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetBestWithType",Gdk_VisualgetBestWithType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetScreen",Gdk_VisualgetScreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualgetBestWithBoth",Gdk_VisualgetBestWithBoth, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "BitmapcreateFromData",Gdk_BitmapcreateFromData, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufFormatgetName",Gdk_PixbufFormatgetName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufFormatgetDescription",Gdk_PixbufFormatgetDescription, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufFormatgetMimeTypes",Gdk_PixbufFormatgetMimeTypes, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufFormatgetExtensions",Gdk_PixbufFormatgetExtensions, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufFormatisWritable",Gdk_PixbufFormatisWritable, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetType",Gdk_EventgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventget",Gdk_Eventget, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventpeek",Gdk_Eventpeek, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetGraphicsExpose",Gdk_EventgetGraphicsExpose, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventput",Gdk_Eventput, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventcopy",Gdk_Eventcopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventfree",Gdk_Eventfree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetTime",Gdk_EventgetTime, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetState",Gdk_EventgetState, 2, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetCoords",Gdk_EventgetCoords, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetRootCoords",Gdk_EventgetRootCoords, 3, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetAxis",Gdk_EventgetAxis, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventsetScreen",Gdk_EventsetScreen, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventgetScreen",Gdk_EventgetScreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Eventnew",Gdk_Eventnew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontsetFieldAscent",Gdk_FontsetFieldAscent, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontgetFieldAscent",Gdk_FontgetFieldAscent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontsetFieldDescent",Gdk_FontsetFieldDescent, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontgetFieldDescent",Gdk_FontgetFieldDescent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontsetFieldType",Gdk_FontsetFieldType, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontgetFieldType",Gdk_FontgetFieldType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontid",Gdk_Fontid, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontloadForDisplay",Gdk_FontloadForDisplay, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontfromDescriptionForDisplay",Gdk_FontfromDescriptionForDisplay, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontfromDescription",Gdk_FontfromDescription, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontstringWidth",Gdk_FontstringWidth, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontwidth",Gdk_Fontwidth, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontcharWidth",Gdk_FontcharWidth, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontstringMeasure",Gdk_FontstringMeasure, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontmeasure",Gdk_Fontmeasure, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontcharMeasure",Gdk_FontcharMeasure, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontstringHeight",Gdk_FontstringHeight, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontheight",Gdk_Fontheight, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontcharHeight",Gdk_FontcharHeight, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontextents",Gdk_Fontextents, 8, 5);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontstringExtents",Gdk_FontstringExtents, 7, 5);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Fontload",Gdk_Fontload, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorsetFieldBlue",Gdk_ColorsetFieldBlue, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorgetFieldBlue",Gdk_ColorgetFieldBlue, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorsetFieldGreen",Gdk_ColorsetFieldGreen, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorgetFieldGreen",Gdk_ColorgetFieldGreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorsetFieldRed",Gdk_ColorsetFieldRed, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorgetFieldRed",Gdk_ColorgetFieldRed, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colorparse",Gdk_Colorparse, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Colornew",Gdk_Colornew, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursorsetFieldType",Gdk_CursorsetFieldType, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursorgetFieldType",Gdk_CursorgetFieldType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursorgetDisplay",Gdk_CursorgetDisplay, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Cursornew",Gdk_Cursornew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursornewForDisplay",Gdk_CursornewForDisplay, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursornewFromPixmap",Gdk_CursornewFromPixmap, 6, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursornewFromPixbuf",Gdk_CursornewFromPixbuf, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglesetFieldHeight",Gdk_RectanglesetFieldHeight, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglegetFieldHeight",Gdk_RectanglegetFieldHeight, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglesetFieldWidth",Gdk_RectanglesetFieldWidth, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglegetFieldWidth",Gdk_RectanglegetFieldWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglesetFieldX",Gdk_RectanglesetFieldX, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglegetFieldX",Gdk_RectanglegetFieldX, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglesetFieldY",Gdk_RectanglesetFieldY, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RectanglegetFieldY",Gdk_RectanglegetFieldY, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Rectangleintersect",Gdk_Rectangleintersect, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Rectangleunion",Gdk_Rectangleunion, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "Rectanglenew",Gdk_Rectanglenew, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursorTypeGetType",Gdk_CursorTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursorTypeFromInt",Gdk_CursorTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CursorTypeToInt",Gdk_CursorTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragActionGetType",Gdk_DragActionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragActionFromInt",Gdk_DragActionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragActionToInt",Gdk_DragActionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragProtocolGetType",Gdk_DragProtocolGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragProtocolFromInt",Gdk_DragProtocolFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "DragProtocolToInt",Gdk_DragProtocolToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FilterReturnGetType",Gdk_FilterReturnGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FilterReturnFromInt",Gdk_FilterReturnFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FilterReturnToInt",Gdk_FilterReturnToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventTypeGetType",Gdk_EventTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventTypeFromInt",Gdk_EventTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventTypeToInt",Gdk_EventTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventMaskGetType",Gdk_EventMaskGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventMaskFromInt",Gdk_EventMaskFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "EventMaskToInt",Gdk_EventMaskToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisibilityStateGetType",Gdk_VisibilityStateGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisibilityStateFromInt",Gdk_VisibilityStateFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisibilityStateToInt",Gdk_VisibilityStateToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScrollDirectionGetType",Gdk_ScrollDirectionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScrollDirectionFromInt",Gdk_ScrollDirectionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ScrollDirectionToInt",Gdk_ScrollDirectionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "NotifyTypeGetType",Gdk_NotifyTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "NotifyTypeFromInt",Gdk_NotifyTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "NotifyTypeToInt",Gdk_NotifyTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CrossingModeGetType",Gdk_CrossingModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CrossingModeFromInt",Gdk_CrossingModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CrossingModeToInt",Gdk_CrossingModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PropertyStateGetType",Gdk_PropertyStateGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PropertyStateFromInt",Gdk_PropertyStateFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PropertyStateToInt",Gdk_PropertyStateToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowStateGetType",Gdk_WindowStateGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowStateFromInt",Gdk_WindowStateFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowStateToInt",Gdk_WindowStateToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SettingActionGetType",Gdk_SettingActionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SettingActionFromInt",Gdk_SettingActionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SettingActionToInt",Gdk_SettingActionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontTypeGetType",Gdk_FontTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontTypeFromInt",Gdk_FontTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FontTypeToInt",Gdk_FontTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CapStyleGetType",Gdk_CapStyleGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CapStyleFromInt",Gdk_CapStyleFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "CapStyleToInt",Gdk_CapStyleToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FillGetType",Gdk_FillGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FillFromInt",Gdk_FillFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FillToInt",Gdk_FillToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FunctionGetType",Gdk_FunctionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FunctionFromInt",Gdk_FunctionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FunctionToInt",Gdk_FunctionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "JoinStyleGetType",Gdk_JoinStyleGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "JoinStyleFromInt",Gdk_JoinStyleFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "JoinStyleToInt",Gdk_JoinStyleToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "LineStyleGetType",Gdk_LineStyleGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "LineStyleFromInt",Gdk_LineStyleFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "LineStyleToInt",Gdk_LineStyleToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SubwindowModeGetType",Gdk_SubwindowModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SubwindowModeFromInt",Gdk_SubwindowModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "SubwindowModeToInt",Gdk_SubwindowModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCValuesMaskGetType",Gdk_GCValuesMaskGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCValuesMaskFromInt",Gdk_GCValuesMaskFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GCValuesMaskToInt",Gdk_GCValuesMaskToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImageTypeGetType",Gdk_ImageTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImageTypeFromInt",Gdk_ImageTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ImageTypeToInt",Gdk_ImageTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ExtensionModeGetType",Gdk_ExtensionModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ExtensionModeFromInt",Gdk_ExtensionModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ExtensionModeToInt",Gdk_ExtensionModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputSourceGetType",Gdk_InputSourceGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputSourceFromInt",Gdk_InputSourceFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputSourceToInt",Gdk_InputSourceToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputModeGetType",Gdk_InputModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputModeFromInt",Gdk_InputModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputModeToInt",Gdk_InputModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "AxisUseGetType",Gdk_AxisUseGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "AxisUseFromInt",Gdk_AxisUseFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "AxisUseToInt",Gdk_AxisUseToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PropModeGetType",Gdk_PropModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PropModeFromInt",Gdk_PropModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PropModeToInt",Gdk_PropModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FillRuleGetType",Gdk_FillRuleGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FillRuleFromInt",Gdk_FillRuleFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "FillRuleToInt",Gdk_FillRuleToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "OverlapTypeGetType",Gdk_OverlapTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "OverlapTypeFromInt",Gdk_OverlapTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "OverlapTypeToInt",Gdk_OverlapTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbDitherGetType",Gdk_RgbDitherGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbDitherFromInt",Gdk_RgbDitherFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "RgbDitherToInt",Gdk_RgbDitherToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ByteOrderGetType",Gdk_ByteOrderGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ByteOrderFromInt",Gdk_ByteOrderFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ByteOrderToInt",Gdk_ByteOrderToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ModifierTypeGetType",Gdk_ModifierTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ModifierTypeFromInt",Gdk_ModifierTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ModifierTypeToInt",Gdk_ModifierTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputConditionGetType",Gdk_InputConditionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputConditionFromInt",Gdk_InputConditionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InputConditionToInt",Gdk_InputConditionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "StatusGetType",Gdk_StatusGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "StatusFromInt",Gdk_StatusFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "StatusToInt",Gdk_StatusToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GrabStatusGetType",Gdk_GrabStatusGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GrabStatusFromInt",Gdk_GrabStatusFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GrabStatusToInt",Gdk_GrabStatusToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualTypeGetType",Gdk_VisualTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualTypeFromInt",Gdk_VisualTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "VisualTypeToInt",Gdk_VisualTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowClassGetType",Gdk_WindowClassGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowClassFromInt",Gdk_WindowClassFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowClassToInt",Gdk_WindowClassToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowTypeGetType",Gdk_WindowTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowTypeFromInt",Gdk_WindowTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowTypeToInt",Gdk_WindowTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowAttributesTypeGetType",Gdk_WindowAttributesTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowAttributesTypeFromInt",Gdk_WindowAttributesTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowAttributesTypeToInt",Gdk_WindowAttributesTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowHintsGetType",Gdk_WindowHintsGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowHintsFromInt",Gdk_WindowHintsFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowHintsToInt",Gdk_WindowHintsToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowTypeHintGetType",Gdk_WindowTypeHintGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowTypeHintFromInt",Gdk_WindowTypeHintFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowTypeHintToInt",Gdk_WindowTypeHintToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WMDecorationGetType",Gdk_WMDecorationGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WMDecorationFromInt",Gdk_WMDecorationFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WMDecorationToInt",Gdk_WMDecorationToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WMFunctionGetType",Gdk_WMFunctionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WMFunctionFromInt",Gdk_WMFunctionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WMFunctionToInt",Gdk_WMFunctionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GravityGetType",Gdk_GravityGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GravityFromInt",Gdk_GravityFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "GravityToInt",Gdk_GravityToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowEdgeGetType",Gdk_WindowEdgeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowEdgeFromInt",Gdk_WindowEdgeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "WindowEdgeToInt",Gdk_WindowEdgeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAlphaModeGetType",Gdk_PixbufAlphaModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAlphaModeFromInt",Gdk_PixbufAlphaModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufAlphaModeToInt",Gdk_PixbufAlphaModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorspaceGetType",Gdk_ColorspaceGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorspaceFromInt",Gdk_ColorspaceFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "ColorspaceToInt",Gdk_ColorspaceToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufErrorGetType",Gdk_PixbufErrorGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufErrorFromInt",Gdk_PixbufErrorFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "PixbufErrorToInt",Gdk_PixbufErrorToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InterpTypeGetType",Gdk_InterpTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InterpTypeFromInt",Gdk_InterpTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeGdk", "InterpTypeToInt",Gdk_InterpTypeToInt, 1, 1);
    return record->ToWord ();
}
