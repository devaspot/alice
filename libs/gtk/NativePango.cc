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
word PangoEllipsizeModetToWord(PangoEllipsizeMode v) {
    unsigned r = 0;
        if (v  == PANGO_ELLIPSIZE_END) {
            r = 0;
        } else 
        if (v  == PANGO_ELLIPSIZE_MIDDLE) {
            r = 1;
        } else 
        if (v  == PANGO_ELLIPSIZE_NONE) {
            r = 2;
        } else 
        if (v  == PANGO_ELLIPSIZE_START) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoEllipsizeMode PangoEllipsizeModetFromWord(word w) {
    PangoEllipsizeMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_ELLIPSIZE_END;
            break;
        case 1: r = PANGO_ELLIPSIZE_MIDDLE;
            break;
        case 2: r = PANGO_ELLIPSIZE_NONE;
            break;
        case 3: r = PANGO_ELLIPSIZE_START;
            break;
        default:
            Error ("PangoEllipsizeModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_EllipsizeModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoEllipsizeModetFromWord(x0));
} END
DEFINE1(Pango_EllipsizeModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoEllipsizeModetToWord((PangoEllipsizeMode)i));
} END
DEFINE0(Pango_EllipsizeModeGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_ELLIPSIZE_MODE));
} END
word PangoDirectiontToWord(PangoDirection v) {
    unsigned r = 0;
        if (v  == PANGO_DIRECTION_LTR) {
            r = 0;
        } else 
        if (v  == PANGO_DIRECTION_RTL) {
            r = 1;
        } else 
        if (v  == PANGO_DIRECTION_TTB_LTR) {
            r = 2;
        } else 
        if (v  == PANGO_DIRECTION_TTB_RTL) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoDirection PangoDirectiontFromWord(word w) {
    PangoDirection r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_DIRECTION_LTR;
            break;
        case 1: r = PANGO_DIRECTION_RTL;
            break;
        case 2: r = PANGO_DIRECTION_TTB_LTR;
            break;
        case 3: r = PANGO_DIRECTION_TTB_RTL;
            break;
        default:
            Error ("PangoDirectiontFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_DirectionToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoDirectiontFromWord(x0));
} END
DEFINE1(Pango_DirectionFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoDirectiontToWord((PangoDirection)i));
} END
DEFINE0(Pango_DirectionGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_DIRECTION));
} END
word PangoTabAligntToWord(PangoTabAlign v) {
    unsigned r = 0;
        if (v  == PANGO_TAB_LEFT) {
            r = 0;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoTabAlign PangoTabAligntFromWord(word w) {
    PangoTabAlign r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_TAB_LEFT;
            break;
        default:
            Error ("PangoTabAligntFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_TabAlignToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoTabAligntFromWord(x0));
} END
DEFINE1(Pango_TabAlignFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoTabAligntToWord((PangoTabAlign)i));
} END
DEFINE0(Pango_TabAlignGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_TAB_ALIGN));
} END
word PangoWrapModetToWord(PangoWrapMode v) {
    unsigned r = 0;
        if (v  == PANGO_WRAP_CHAR) {
            r = 0;
        } else 
        if (v  == PANGO_WRAP_WORD) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoWrapMode PangoWrapModetFromWord(word w) {
    PangoWrapMode r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_WRAP_CHAR;
            break;
        case 1: r = PANGO_WRAP_WORD;
            break;
        default:
            Error ("PangoWrapModetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_WrapModeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoWrapModetFromWord(x0));
} END
DEFINE1(Pango_WrapModeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoWrapModetToWord((PangoWrapMode)i));
} END
DEFINE0(Pango_WrapModeGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_WRAP_MODE));
} END
word PangoAlignmenttToWord(PangoAlignment v) {
    unsigned r = 0;
        if (v  == PANGO_ALIGN_CENTER) {
            r = 0;
        } else 
        if (v  == PANGO_ALIGN_LEFT) {
            r = 1;
        } else 
        if (v  == PANGO_ALIGN_RIGHT) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoAlignment PangoAlignmenttFromWord(word w) {
    PangoAlignment r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_ALIGN_CENTER;
            break;
        case 1: r = PANGO_ALIGN_LEFT;
            break;
        case 2: r = PANGO_ALIGN_RIGHT;
            break;
        default:
            Error ("PangoAlignmenttFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_AlignmentToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoAlignmenttFromWord(x0));
} END
DEFINE1(Pango_AlignmentFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoAlignmenttToWord((PangoAlignment)i));
} END
DEFINE0(Pango_AlignmentGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_ALIGNMENT));
} END
word PangoFontMasktToWord(PangoFontMask v) {
    word w = Store::IntToWord(Types::nil);
        if ((v & PANGO_FONT_MASK_FAMILY) == PANGO_FONT_MASK_FAMILY) {
            w = alice_cons (Store::IntToWord (0), w);
        }
        if ((v & PANGO_FONT_MASK_SIZE) == PANGO_FONT_MASK_SIZE) {
            w = alice_cons (Store::IntToWord (1), w);
        }
        if ((v & PANGO_FONT_MASK_STRETCH) == PANGO_FONT_MASK_STRETCH) {
            w = alice_cons (Store::IntToWord (2), w);
        }
        if ((v & PANGO_FONT_MASK_STYLE) == PANGO_FONT_MASK_STYLE) {
            w = alice_cons (Store::IntToWord (3), w);
        }
        if ((v & PANGO_FONT_MASK_VARIANT) == PANGO_FONT_MASK_VARIANT) {
            w = alice_cons (Store::IntToWord (4), w);
        }
        if ((v & PANGO_FONT_MASK_WEIGHT) == PANGO_FONT_MASK_WEIGHT) {
            w = alice_cons (Store::IntToWord (5), w);
        }
    return w;
}
PangoFontMask PangoFontMasktFromWord(word w) {
    unsigned r = 0;
    TagVal *tv;
    while ((tv = TagVal::FromWord(w)) != INVALID_POINTER) {
        Assert(tv->GetTag () == Types::cons);
        switch (Store::WordToInt (tv->Sel (0))) {
            case 0: r |= PANGO_FONT_MASK_FAMILY;
                break;
            case 1: r |= PANGO_FONT_MASK_SIZE;
                break;
            case 2: r |= PANGO_FONT_MASK_STRETCH;
                break;
            case 3: r |= PANGO_FONT_MASK_STYLE;
                break;
            case 4: r |= PANGO_FONT_MASK_VARIANT;
                break;
            case 5: r |= PANGO_FONT_MASK_WEIGHT;
                break;
            default:
                Error ("PangoFontMasktFromWord: invalid enum");
            break;
        }
        w = tv->Sel (1);
    }
    return (PangoFontMask)r;
}
DEFINE1(Pango_FontMaskToInt) {
    DECLARE_LIST_ELEMS(l, len, x0, { if (Store::WordToInt (l->Sel(0)) == INVALID_INT) { REQUEST(x0); }});
    RETURN_INT(PangoFontMasktFromWord(x0));
} END
DEFINE1(Pango_FontMaskFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoFontMasktToWord((PangoFontMask)i));
} END
DEFINE0(Pango_FontMaskGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_FONT_MASK));
} END
word PangoStretchtToWord(PangoStretch v) {
    unsigned r = 0;
        if (v  == PANGO_STRETCH_CONDENSED) {
            r = 0;
        } else 
        if (v  == PANGO_STRETCH_EXPANDED) {
            r = 1;
        } else 
        if (v  == PANGO_STRETCH_EXTRA_CONDENSED) {
            r = 2;
        } else 
        if (v  == PANGO_STRETCH_EXTRA_EXPANDED) {
            r = 3;
        } else 
        if (v  == PANGO_STRETCH_NORMAL) {
            r = 4;
        } else 
        if (v  == PANGO_STRETCH_SEMI_CONDENSED) {
            r = 5;
        } else 
        if (v  == PANGO_STRETCH_SEMI_EXPANDED) {
            r = 6;
        } else 
        if (v  == PANGO_STRETCH_ULTRA_CONDENSED) {
            r = 7;
        } else 
        if (v  == PANGO_STRETCH_ULTRA_EXPANDED) {
            r = 8;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoStretch PangoStretchtFromWord(word w) {
    PangoStretch r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_STRETCH_CONDENSED;
            break;
        case 1: r = PANGO_STRETCH_EXPANDED;
            break;
        case 2: r = PANGO_STRETCH_EXTRA_CONDENSED;
            break;
        case 3: r = PANGO_STRETCH_EXTRA_EXPANDED;
            break;
        case 4: r = PANGO_STRETCH_NORMAL;
            break;
        case 5: r = PANGO_STRETCH_SEMI_CONDENSED;
            break;
        case 6: r = PANGO_STRETCH_SEMI_EXPANDED;
            break;
        case 7: r = PANGO_STRETCH_ULTRA_CONDENSED;
            break;
        case 8: r = PANGO_STRETCH_ULTRA_EXPANDED;
            break;
        default:
            Error ("PangoStretchtFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_StretchToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoStretchtFromWord(x0));
} END
DEFINE1(Pango_StretchFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoStretchtToWord((PangoStretch)i));
} END
DEFINE0(Pango_StretchGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_STRETCH));
} END
word PangoWeighttToWord(PangoWeight v) {
    unsigned r = 0;
        if (v  == PANGO_WEIGHT_BOLD) {
            r = 0;
        } else 
        if (v  == PANGO_WEIGHT_HEAVY) {
            r = 1;
        } else 
        if (v  == PANGO_WEIGHT_LIGHT) {
            r = 2;
        } else 
        if (v  == PANGO_WEIGHT_NORMAL) {
            r = 3;
        } else 
        if (v  == PANGO_WEIGHT_ULTRABOLD) {
            r = 4;
        } else 
        if (v  == PANGO_WEIGHT_ULTRALIGHT) {
            r = 5;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoWeight PangoWeighttFromWord(word w) {
    PangoWeight r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_WEIGHT_BOLD;
            break;
        case 1: r = PANGO_WEIGHT_HEAVY;
            break;
        case 2: r = PANGO_WEIGHT_LIGHT;
            break;
        case 3: r = PANGO_WEIGHT_NORMAL;
            break;
        case 4: r = PANGO_WEIGHT_ULTRABOLD;
            break;
        case 5: r = PANGO_WEIGHT_ULTRALIGHT;
            break;
        default:
            Error ("PangoWeighttFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_WeightToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoWeighttFromWord(x0));
} END
DEFINE1(Pango_WeightFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoWeighttToWord((PangoWeight)i));
} END
DEFINE0(Pango_WeightGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_WEIGHT));
} END
word PangoVarianttToWord(PangoVariant v) {
    unsigned r = 0;
        if (v  == PANGO_VARIANT_NORMAL) {
            r = 0;
        } else 
        if (v  == PANGO_VARIANT_SMALL_CAPS) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoVariant PangoVarianttFromWord(word w) {
    PangoVariant r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_VARIANT_NORMAL;
            break;
        case 1: r = PANGO_VARIANT_SMALL_CAPS;
            break;
        default:
            Error ("PangoVarianttFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_VariantToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoVarianttFromWord(x0));
} END
DEFINE1(Pango_VariantFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoVarianttToWord((PangoVariant)i));
} END
DEFINE0(Pango_VariantGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_VARIANT));
} END
word PangoStyletToWord(PangoStyle v) {
    unsigned r = 0;
        if (v  == PANGO_STYLE_ITALIC) {
            r = 0;
        } else 
        if (v  == PANGO_STYLE_NORMAL) {
            r = 1;
        } else 
        if (v  == PANGO_STYLE_OBLIQUE) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoStyle PangoStyletFromWord(word w) {
    PangoStyle r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_STYLE_ITALIC;
            break;
        case 1: r = PANGO_STYLE_NORMAL;
            break;
        case 2: r = PANGO_STYLE_OBLIQUE;
            break;
        default:
            Error ("PangoStyletFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_StyleToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoStyletFromWord(x0));
} END
DEFINE1(Pango_StyleFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoStyletToWord((PangoStyle)i));
} END
DEFINE0(Pango_StyleGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_STYLE));
} END
word PangoCoverageLeveltToWord(PangoCoverageLevel v) {
    unsigned r = 0;
        if (v  == PANGO_COVERAGE_APPROXIMATE) {
            r = 0;
        } else 
        if (v  == PANGO_COVERAGE_EXACT) {
            r = 1;
        } else 
        if (v  == PANGO_COVERAGE_FALLBACK) {
            r = 2;
        } else 
        if (v  == PANGO_COVERAGE_NONE) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoCoverageLevel PangoCoverageLeveltFromWord(word w) {
    PangoCoverageLevel r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_COVERAGE_APPROXIMATE;
            break;
        case 1: r = PANGO_COVERAGE_EXACT;
            break;
        case 2: r = PANGO_COVERAGE_FALLBACK;
            break;
        case 3: r = PANGO_COVERAGE_NONE;
            break;
        default:
            Error ("PangoCoverageLeveltFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_CoverageLevelToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoCoverageLeveltFromWord(x0));
} END
DEFINE1(Pango_CoverageLevelFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoCoverageLeveltToWord((PangoCoverageLevel)i));
} END
DEFINE0(Pango_CoverageLevelGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_COVERAGE_LEVEL));
} END
word PangoUnderlinetToWord(PangoUnderline v) {
    unsigned r = 0;
        if (v  == PANGO_UNDERLINE_DOUBLE) {
            r = 0;
        } else 
        if (v  == PANGO_UNDERLINE_LOW) {
            r = 1;
        } else 
        if (v  == PANGO_UNDERLINE_NONE) {
            r = 2;
        } else 
        if (v  == PANGO_UNDERLINE_SINGLE) {
            r = 3;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoUnderline PangoUnderlinetFromWord(word w) {
    PangoUnderline r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_UNDERLINE_DOUBLE;
            break;
        case 1: r = PANGO_UNDERLINE_LOW;
            break;
        case 2: r = PANGO_UNDERLINE_NONE;
            break;
        case 3: r = PANGO_UNDERLINE_SINGLE;
            break;
        default:
            Error ("PangoUnderlinetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_UnderlineToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoUnderlinetFromWord(x0));
} END
DEFINE1(Pango_UnderlineFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoUnderlinetToWord((PangoUnderline)i));
} END
DEFINE0(Pango_UnderlineGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_UNDERLINE));
} END
word PangoAttrTypetToWord(PangoAttrType v) {
    unsigned r = 0;
        if (v  == PANGO_ATTR_BACKGROUND) {
            r = 0;
        } else 
        if (v  == PANGO_ATTR_FAMILY) {
            r = 1;
        } else 
        if (v  == PANGO_ATTR_FONT_DESC) {
            r = 2;
        } else 
        if (v  == PANGO_ATTR_FOREGROUND) {
            r = 3;
        } else 
        if (v  == PANGO_ATTR_INVALID) {
            r = 4;
        } else 
        if (v  == PANGO_ATTR_LANGUAGE) {
            r = 5;
        } else 
        if (v  == PANGO_ATTR_RISE) {
            r = 6;
        } else 
        if (v  == PANGO_ATTR_SCALE) {
            r = 7;
        } else 
        if (v  == PANGO_ATTR_SHAPE) {
            r = 8;
        } else 
        if (v  == PANGO_ATTR_SIZE) {
            r = 9;
        } else 
        if (v  == PANGO_ATTR_STRETCH) {
            r = 10;
        } else 
        if (v  == PANGO_ATTR_STRIKETHROUGH) {
            r = 11;
        } else 
        if (v  == PANGO_ATTR_STYLE) {
            r = 12;
        } else 
        if (v  == PANGO_ATTR_UNDERLINE) {
            r = 13;
        } else 
        if (v  == PANGO_ATTR_VARIANT) {
            r = 14;
        } else 
        if (v  == PANGO_ATTR_WEIGHT) {
            r = 15;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
PangoAttrType PangoAttrTypetFromWord(word w) {
    PangoAttrType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = PANGO_ATTR_BACKGROUND;
            break;
        case 1: r = PANGO_ATTR_FAMILY;
            break;
        case 2: r = PANGO_ATTR_FONT_DESC;
            break;
        case 3: r = PANGO_ATTR_FOREGROUND;
            break;
        case 4: r = PANGO_ATTR_INVALID;
            break;
        case 5: r = PANGO_ATTR_LANGUAGE;
            break;
        case 6: r = PANGO_ATTR_RISE;
            break;
        case 7: r = PANGO_ATTR_SCALE;
            break;
        case 8: r = PANGO_ATTR_SHAPE;
            break;
        case 9: r = PANGO_ATTR_SIZE;
            break;
        case 10: r = PANGO_ATTR_STRETCH;
            break;
        case 11: r = PANGO_ATTR_STRIKETHROUGH;
            break;
        case 12: r = PANGO_ATTR_STYLE;
            break;
        case 13: r = PANGO_ATTR_UNDERLINE;
            break;
        case 14: r = PANGO_ATTR_VARIANT;
            break;
        case 15: r = PANGO_ATTR_WEIGHT;
            break;
        default:
            Error ("PangoAttrTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Pango_AttrTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(PangoAttrTypetFromWord(x0));
} END
DEFINE1(Pango_AttrTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(PangoAttrTypetToWord((PangoAttrType)i));
} END
DEFINE0(Pango_AttrTypeGetType) {
    RETURN1(Store::IntToWord(PANGO_TYPE_ATTR_TYPE));
} END
DEFINE4(Pango_TabArraynewWithPositions) {
    DECLARE_INT(a0, x0);
    DECLARE_BOOL(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
PangoTabAlign a2 = PangoTabAligntFromWord(x2);
    DECLARE_INT(a3, x3);
    PangoTabArray* cres = (PangoTabArray*)pango_tab_array_new_with_positions(
        (gint)a0
        ,(gboolean)a1
        ,(PangoTabAlign)a2
        ,(gint)a3
        , NULL
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_TAB_ARRAY);
    RETURN1(res);
} END
DEFINE2(Pango_TabArraynew) {
    DECLARE_INT(a0, x0);
    DECLARE_BOOL(a1, x1);
    PangoTabArray* cres = (PangoTabArray*)pango_tab_array_new(
        (gint)a0
        ,(gboolean)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_TAB_ARRAY);
    RETURN1(res);
} END
DEFINE1(Pango_TabArraygetPositionsInPixels) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    gboolean cres = (gboolean)pango_tab_array_get_positions_in_pixels(
        (PangoTabArray*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE4(Pango_TabArraygetTab) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    DECLARE_INT(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
PangoTabAlign tmp0 = PangoTabAligntFromWord(x2);PangoTabAlign *a2 = &tmp0;
    DECLARE_INT_AS(gint, tmp1, x3);
               gint* a3 = (gint*)&tmp1;
    pango_tab_array_get_tab(
        (PangoTabArray*)a0
        ,(gint)a1
        ,(PangoTabAlign*)a2
        ,(gint*)a3
        );
    word r2 = PangoTabAligntToWord(*a2);
    word r3 = Store::IntToWord(*a3);
    RETURN2(r2,r3);
} END
DEFINE4(Pango_TabArraysetTab) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    DECLARE_INT(a1, x1);
    if (Store::WordToInt(x2) == INVALID_INT) {REQUEST(x2);}
PangoTabAlign a2 = PangoTabAligntFromWord(x2);
    DECLARE_INT(a3, x3);
    pango_tab_array_set_tab(
        (PangoTabArray*)a0
        ,(gint)a1
        ,(PangoTabAlign)a2
        ,(gint)a3
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_TabArrayresize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    DECLARE_INT(a1, x1);
    pango_tab_array_resize(
        (PangoTabArray*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_TabArraygetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    gint cres = (gint)pango_tab_array_get_size(
        (PangoTabArray*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_TabArrayfree) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    pango_tab_array_free(
        (PangoTabArray*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_TabArraycopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_TAB_ARRAY);
    PangoTabArray* cres = (PangoTabArray*)pango_tab_array_copy(
        (PangoTabArray*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_TAB_ARRAY);
    RETURN1(res);
} END
DEFINE0(Pango_TabArraygetType) {
    GType cres = (GType)pango_tab_array_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutItergetBaseline) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    int cres = (int)pango_layout_iter_get_baseline(
        (PangoLayoutIter*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Pango_LayoutItergetLayoutExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_iter_get_layout_extents(
        (PangoLayoutIter*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutItergetLineYrange) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    DECLARE_INT_AS(int, tmp0, x1);
               int* a1 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x2);
               int* a2 = (int*)&tmp1;
    pango_layout_iter_get_line_yrange(
        (PangoLayoutIter*)a0
        ,(int*)a1
        ,(int*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE3(Pango_LayoutItergetLineExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_iter_get_line_extents(
        (PangoLayoutIter*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutItergetRunExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_iter_get_run_extents(
        (PangoLayoutIter*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutItergetClusterExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_iter_get_cluster_extents(
        (PangoLayoutIter*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_LayoutItergetCharExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    DECLARE_OBJECT(a1, x1);
    pango_layout_iter_get_char_extents(
        (PangoLayoutIter*)a0
        ,(PangoRectangle*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutIternextLine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    gboolean cres = (gboolean)pango_layout_iter_next_line(
        (PangoLayoutIter*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutIternextRun) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    gboolean cres = (gboolean)pango_layout_iter_next_run(
        (PangoLayoutIter*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutIternextCluster) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    gboolean cres = (gboolean)pango_layout_iter_next_cluster(
        (PangoLayoutIter*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutIternextChar) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    gboolean cres = (gboolean)pango_layout_iter_next_char(
        (PangoLayoutIter*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutIteratLastLine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    gboolean cres = (gboolean)pango_layout_iter_at_last_line(
        (PangoLayoutIter*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutItergetIndex) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    int cres = (int)pango_layout_iter_get_index(
        (PangoLayoutIter*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutIterfree) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT_ITER);
    pango_layout_iter_free(
        (PangoLayoutIter*)a0
        );
    RETURN_UNIT;
} END
DEFINE0(Pango_LayoutItergetType) {
    GType cres = (GType)pango_layout_iter_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_LanguagefromString) {
    DECLARE_CSTRING(a0, x0);
    PangoLanguage* cres = (PangoLanguage*)pango_language_from_string(
        (const char*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_LANGUAGE);
    RETURN1(res);
} END
DEFINE1(Pango_LanguagetoString) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LANGUAGE);
    const char* cres = (const char*)pango_language_to_string(
        (PangoLanguage*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE2(Pango_Languagematches) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LANGUAGE);
    DECLARE_CSTRING(a1, x1);
    gboolean cres = (gboolean)pango_language_matches(
        (PangoLanguage*)a0
        ,(const char*)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE0(Pango_GlyphStringnew) {
    PangoGlyphString* cres = (PangoGlyphString*)pango_glyph_string_new(
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_GLYPH_STRING);
    RETURN1(res);
} END
#define DOgetFieldGlyphs(O) ((O)->glyphs)
#define DOsetFieldGlyphs(O, V) ((O)->glyphs = (V))
#define DOgetFieldLogClusters(O) ((O)->log_clusters)
#define DOsetFieldLogClusters(O, V) ((O)->log_clusters = (V))
#define DOgetFieldNumGlyphs(O) ((O)->num_glyphs)
#define DOsetFieldNumGlyphs(O, V) ((O)->num_glyphs = (V))
DEFINE5(Pango_GlyphStringgetLogicalWidths) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT_AS(int, tmp0, x4);
               int* a4 = (int*)&tmp0;
    pango_glyph_string_get_logical_widths(
        (PangoGlyphString*)a0
        ,(const char*)a1
        ,(int)a2
        ,(int)a3
        ,(int*)a4
        );
    word r4 = Store::IntToWord(*a4);
    RETURN1(r4);
} END
DEFINE6(Pango_GlyphStringextentsRange) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_OBJECT_OF_TYPE(a3, x3, PANGO_TYPE_FONT);
    DECLARE_OBJECT(a4, x4);
    DECLARE_OBJECT(a5, x5);
    pango_glyph_string_extents_range(
        (PangoGlyphString*)a0
        ,(int)a1
        ,(int)a2
        ,(PangoFont*)a3
        ,(PangoRectangle*)a4
        ,(PangoRectangle*)a5
        );
    RETURN_UNIT;
} END
DEFINE4(Pango_GlyphStringextents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT);
    DECLARE_OBJECT(a2, x2);
    DECLARE_OBJECT(a3, x3);
    pango_glyph_string_extents(
        (PangoGlyphString*)a0
        ,(PangoFont*)a1
        ,(PangoRectangle*)a2
        ,(PangoRectangle*)a3
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_GlyphStringfree) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    pango_glyph_string_free(
        (PangoGlyphString*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_GlyphStringcopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    PangoGlyphString* cres = (PangoGlyphString*)pango_glyph_string_copy(
        (PangoGlyphString*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_GLYPH_STRING);
    RETURN1(res);
} END
DEFINE0(Pango_GlyphStringgetType) {
    GType cres = (GType)pango_glyph_string_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_GlyphStringsetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_INT(a1, x1);
    pango_glyph_string_set_size(
        (PangoGlyphString*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_GlyphStringgetFieldNumGlyphs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    gint cres = (gint)DOgetFieldNumGlyphs(
        (PangoGlyphString*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_GlyphStringsetFieldNumGlyphs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_INT(a1, x1);
    DOsetFieldNumGlyphs(
        (PangoGlyphString*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_GlyphStringgetFieldLogClusters) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    gint* cres = (gint*)DOgetFieldLogClusters(
        (PangoGlyphString*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE2(Pango_GlyphStringsetFieldLogClusters) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_INT_AS(gint, tmp0, x1);
               gint* a1 = (gint*)&tmp0;
    DOsetFieldLogClusters(
        (PangoGlyphString*)a0
        ,(gint*)a1
        );
    word r1 = Store::IntToWord(*a1);
    RETURN1(r1);
} END
DEFINE1(Pango_GlyphStringgetFieldGlyphs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    PangoGlyphInfo* cres = (PangoGlyphInfo*)DOgetFieldGlyphs(
        (PangoGlyphString*)a0
        );
    word res = OBJECT_TO_WORD (cres);
    RETURN1(res);
} END
DEFINE2(Pango_GlyphStringsetFieldGlyphs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_GLYPH_STRING);
    DECLARE_OBJECT (a1, x1);
    DOsetFieldGlyphs(
        (PangoGlyphString*)a0
        ,(PangoGlyphInfo*)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldGlyphs
#undef DOsetFieldGlyphs
#undef DOgetFieldLogClusters
#undef DOsetFieldLogClusters
#undef DOgetFieldNumGlyphs
#undef DOsetFieldNumGlyphs
DEFINE1(Pango_FontMetricsgetApproximateDigitWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_METRICS);
    int cres = (int)pango_font_metrics_get_approximate_digit_width(
        (PangoFontMetrics*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontMetricsgetApproximateCharWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_METRICS);
    int cres = (int)pango_font_metrics_get_approximate_char_width(
        (PangoFontMetrics*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontMetricsgetDescent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_METRICS);
    int cres = (int)pango_font_metrics_get_descent(
        (PangoFontMetrics*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontMetricsgetAscent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_METRICS);
    int cres = (int)pango_font_metrics_get_ascent(
        (PangoFontMetrics*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontMetricsunref) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_METRICS);
    pango_font_metrics_unref(
        (PangoFontMetrics*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontMetricsreference) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_METRICS);
    PangoFontMetrics* cres = (PangoFontMetrics*)pango_font_metrics_ref(
        (PangoFontMetrics*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_METRICS);
    RETURN1(res);
} END
DEFINE0(Pango_FontMetricsgetType) {
    GType cres = (GType)pango_font_metrics_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptionfromString) {
    DECLARE_CSTRING(a0, x0);
    PangoFontDescription* cres = (PangoFontDescription*)pango_font_description_from_string(
        (const char*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
DEFINE0(Pango_FontDescriptionnew) {
    PangoFontDescription* cres = (PangoFontDescription*)pango_font_description_new(
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptiontoFilename) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    char* cres = (char*)pango_font_description_to_filename(
        (PangoFontDescription*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptiontoString) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    char* cres = (char*)pango_font_description_to_string(
        (PangoFontDescription*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE3(Pango_FontDescriptionbetterMatch) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a2, x2, PANGO_TYPE_FONT_DESCRIPTION);
    gboolean cres = (gboolean)pango_font_description_better_match(
        (PangoFontDescription*)a0
        ,(const PangoFontDescription*)a1
        ,(const PangoFontDescription*)a2
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE3(Pango_FontDescriptionmergeStatic) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_BOOL(a2, x2);
    pango_font_description_merge_static(
        (PangoFontDescription*)a0
        ,(const PangoFontDescription*)a1
        ,(gboolean)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_FontDescriptionmerge) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_BOOL(a2, x2);
    pango_font_description_merge(
        (PangoFontDescription*)a0
        ,(const PangoFontDescription*)a1
        ,(gboolean)a2
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_FontDescriptionunsetFields) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_LIST_ELEMS(tmp0, tmp1, x1, 
{ if (Store::WordToInt(tmp0->Sel(0)) == INVALID_INT)
{REQUEST(x1);}
});
PangoFontMask a1 = PangoFontMasktFromWord(x1);
    pango_font_description_unset_fields(
        (PangoFontDescription*)a0
        ,(PangoFontMask)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptiongetSetFields) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoFontMask cres = (PangoFontMask)pango_font_description_get_set_fields(
        (PangoFontDescription*)a0
        );
    word res = PangoFontMasktToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptiongetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    gint cres = (gint)pango_font_description_get_size(
        (PangoFontDescription*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_FontDescriptionsetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_INT(a1, x1);
    pango_font_description_set_size(
        (PangoFontDescription*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptiongetStretch) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoStretch cres = (PangoStretch)pango_font_description_get_stretch(
        (PangoFontDescription*)a0
        );
    word res = PangoStretchtToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_FontDescriptionsetStretch) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoStretch a1 = PangoStretchtFromWord(x1);
    pango_font_description_set_stretch(
        (PangoFontDescription*)a0
        ,(PangoStretch)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptiongetWeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoWeight cres = (PangoWeight)pango_font_description_get_weight(
        (PangoFontDescription*)a0
        );
    word res = PangoWeighttToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_FontDescriptionsetWeight) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoWeight a1 = PangoWeighttFromWord(x1);
    pango_font_description_set_weight(
        (PangoFontDescription*)a0
        ,(PangoWeight)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptiongetVariant) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoVariant cres = (PangoVariant)pango_font_description_get_variant(
        (PangoFontDescription*)a0
        );
    word res = PangoVarianttToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_FontDescriptionsetVariant) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoVariant a1 = PangoVarianttFromWord(x1);
    pango_font_description_set_variant(
        (PangoFontDescription*)a0
        ,(PangoVariant)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptiongetStyle) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoStyle cres = (PangoStyle)pango_font_description_get_style(
        (PangoFontDescription*)a0
        );
    word res = PangoStyletToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_FontDescriptionsetStyle) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoStyle a1 = PangoStyletFromWord(x1);
    pango_font_description_set_style(
        (PangoFontDescription*)a0
        ,(PangoStyle)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptiongetFamily) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    const char* cres = (const char*)pango_font_description_get_family(
        (PangoFontDescription*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE2(Pango_FontDescriptionsetFamilyStatic) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_CSTRING(a1, x1);
    pango_font_description_set_family_static(
        (PangoFontDescription*)a0
        ,(const char*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_FontDescriptionsetFamily) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_CSTRING(a1, x1);
    pango_font_description_set_family(
        (PangoFontDescription*)a0
        ,(const char*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_FontDescriptionfree) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    pango_font_description_free(
        (PangoFontDescription*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_FontDescriptionequal) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    gboolean cres = (gboolean)pango_font_description_equal(
        (PangoFontDescription*)a0
        ,(const PangoFontDescription*)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptionhash) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    guint cres = (guint)pango_font_description_hash(
        (PangoFontDescription*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptioncopyStatic) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoFontDescription* cres = (PangoFontDescription*)pango_font_description_copy_static(
        (PangoFontDescription*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
DEFINE1(Pango_FontDescriptioncopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoFontDescription* cres = (PangoFontDescription*)pango_font_description_copy(
        (PangoFontDescription*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
PangoColor* MK_PangoColorNew (
        guint16 blue
        , guint16 green
        , guint16 red
        ) {
    PangoColor* res_ = new PangoColor;
    res_->blue = blue;
    res_->green = green;
    res_->red = red;
    return res_;
}
DEFINE3(Pango_Colornew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    PangoColor* cres = (PangoColor*)MK_PangoColorNew(
        (guint16)a0
        ,(guint16)a1
        ,(guint16)a2
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_COLOR);
    RETURN1(res);
} END
#define DOgetFieldBlue(O) ((O)->blue)
#define DOsetFieldBlue(O, V) ((O)->blue = (V))
#define DOgetFieldGreen(O) ((O)->green)
#define DOsetFieldGreen(O, V) ((O)->green = (V))
#define DOgetFieldRed(O) ((O)->red)
#define DOsetFieldRed(O, V) ((O)->red = (V))
DEFINE2(Pango_Colorparse) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    DECLARE_CSTRING(a1, x1);
    gboolean cres = (gboolean)pango_color_parse(
        (PangoColor*)a0
        ,(const char*)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_Colorfree) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    pango_color_free(
        (PangoColor*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_Colorcopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    PangoColor* cres = (PangoColor*)pango_color_copy(
        (PangoColor*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_COLOR);
    RETURN1(res);
} END
DEFINE0(Pango_ColorgetType) {
    GType cres = (GType)pango_color_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_ColorgetFieldRed) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    guint16 cres = (guint16)DOgetFieldRed(
        (PangoColor*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_ColorsetFieldRed) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    DECLARE_INT(a1, x1);
    DOsetFieldRed(
        (PangoColor*)a0
        ,(guint16)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_ColorgetFieldGreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    guint16 cres = (guint16)DOgetFieldGreen(
        (PangoColor*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_ColorsetFieldGreen) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    DECLARE_INT(a1, x1);
    DOsetFieldGreen(
        (PangoColor*)a0
        ,(guint16)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_ColorgetFieldBlue) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    guint16 cres = (guint16)DOgetFieldBlue(
        (PangoColor*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_ColorsetFieldBlue) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_COLOR);
    DECLARE_INT(a1, x1);
    DOsetFieldBlue(
        (PangoColor*)a0
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
DEFINE2(Pango_Attributeequal) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_OBJECT(a1, x1);
    gboolean cres = (gboolean)pango_attribute_equal(
        (PangoAttribute*)a0
        ,(const PangoAttribute*)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_Attributedestroy) {
    DECLARE_OBJECT(a0, x0);
    pango_attribute_destroy(
        (PangoAttribute*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_Attributecopy) {
    DECLARE_OBJECT(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attribute_copy(
        (PangoAttribute*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
PangoLayoutLine* MK_PangoLayoutLineNew (
        guint is_paragraph_start
        , gint length
        , guint resolved_dir
        , GSList* runs
        , gint start_index
        ) {
    PangoLayoutLine* res_ = new PangoLayoutLine;
    res_->is_paragraph_start = is_paragraph_start;
    res_->length = length;
    res_->resolved_dir = resolved_dir;
    res_->runs = runs;
    res_->start_index = start_index;
    return res_;
}
DEFINE5(Pango_LayoutLinenew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_GSLIST(a3, x3, DECLARE_OBJECT);
    DECLARE_INT(a4, x4);
    PangoLayoutLine* cres = (PangoLayoutLine*)MK_PangoLayoutLineNew(
        (guint)a0
        ,(gint)a1
        ,(guint)a2
        ,(GSList*)a3
        ,(gint)a4
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
#define DOgetFieldIsParagraphStart(O) ((O)->is_paragraph_start)
#define DOsetFieldIsParagraphStart(O, V) ((O)->is_paragraph_start = (V))
#define DOgetFieldLength(O) ((O)->length)
#define DOsetFieldLength(O, V) ((O)->length = (V))
#define DOgetFieldResolvedDir(O) ((O)->resolved_dir)
#define DOsetFieldResolvedDir(O, V) ((O)->resolved_dir = (V))
#define DOgetFieldRuns(O) ((O)->runs)
#define DOsetFieldRuns(O, V) ((O)->runs = (V))
#define DOgetFieldStartIndex(O) ((O)->start_index)
#define DOsetFieldStartIndex(O, V) ((O)->start_index = (V))
DEFINE3(Pango_LayoutLinegetPixelExtents) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_line_get_pixel_extents(
        (PangoLayoutLine*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutLinegetExtents) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_line_get_extents(
        (PangoLayoutLine*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE4(Pango_LayoutLineindexToX) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_BOOL(a2, x2);
    DECLARE_INT_AS(int, tmp0, x3);
               int* a3 = (int*)&tmp0;
    pango_layout_line_index_to_x(
        (PangoLayoutLine*)a0
        ,(int)a1
        ,(gboolean)a2
        ,(int*)a3
        );
    word r3 = Store::IntToWord(*a3);
    RETURN1(r3);
} END
DEFINE4(Pango_LayoutLinexToIndex) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT_AS(int, tmp0, x2);
               int* a2 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x3);
               int* a3 = (int*)&tmp1;
    gboolean cres = (gboolean)pango_layout_line_x_to_index(
        (PangoLayoutLine*)a0
        ,(int)a1
        ,(int*)a2
        ,(int*)a3
        );
    word res = BOOL_TO_WORD(cres);
    word r2 = Store::IntToWord(*a2);
    word r3 = Store::IntToWord(*a3);
    RETURN3(res,r2,r3);
} END
DEFINE1(Pango_LayoutLineunref) {
    DECLARE_OBJECT(a0, x0);
    pango_layout_line_unref(
        (PangoLayoutLine*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutLinereference) {
    DECLARE_OBJECT(a0, x0);
    pango_layout_line_ref(
        (PangoLayoutLine*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutLinegetFieldStartIndex) {
    DECLARE_OBJECT(a0, x0);
    gint cres = (gint)DOgetFieldStartIndex(
        (PangoLayoutLine*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutLinesetFieldStartIndex) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldStartIndex(
        (PangoLayoutLine*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutLinegetFieldRuns) {
    DECLARE_OBJECT(a0, x0);
    GSList* cres = (GSList*)DOgetFieldRuns(
        (PangoLayoutLine*)a0
        );
    word res = GSLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutLinesetFieldRuns) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_GSLIST(a1, x1, DECLARE_OBJECT);
    DOsetFieldRuns(
        (PangoLayoutLine*)a0
        ,(GSList*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutLinegetFieldResolvedDir) {
    DECLARE_OBJECT(a0, x0);
    guint cres = (guint)DOgetFieldResolvedDir(
        (PangoLayoutLine*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutLinesetFieldResolvedDir) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldResolvedDir(
        (PangoLayoutLine*)a0
        ,(guint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutLinegetFieldLength) {
    DECLARE_OBJECT(a0, x0);
    gint cres = (gint)DOgetFieldLength(
        (PangoLayoutLine*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutLinesetFieldLength) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldLength(
        (PangoLayoutLine*)a0
        ,(gint)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutLinegetFieldIsParagraphStart) {
    DECLARE_OBJECT(a0, x0);
    guint cres = (guint)DOgetFieldIsParagraphStart(
        (PangoLayoutLine*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutLinesetFieldIsParagraphStart) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldIsParagraphStart(
        (PangoLayoutLine*)a0
        ,(guint)a1
        );
    RETURN_UNIT;
} END
#undef DOgetFieldIsParagraphStart
#undef DOsetFieldIsParagraphStart
#undef DOgetFieldLength
#undef DOsetFieldLength
#undef DOgetFieldResolvedDir
#undef DOsetFieldResolvedDir
#undef DOgetFieldRuns
#undef DOsetFieldRuns
#undef DOgetFieldStartIndex
#undef DOsetFieldStartIndex
PangoRectangle* MK_PangoRectangleNew (
        int height
        , int width
        , int x
        , int y
        ) {
    PangoRectangle* res_ = new PangoRectangle;
    res_->height = height;
    res_->width = width;
    res_->x = x;
    res_->y = y;
    return res_;
}
DEFINE4(Pango_Rectanglenew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    PangoRectangle* cres = (PangoRectangle*)MK_PangoRectangleNew(
        (int)a0
        ,(int)a1
        ,(int)a2
        ,(int)a3
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
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
DEFINE1(Pango_RectanglegetFieldY) {
    DECLARE_OBJECT(a0, x0);
    int cres = (int)DOgetFieldY(
        (PangoRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_RectanglesetFieldY) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldY(
        (PangoRectangle*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_RectanglegetFieldX) {
    DECLARE_OBJECT(a0, x0);
    int cres = (int)DOgetFieldX(
        (PangoRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_RectanglesetFieldX) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldX(
        (PangoRectangle*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_RectanglegetFieldWidth) {
    DECLARE_OBJECT(a0, x0);
    int cres = (int)DOgetFieldWidth(
        (PangoRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_RectanglesetFieldWidth) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldWidth(
        (PangoRectangle*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_RectanglegetFieldHeight) {
    DECLARE_OBJECT(a0, x0);
    int cres = (int)DOgetFieldHeight(
        (PangoRectangle*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_RectanglesetFieldHeight) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_INT(a1, x1);
    DOsetFieldHeight(
        (PangoRectangle*)a0
        ,(int)a1
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
DEFINE1(Pango_Layoutnew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    PangoLayout* cres = (PangoLayout*)pango_layout_new(
        (PangoContext*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutgetIter) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    PangoLayoutIter* cres = (PangoLayoutIter*)pango_layout_get_iter(
        (PangoLayout*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_LAYOUT_ITER);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutgetLines) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    GSList* cres = (GSList*)pango_layout_get_lines(
        (PangoLayout*)a0
        );
    word res = GSLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutgetLine) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    PangoLayoutLine* cres = (PangoLayoutLine*)pango_layout_get_line(
        (PangoLayout*)a0
        ,(int)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_LayoutgetLineCount) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    int cres = (int)pango_layout_get_line_count(
        (PangoLayout*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Pango_LayoutgetPixelSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT_AS(int, tmp0, x1);
               int* a1 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x2);
               int* a2 = (int*)&tmp1;
    pango_layout_get_pixel_size(
        (PangoLayout*)a0
        ,(int*)a1
        ,(int*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE3(Pango_LayoutgetSize) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT_AS(int, tmp0, x1);
               int* a1 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x2);
               int* a2 = (int*)&tmp1;
    pango_layout_get_size(
        (PangoLayout*)a0
        ,(int*)a1
        ,(int*)a2
        );
    word r1 = Store::IntToWord(*a1);
    word r2 = Store::IntToWord(*a2);
    RETURN2(r1,r2);
} END
DEFINE3(Pango_LayoutgetPixelExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_get_pixel_extents(
        (PangoLayout*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutgetExtents) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_OBJECT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_get_extents(
        (PangoLayout*)a0
        ,(PangoRectangle*)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE5(Pango_LayoutxyToIndex) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT_AS(int, tmp0, x3);
               int* a3 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x4);
               int* a4 = (int*)&tmp1;
    gboolean cres = (gboolean)pango_layout_xy_to_index(
        (PangoLayout*)a0
        ,(int)a1
        ,(int)a2
        ,(int*)a3
        ,(int*)a4
        );
    word res = BOOL_TO_WORD(cres);
    word r3 = Store::IntToWord(*a3);
    word r4 = Store::IntToWord(*a4);
    RETURN3(res,r3,r4);
} END
DEFINE7(Pango_LayoutmoveCursorVisually) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_BOOL(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_INT(a3, x3);
    DECLARE_INT(a4, x4);
    DECLARE_INT_AS(int, tmp0, x5);
               int* a5 = (int*)&tmp0;
    DECLARE_INT_AS(int, tmp1, x6);
               int* a6 = (int*)&tmp1;
    pango_layout_move_cursor_visually(
        (PangoLayout*)a0
        ,(gboolean)a1
        ,(int)a2
        ,(int)a3
        ,(int)a4
        ,(int*)a5
        ,(int*)a6
        );
    word r5 = Store::IntToWord(*a5);
    word r6 = Store::IntToWord(*a6);
    RETURN2(r5,r6);
} END
DEFINE4(Pango_LayoutgetCursorPos) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    DECLARE_OBJECT(a3, x3);
    pango_layout_get_cursor_pos(
        (PangoLayout*)a0
        ,(int)a1
        ,(PangoRectangle*)a2
        ,(PangoRectangle*)a3
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutindexToPos) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    DECLARE_OBJECT(a2, x2);
    pango_layout_index_to_pos(
        (PangoLayout*)a0
        ,(int)a1
        ,(PangoRectangle*)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutcontextChanged) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    pango_layout_context_changed(
        (PangoLayout*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetSingleParagraphMode) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    gboolean cres = (gboolean)pango_layout_get_single_paragraph_mode(
        (PangoLayout*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetSingleParagraphMode) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_BOOL(a1, x1);
    pango_layout_set_single_paragraph_mode(
        (PangoLayout*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetTabs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    PangoTabArray* cres = (PangoTabArray*)pango_layout_get_tabs(
        (PangoLayout*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_TAB_ARRAY);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetTabs) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_TAB_ARRAY);
    pango_layout_set_tabs(
        (PangoLayout*)a0
        ,(PangoTabArray*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetAlignment) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    PangoAlignment cres = (PangoAlignment)pango_layout_get_alignment(
        (PangoLayout*)a0
        );
    word res = PangoAlignmenttToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetAlignment) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoAlignment a1 = PangoAlignmenttFromWord(x1);
    pango_layout_set_alignment(
        (PangoLayout*)a0
        ,(PangoAlignment)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetAutoDir) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    gboolean cres = (gboolean)pango_layout_get_auto_dir(
        (PangoLayout*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetAutoDir) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_BOOL(a1, x1);
    pango_layout_set_auto_dir(
        (PangoLayout*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetJustify) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    gboolean cres = (gboolean)pango_layout_get_justify(
        (PangoLayout*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetJustify) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_BOOL(a1, x1);
    pango_layout_set_justify(
        (PangoLayout*)a0
        ,(gboolean)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetSpacing) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    int cres = (int)pango_layout_get_spacing(
        (PangoLayout*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetSpacing) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    pango_layout_set_spacing(
        (PangoLayout*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetIndent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    int cres = (int)pango_layout_get_indent(
        (PangoLayout*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetIndent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    pango_layout_set_indent(
        (PangoLayout*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetWrap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    PangoWrapMode cres = (PangoWrapMode)pango_layout_get_wrap(
        (PangoLayout*)a0
        );
    word res = PangoWrapModetToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetWrap) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoWrapMode a1 = PangoWrapModetFromWord(x1);
    pango_layout_set_wrap(
        (PangoLayout*)a0
        ,(PangoWrapMode)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    int cres = (int)pango_layout_get_width(
        (PangoLayout*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_LayoutsetWidth) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_INT(a1, x1);
    pango_layout_set_width(
        (PangoLayout*)a0
        ,(int)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_LayoutsetFontDescription) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    pango_layout_set_font_description(
        (PangoLayout*)a0
        ,(const PangoFontDescription*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_LayoutsetMarkup) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    pango_layout_set_markup(
        (PangoLayout*)a0
        ,(const char*)a1
        ,(int)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetText) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    const char* cres = (const char*)pango_layout_get_text(
        (PangoLayout*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE3(Pango_LayoutsetText) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    DECLARE_CSTRING(a1, x1);
    DECLARE_INT(a2, x2);
    pango_layout_set_text(
        (PangoLayout*)a0
        ,(const char*)a1
        ,(int)a2
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_LayoutgetContext) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    PangoContext* cres = (PangoContext*)pango_layout_get_context(
        (PangoLayout*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Pango_Layoutcopy) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LAYOUT);
    PangoLayout* cres = (PangoLayout*)pango_layout_copy(
        (PangoLayout*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Pango_LayoutgetType) {
    GType cres = (GType)pango_layout_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontsetgetMetrics) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONTSET);
    PangoFontMetrics* cres = (PangoFontMetrics*)pango_fontset_get_metrics(
        (PangoFontset*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_METRICS);
    RETURN1(res);
} END
DEFINE2(Pango_FontsetgetFont) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONTSET);
    DECLARE_INT(a1, x1);
    PangoFont* cres = (PangoFont*)pango_fontset_get_font(
        (PangoFontset*)a0
        ,(guint)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE4(Pango_FontMaploadFontset) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_MAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a2, x2, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a3, x3, PANGO_TYPE_LANGUAGE);
    PangoFontset* cres = (PangoFontset*)pango_font_map_load_fontset(
        (PangoFontMap*)a0
        ,(PangoContext*)a1
        ,(const PangoFontDescription*)a2
        ,(PangoLanguage*)a3
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE3(Pango_FontMaploadFont) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_MAP);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a2, x2, PANGO_TYPE_FONT_DESCRIPTION);
    PangoFont* cres = (PangoFont*)pango_font_map_load_font(
        (PangoFontMap*)a0
        ,(PangoContext*)a1
        ,(const PangoFontDescription*)a2
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Pango_FontFamilyisMonospace) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_FAMILY);
    gboolean cres = (gboolean)pango_font_family_is_monospace(
        (PangoFontFamily*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontFamilygetName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_FAMILY);
    const char* cres = (const char*)pango_font_family_get_name(
        (PangoFontFamily*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Pango_FontFamilygetType) {
    GType cres = (GType)pango_font_family_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontFacegetFaceName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_FACE);
    const char* cres = (const char*)pango_font_face_get_face_name(
        (PangoFontFace*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE1(Pango_FontFacedescribe) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_FACE);
    PangoFontDescription* cres = (PangoFontDescription*)pango_font_face_describe(
        (PangoFontFace*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
DEFINE0(Pango_FontFacegetType) {
    GType cres = (GType)pango_font_face_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_FontgetMetrics) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_LANGUAGE);
    PangoFontMetrics* cres = (PangoFontMetrics*)pango_font_get_metrics(
        (PangoFont*)a0
        ,(PangoLanguage*)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_METRICS);
    RETURN1(res);
} END
DEFINE1(Pango_Fontdescribe) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT);
    PangoFontDescription* cres = (PangoFontDescription*)pango_font_describe(
        (PangoFont*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
DEFINE0(Pango_FontgetType) {
    GType cres = (GType)pango_font_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_FontdescriptionsFree) {
    DECLARE_C_ARG_ARRAY(a0, a0size, x0, int, PangoFontDescription*, DECLARE_OBJECT_OF_TYPE(elem_c, elem_alice, PANGO_TYPE_FONT_DESCRIPTION););
    pango_font_descriptions_free(
        (PangoFontDescription**)a0, (int)a0size
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_ContextgetBaseDir) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    PangoDirection cres = (PangoDirection)pango_context_get_base_dir(
        (PangoContext*)a0
        );
    word res = PangoDirectiontToWord(cres);
    RETURN1(res);
} END
DEFINE2(Pango_ContextsetBaseDir) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
PangoDirection a1 = PangoDirectiontFromWord(x1);
    pango_context_set_base_dir(
        (PangoContext*)a0
        ,(PangoDirection)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Pango_ContextsetLanguage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_LANGUAGE);
    pango_context_set_language(
        (PangoContext*)a0
        ,(PangoLanguage*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Pango_ContextgetLanguage) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    PangoLanguage* cres = (PangoLanguage*)pango_context_get_language(
        (PangoContext*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_LANGUAGE);
    RETURN1(res);
} END
DEFINE1(Pango_ContextgetFontDescription) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    PangoFontDescription* cres = (PangoFontDescription*)pango_context_get_font_description(
        (PangoContext*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_DESCRIPTION);
    RETURN1(res);
} END
DEFINE2(Pango_ContextsetFontDescription) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    pango_context_set_font_description(
        (PangoContext*)a0
        ,(const PangoFontDescription*)a1
        );
    RETURN_UNIT;
} END
DEFINE3(Pango_ContextgetMetrics) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a2, x2, PANGO_TYPE_LANGUAGE);
    PangoFontMetrics* cres = (PangoFontMetrics*)pango_context_get_metrics(
        (PangoContext*)a0
        ,(const PangoFontDescription*)a1
        ,(PangoLanguage*)a2
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED, PANGO_TYPE_FONT_METRICS);
    RETURN1(res);
} END
DEFINE3(Pango_ContextloadFontset) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    DECLARE_OBJECT_OF_TYPE(a2, x2, PANGO_TYPE_LANGUAGE);
    PangoFontset* cres = (PangoFontset*)pango_context_load_fontset(
        (PangoContext*)a0
        ,(const PangoFontDescription*)a1
        ,(PangoLanguage*)a2
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Pango_ContextloadFont) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_CONTEXT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, PANGO_TYPE_FONT_DESCRIPTION);
    PangoFont* cres = (PangoFont*)pango_context_load_font(
        (PangoContext*)a0
        ,(const PangoFontDescription*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE6(Pango_Parsemarkup) {
    DECLARE_CSTRING(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    DECLARE_OBJECT (a3, x3);
    DECLARE_ZERO_TERMINATED_ARRAY(a4, x4, char*, DECLARE_CSTRING(elem_c, elem_alice));
    DECLARE_OBJECT (a5, x5);
    GError *tmp0 = 0; GError **a6 = &tmp0;
    gboolean cres = (gboolean)pango_parse_markup(
        (const char*)a0
        ,(int)a1
        ,(gunichar)a2
        ,(PangoAttrList**)a3
        ,(char**)a4
        ,(gunichar*)a5
        ,a6
        );
    word res = BOOL_TO_WORD(cres);
    if ((*a6) != NULL) {char message[strlen((*a6)->message)];g_error_free(*a6);RAISE_CORE_ERROR(message);}
    RETURN1(res);
} END
DEFINE0(Pango_AttrlistGetType) {
    GType cres = (GType)pango_attr_list_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Pango_AttrfallbackNew) {
    DECLARE_BOOL(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_fallback_new(
        (gboolean)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrscaleNew) {
    DECLARE_CDOUBLE(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_scale_new(
        (double)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE2(Pango_AttrshapeNew) {
    DECLARE_OBJECT(a0, x0);
    DECLARE_OBJECT(a1, x1);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_shape_new(
        (const PangoRectangle*)a0
        ,(const PangoRectangle*)a1
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrriseNew) {
    DECLARE_INT(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_rise_new(
        (int)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrstrikethroughNew) {
    DECLARE_BOOL(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_strikethrough_new(
        (gboolean)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrunderlineNew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
PangoUnderline a0 = PangoUnderlinetFromWord(x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_underline_new(
        (PangoUnderline)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrfontDescNew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_FONT_DESCRIPTION);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_font_desc_new(
        (const PangoFontDescription*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrstretchNew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
PangoStretch a0 = PangoStretchtFromWord(x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_stretch_new(
        (PangoStretch)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrvariantNew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
PangoVariant a0 = PangoVarianttFromWord(x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_variant_new(
        (PangoVariant)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrweightNew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
PangoWeight a0 = PangoWeighttFromWord(x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_weight_new(
        (PangoWeight)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrstyleNew) {
    if (Store::WordToInt(x0) == INVALID_INT) {REQUEST(x0);}
PangoStyle a0 = PangoStyletFromWord(x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_style_new(
        (PangoStyle)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrsizeNew) {
    DECLARE_INT(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_size_new(
        (int)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE3(Pango_AttrbackgroundNew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_background_new(
        (guint16)a0
        ,(guint16)a1
        ,(guint16)a2
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE3(Pango_AttrforegroundNew) {
    DECLARE_INT(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_foreground_new(
        (guint16)a0
        ,(guint16)a1
        ,(guint16)a2
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrfamilyNew) {
    DECLARE_CSTRING(a0, x0);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_family_new(
        (const char*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Pango_AttrlanguageNew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, PANGO_TYPE_LANGUAGE);
    PangoAttribute* cres = (PangoAttribute*)pango_attr_language_new(
        (PangoLanguage*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE4(Pango_FindparagraphBoundary) {
    DECLARE_CSTRING(a0, x0);
    DECLARE_INT(a1, x1);
    DECLARE_INT_AS(gint, tmp0, x2);
               gint* a2 = (gint*)&tmp0;
    DECLARE_INT_AS(gint, tmp1, x3);
               gint* a3 = (gint*)&tmp1;
    pango_find_paragraph_boundary(
        (const gchar*)a0
        ,(gint)a1
        ,(gint*)a2
        ,(gint*)a3
        );
    word r2 = Store::IntToWord(*a2);
    word r3 = Store::IntToWord(*a3);
    RETURN2(r2,r3);
} END
DEFINE1(Pango_Reorderitems) {
    DECLARE_GLIST(a0, x0, DECLARE_OBJECT);
    GList* cres = (GList*)pango_reorder_items(
        (GList*)a0
        );
    word res  = GLIST_OBJECT_TO_WORD(cres);
    RETURN1(res);
} END
word NativePango_CreateComponent() {
    Record *record = Record::New ((unsigned)237);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Reorderitems",Pango_Reorderitems, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FindparagraphBoundary",Pango_FindparagraphBoundary, 4, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrlanguageNew",Pango_AttrlanguageNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrfamilyNew",Pango_AttrfamilyNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrforegroundNew",Pango_AttrforegroundNew, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrbackgroundNew",Pango_AttrbackgroundNew, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrsizeNew",Pango_AttrsizeNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrstyleNew",Pango_AttrstyleNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrweightNew",Pango_AttrweightNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrvariantNew",Pango_AttrvariantNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrstretchNew",Pango_AttrstretchNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrfontDescNew",Pango_AttrfontDescNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrunderlineNew",Pango_AttrunderlineNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrstrikethroughNew",Pango_AttrstrikethroughNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrriseNew",Pango_AttrriseNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrshapeNew",Pango_AttrshapeNew, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrscaleNew",Pango_AttrscaleNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrfallbackNew",Pango_AttrfallbackNew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrlistGetType",Pango_AttrlistGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Parsemarkup",Pango_Parsemarkup, 6, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextloadFont",Pango_ContextloadFont, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextloadFontset",Pango_ContextloadFontset, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextgetMetrics",Pango_ContextgetMetrics, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextsetFontDescription",Pango_ContextsetFontDescription, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextgetFontDescription",Pango_ContextgetFontDescription, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextgetLanguage",Pango_ContextgetLanguage, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextsetLanguage",Pango_ContextsetLanguage, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextsetBaseDir",Pango_ContextsetBaseDir, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ContextgetBaseDir",Pango_ContextgetBaseDir, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontdescriptionsFree",Pango_FontdescriptionsFree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontgetType",Pango_FontgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Fontdescribe",Pango_Fontdescribe, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontgetMetrics",Pango_FontgetMetrics, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontFacegetType",Pango_FontFacegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontFacedescribe",Pango_FontFacedescribe, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontFacegetFaceName",Pango_FontFacegetFaceName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontFamilygetType",Pango_FontFamilygetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontFamilygetName",Pango_FontFamilygetName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontFamilyisMonospace",Pango_FontFamilyisMonospace, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMaploadFont",Pango_FontMaploadFont, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMaploadFontset",Pango_FontMaploadFontset, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontsetgetFont",Pango_FontsetgetFont, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontsetgetMetrics",Pango_FontsetgetMetrics, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetType",Pango_LayoutgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Layoutcopy",Pango_Layoutcopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetContext",Pango_LayoutgetContext, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetText",Pango_LayoutsetText, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetText",Pango_LayoutgetText, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetMarkup",Pango_LayoutsetMarkup, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetFontDescription",Pango_LayoutsetFontDescription, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetWidth",Pango_LayoutsetWidth, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetWidth",Pango_LayoutgetWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetWrap",Pango_LayoutsetWrap, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetWrap",Pango_LayoutgetWrap, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetIndent",Pango_LayoutsetIndent, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetIndent",Pango_LayoutgetIndent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetSpacing",Pango_LayoutsetSpacing, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetSpacing",Pango_LayoutgetSpacing, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetJustify",Pango_LayoutsetJustify, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetJustify",Pango_LayoutgetJustify, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetAutoDir",Pango_LayoutsetAutoDir, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetAutoDir",Pango_LayoutgetAutoDir, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetAlignment",Pango_LayoutsetAlignment, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetAlignment",Pango_LayoutgetAlignment, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetTabs",Pango_LayoutsetTabs, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetTabs",Pango_LayoutgetTabs, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutsetSingleParagraphMode",Pango_LayoutsetSingleParagraphMode, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetSingleParagraphMode",Pango_LayoutgetSingleParagraphMode, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutcontextChanged",Pango_LayoutcontextChanged, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutindexToPos",Pango_LayoutindexToPos, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetCursorPos",Pango_LayoutgetCursorPos, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutmoveCursorVisually",Pango_LayoutmoveCursorVisually, 7, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutxyToIndex",Pango_LayoutxyToIndex, 5, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetExtents",Pango_LayoutgetExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetPixelExtents",Pango_LayoutgetPixelExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetSize",Pango_LayoutgetSize, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetPixelSize",Pango_LayoutgetPixelSize, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetLineCount",Pango_LayoutgetLineCount, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetLine",Pango_LayoutgetLine, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetLines",Pango_LayoutgetLines, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutgetIter",Pango_LayoutgetIter, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Layoutnew",Pango_Layoutnew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglesetFieldHeight",Pango_RectanglesetFieldHeight, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglegetFieldHeight",Pango_RectanglegetFieldHeight, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglesetFieldWidth",Pango_RectanglesetFieldWidth, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglegetFieldWidth",Pango_RectanglegetFieldWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglesetFieldX",Pango_RectanglesetFieldX, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglegetFieldX",Pango_RectanglegetFieldX, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglesetFieldY",Pango_RectanglesetFieldY, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "RectanglegetFieldY",Pango_RectanglegetFieldY, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Rectanglenew",Pango_Rectanglenew, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinesetFieldIsParagraphStart",Pango_LayoutLinesetFieldIsParagraphStart, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetFieldIsParagraphStart",Pango_LayoutLinegetFieldIsParagraphStart, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinesetFieldLength",Pango_LayoutLinesetFieldLength, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetFieldLength",Pango_LayoutLinegetFieldLength, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinesetFieldResolvedDir",Pango_LayoutLinesetFieldResolvedDir, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetFieldResolvedDir",Pango_LayoutLinegetFieldResolvedDir, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinesetFieldRuns",Pango_LayoutLinesetFieldRuns, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetFieldRuns",Pango_LayoutLinegetFieldRuns, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinesetFieldStartIndex",Pango_LayoutLinesetFieldStartIndex, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetFieldStartIndex",Pango_LayoutLinegetFieldStartIndex, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinereference",Pango_LayoutLinereference, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLineunref",Pango_LayoutLineunref, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinexToIndex",Pango_LayoutLinexToIndex, 4, 3);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLineindexToX",Pango_LayoutLineindexToX, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetExtents",Pango_LayoutLinegetExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinegetPixelExtents",Pango_LayoutLinegetPixelExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutLinenew",Pango_LayoutLinenew, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Attributecopy",Pango_Attributecopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Attributedestroy",Pango_Attributedestroy, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Attributeequal",Pango_Attributeequal, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorsetFieldBlue",Pango_ColorsetFieldBlue, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorgetFieldBlue",Pango_ColorgetFieldBlue, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorsetFieldGreen",Pango_ColorsetFieldGreen, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorgetFieldGreen",Pango_ColorgetFieldGreen, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorsetFieldRed",Pango_ColorsetFieldRed, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorgetFieldRed",Pango_ColorgetFieldRed, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "ColorgetType",Pango_ColorgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Colorcopy",Pango_Colorcopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Colorfree",Pango_Colorfree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Colorparse",Pango_Colorparse, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Colornew",Pango_Colornew, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptioncopy",Pango_FontDescriptioncopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptioncopyStatic",Pango_FontDescriptioncopyStatic, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionhash",Pango_FontDescriptionhash, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionequal",Pango_FontDescriptionequal, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionfree",Pango_FontDescriptionfree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetFamily",Pango_FontDescriptionsetFamily, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetFamilyStatic",Pango_FontDescriptionsetFamilyStatic, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetFamily",Pango_FontDescriptiongetFamily, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetStyle",Pango_FontDescriptionsetStyle, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetStyle",Pango_FontDescriptiongetStyle, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetVariant",Pango_FontDescriptionsetVariant, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetVariant",Pango_FontDescriptiongetVariant, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetWeight",Pango_FontDescriptionsetWeight, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetWeight",Pango_FontDescriptiongetWeight, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetStretch",Pango_FontDescriptionsetStretch, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetStretch",Pango_FontDescriptiongetStretch, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionsetSize",Pango_FontDescriptionsetSize, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetSize",Pango_FontDescriptiongetSize, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiongetSetFields",Pango_FontDescriptiongetSetFields, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionunsetFields",Pango_FontDescriptionunsetFields, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionmerge",Pango_FontDescriptionmerge, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionmergeStatic",Pango_FontDescriptionmergeStatic, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionbetterMatch",Pango_FontDescriptionbetterMatch, 3, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiontoString",Pango_FontDescriptiontoString, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptiontoFilename",Pango_FontDescriptiontoFilename, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionnew",Pango_FontDescriptionnew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontDescriptionfromString",Pango_FontDescriptionfromString, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsgetType",Pango_FontMetricsgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsreference",Pango_FontMetricsreference, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsunref",Pango_FontMetricsunref, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsgetAscent",Pango_FontMetricsgetAscent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsgetDescent",Pango_FontMetricsgetDescent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsgetApproximateCharWidth",Pango_FontMetricsgetApproximateCharWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMetricsgetApproximateDigitWidth",Pango_FontMetricsgetApproximateDigitWidth, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringsetFieldGlyphs",Pango_GlyphStringsetFieldGlyphs, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringgetFieldGlyphs",Pango_GlyphStringgetFieldGlyphs, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringsetFieldLogClusters",Pango_GlyphStringsetFieldLogClusters, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringgetFieldLogClusters",Pango_GlyphStringgetFieldLogClusters, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringsetFieldNumGlyphs",Pango_GlyphStringsetFieldNumGlyphs, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringgetFieldNumGlyphs",Pango_GlyphStringgetFieldNumGlyphs, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringsetSize",Pango_GlyphStringsetSize, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringgetType",Pango_GlyphStringgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringcopy",Pango_GlyphStringcopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringfree",Pango_GlyphStringfree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringextents",Pango_GlyphStringextents, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringextentsRange",Pango_GlyphStringextentsRange, 6, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringgetLogicalWidths",Pango_GlyphStringgetLogicalWidths, 5, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "GlyphStringnew",Pango_GlyphStringnew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "Languagematches",Pango_Languagematches, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LanguagetoString",Pango_LanguagetoString, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LanguagefromString",Pango_LanguagefromString, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetType",Pango_LayoutItergetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutIterfree",Pango_LayoutIterfree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetIndex",Pango_LayoutItergetIndex, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutIteratLastLine",Pango_LayoutIteratLastLine, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutIternextChar",Pango_LayoutIternextChar, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutIternextCluster",Pango_LayoutIternextCluster, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutIternextRun",Pango_LayoutIternextRun, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutIternextLine",Pango_LayoutIternextLine, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetCharExtents",Pango_LayoutItergetCharExtents, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetClusterExtents",Pango_LayoutItergetClusterExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetRunExtents",Pango_LayoutItergetRunExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetLineExtents",Pango_LayoutItergetLineExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetLineYrange",Pango_LayoutItergetLineYrange, 3, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetLayoutExtents",Pango_LayoutItergetLayoutExtents, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "LayoutItergetBaseline",Pango_LayoutItergetBaseline, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraygetType",Pango_TabArraygetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraycopy",Pango_TabArraycopy, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArrayfree",Pango_TabArrayfree, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraygetSize",Pango_TabArraygetSize, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArrayresize",Pango_TabArrayresize, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraysetTab",Pango_TabArraysetTab, 4, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraygetTab",Pango_TabArraygetTab, 4, 2);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraygetPositionsInPixels",Pango_TabArraygetPositionsInPixels, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraynew",Pango_TabArraynew, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabArraynewWithPositions",Pango_TabArraynewWithPositions, 4, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrTypeGetType",Pango_AttrTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrTypeFromInt",Pango_AttrTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AttrTypeToInt",Pango_AttrTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "UnderlineGetType",Pango_UnderlineGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "UnderlineFromInt",Pango_UnderlineFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "UnderlineToInt",Pango_UnderlineToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "CoverageLevelGetType",Pango_CoverageLevelGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "CoverageLevelFromInt",Pango_CoverageLevelFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "CoverageLevelToInt",Pango_CoverageLevelToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "StyleGetType",Pango_StyleGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "StyleFromInt",Pango_StyleFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "StyleToInt",Pango_StyleToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "VariantGetType",Pango_VariantGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "VariantFromInt",Pango_VariantFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "VariantToInt",Pango_VariantToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "WeightGetType",Pango_WeightGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "WeightFromInt",Pango_WeightFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "WeightToInt",Pango_WeightToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "StretchGetType",Pango_StretchGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "StretchFromInt",Pango_StretchFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "StretchToInt",Pango_StretchToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMaskGetType",Pango_FontMaskGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMaskFromInt",Pango_FontMaskFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "FontMaskToInt",Pango_FontMaskToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AlignmentGetType",Pango_AlignmentGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AlignmentFromInt",Pango_AlignmentFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "AlignmentToInt",Pango_AlignmentToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "WrapModeGetType",Pango_WrapModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "WrapModeFromInt",Pango_WrapModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "WrapModeToInt",Pango_WrapModeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabAlignGetType",Pango_TabAlignGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabAlignFromInt",Pango_TabAlignFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "TabAlignToInt",Pango_TabAlignToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "DirectionGetType",Pango_DirectionGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "DirectionFromInt",Pango_DirectionFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "DirectionToInt",Pango_DirectionToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "EllipsizeModeGetType",Pango_EllipsizeModeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "EllipsizeModeFromInt",Pango_EllipsizeModeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativePango", "EllipsizeModeToInt",Pango_EllipsizeModeToInt, 1, 1);
    return record->ToWord ();
}
