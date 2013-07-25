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
#include "NativeAtk.hh"
word AtkCoordTypetToWord(AtkCoordType v) {
    unsigned r = 0;
        if (v  == ATK_XY_SCREEN) {
            r = 0;
        } else 
        if (v  == ATK_XY_WINDOW) {
            r = 1;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkCoordType AtkCoordTypetFromWord(word w) {
    AtkCoordType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_XY_SCREEN;
            break;
        case 1: r = ATK_XY_WINDOW;
            break;
        default:
            Error ("AtkCoordTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_CoordTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkCoordTypetFromWord(x0));
} END
DEFINE1(Atk_CoordTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkCoordTypetToWord((AtkCoordType)i));
} END
DEFINE0(Atk_CoordTypeGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_COORD_TYPE));
} END
word AtkKeyEventTypetToWord(AtkKeyEventType v) {
    unsigned r = 0;
        if (v  == ATK_KEY_EVENT_LAST_DEFINED) {
            r = 0;
        } else 
        if (v  == ATK_KEY_EVENT_PRESS) {
            r = 1;
        } else 
        if (v  == ATK_KEY_EVENT_RELEASE) {
            r = 2;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkKeyEventType AtkKeyEventTypetFromWord(word w) {
    AtkKeyEventType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_KEY_EVENT_LAST_DEFINED;
            break;
        case 1: r = ATK_KEY_EVENT_PRESS;
            break;
        case 2: r = ATK_KEY_EVENT_RELEASE;
            break;
        default:
            Error ("AtkKeyEventTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_KeyEventTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkKeyEventTypetFromWord(x0));
} END
DEFINE1(Atk_KeyEventTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkKeyEventTypetToWord((AtkKeyEventType)i));
} END
DEFINE0(Atk_KeyEventTypeGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_KEY_EVENT_TYPE));
} END
word AtkTextBoundarytToWord(AtkTextBoundary v) {
    unsigned r = 0;
        if (v  == ATK_TEXT_BOUNDARY_CHAR) {
            r = 0;
        } else 
        if (v  == ATK_TEXT_BOUNDARY_LINE_END) {
            r = 1;
        } else 
        if (v  == ATK_TEXT_BOUNDARY_LINE_START) {
            r = 2;
        } else 
        if (v  == ATK_TEXT_BOUNDARY_SENTENCE_END) {
            r = 3;
        } else 
        if (v  == ATK_TEXT_BOUNDARY_SENTENCE_START) {
            r = 4;
        } else 
        if (v  == ATK_TEXT_BOUNDARY_WORD_END) {
            r = 5;
        } else 
        if (v  == ATK_TEXT_BOUNDARY_WORD_START) {
            r = 6;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkTextBoundary AtkTextBoundarytFromWord(word w) {
    AtkTextBoundary r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_TEXT_BOUNDARY_CHAR;
            break;
        case 1: r = ATK_TEXT_BOUNDARY_LINE_END;
            break;
        case 2: r = ATK_TEXT_BOUNDARY_LINE_START;
            break;
        case 3: r = ATK_TEXT_BOUNDARY_SENTENCE_END;
            break;
        case 4: r = ATK_TEXT_BOUNDARY_SENTENCE_START;
            break;
        case 5: r = ATK_TEXT_BOUNDARY_WORD_END;
            break;
        case 6: r = ATK_TEXT_BOUNDARY_WORD_START;
            break;
        default:
            Error ("AtkTextBoundarytFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_TextBoundaryToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkTextBoundarytFromWord(x0));
} END
DEFINE1(Atk_TextBoundaryFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkTextBoundarytToWord((AtkTextBoundary)i));
} END
DEFINE0(Atk_TextBoundaryGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_TEXT_BOUNDARY));
} END
word AtkTextAttributetToWord(AtkTextAttribute v) {
    unsigned r = 0;
        if (v  == ATK_TEXT_ATTR_BG_COLOR) {
            r = 0;
        } else 
        if (v  == ATK_TEXT_ATTR_BG_FULL_HEIGHT) {
            r = 1;
        } else 
        if (v  == ATK_TEXT_ATTR_BG_STIPPLE) {
            r = 2;
        } else 
        if (v  == ATK_TEXT_ATTR_DIRECTION) {
            r = 3;
        } else 
        if (v  == ATK_TEXT_ATTR_EDITABLE) {
            r = 4;
        } else 
        if (v  == ATK_TEXT_ATTR_FAMILY_NAME) {
            r = 5;
        } else 
        if (v  == ATK_TEXT_ATTR_FG_COLOR) {
            r = 6;
        } else 
        if (v  == ATK_TEXT_ATTR_FG_STIPPLE) {
            r = 7;
        } else 
        if (v  == ATK_TEXT_ATTR_INDENT) {
            r = 8;
        } else 
        if (v  == ATK_TEXT_ATTR_INVISIBLE) {
            r = 9;
        } else 
        if (v  == ATK_TEXT_ATTR_JUSTIFICATION) {
            r = 10;
        } else 
        if (v  == ATK_TEXT_ATTR_LANGUAGE) {
            r = 11;
        } else 
        if (v  == ATK_TEXT_ATTR_LEFT_MARGIN) {
            r = 12;
        } else 
        if (v  == ATK_TEXT_ATTR_PIXELS_ABOVE_LINES) {
            r = 13;
        } else 
        if (v  == ATK_TEXT_ATTR_PIXELS_BELOW_LINES) {
            r = 14;
        } else 
        if (v  == ATK_TEXT_ATTR_PIXELS_INSIDE_WRAP) {
            r = 15;
        } else 
        if (v  == ATK_TEXT_ATTR_RIGHT_MARGIN) {
            r = 16;
        } else 
        if (v  == ATK_TEXT_ATTR_RISE) {
            r = 17;
        } else 
        if (v  == ATK_TEXT_ATTR_SCALE) {
            r = 18;
        } else 
        if (v  == ATK_TEXT_ATTR_SIZE) {
            r = 19;
        } else 
        if (v  == ATK_TEXT_ATTR_STRETCH) {
            r = 20;
        } else 
        if (v  == ATK_TEXT_ATTR_STRIKETHROUGH) {
            r = 21;
        } else 
        if (v  == ATK_TEXT_ATTR_STYLE) {
            r = 22;
        } else 
        if (v  == ATK_TEXT_ATTR_UNDERLINE) {
            r = 23;
        } else 
        if (v  == ATK_TEXT_ATTR_VARIANT) {
            r = 24;
        } else 
        if (v  == ATK_TEXT_ATTR_WEIGHT) {
            r = 25;
        } else 
        if (v  == ATK_TEXT_ATTR_WRAP_MODE) {
            r = 26;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkTextAttribute AtkTextAttributetFromWord(word w) {
    AtkTextAttribute r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_TEXT_ATTR_BG_COLOR;
            break;
        case 1: r = ATK_TEXT_ATTR_BG_FULL_HEIGHT;
            break;
        case 2: r = ATK_TEXT_ATTR_BG_STIPPLE;
            break;
        case 3: r = ATK_TEXT_ATTR_DIRECTION;
            break;
        case 4: r = ATK_TEXT_ATTR_EDITABLE;
            break;
        case 5: r = ATK_TEXT_ATTR_FAMILY_NAME;
            break;
        case 6: r = ATK_TEXT_ATTR_FG_COLOR;
            break;
        case 7: r = ATK_TEXT_ATTR_FG_STIPPLE;
            break;
        case 8: r = ATK_TEXT_ATTR_INDENT;
            break;
        case 9: r = ATK_TEXT_ATTR_INVISIBLE;
            break;
        case 10: r = ATK_TEXT_ATTR_JUSTIFICATION;
            break;
        case 11: r = ATK_TEXT_ATTR_LANGUAGE;
            break;
        case 12: r = ATK_TEXT_ATTR_LEFT_MARGIN;
            break;
        case 13: r = ATK_TEXT_ATTR_PIXELS_ABOVE_LINES;
            break;
        case 14: r = ATK_TEXT_ATTR_PIXELS_BELOW_LINES;
            break;
        case 15: r = ATK_TEXT_ATTR_PIXELS_INSIDE_WRAP;
            break;
        case 16: r = ATK_TEXT_ATTR_RIGHT_MARGIN;
            break;
        case 17: r = ATK_TEXT_ATTR_RISE;
            break;
        case 18: r = ATK_TEXT_ATTR_SCALE;
            break;
        case 19: r = ATK_TEXT_ATTR_SIZE;
            break;
        case 20: r = ATK_TEXT_ATTR_STRETCH;
            break;
        case 21: r = ATK_TEXT_ATTR_STRIKETHROUGH;
            break;
        case 22: r = ATK_TEXT_ATTR_STYLE;
            break;
        case 23: r = ATK_TEXT_ATTR_UNDERLINE;
            break;
        case 24: r = ATK_TEXT_ATTR_VARIANT;
            break;
        case 25: r = ATK_TEXT_ATTR_WEIGHT;
            break;
        case 26: r = ATK_TEXT_ATTR_WRAP_MODE;
            break;
        default:
            Error ("AtkTextAttributetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_TextAttributeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkTextAttributetFromWord(x0));
} END
DEFINE1(Atk_TextAttributeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkTextAttributetToWord((AtkTextAttribute)i));
} END
DEFINE0(Atk_TextAttributeGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_TEXT_ATTRIBUTE));
} END
word AtkStateTypetToWord(AtkStateType v) {
    unsigned r = 0;
        if (v  == ATK_STATE_ACTIVE) {
            r = 0;
        } else 
        if (v  == ATK_STATE_ARMED) {
            r = 1;
        } else 
        if (v  == ATK_STATE_BUSY) {
            r = 2;
        } else 
        if (v  == ATK_STATE_CHECKED) {
            r = 3;
        } else 
        if (v  == ATK_STATE_DEFUNCT) {
            r = 4;
        } else 
        if (v  == ATK_STATE_EDITABLE) {
            r = 5;
        } else 
        if (v  == ATK_STATE_ENABLED) {
            r = 6;
        } else 
        if (v  == ATK_STATE_EXPANDABLE) {
            r = 7;
        } else 
        if (v  == ATK_STATE_EXPANDED) {
            r = 8;
        } else 
        if (v  == ATK_STATE_FOCUSABLE) {
            r = 9;
        } else 
        if (v  == ATK_STATE_FOCUSED) {
            r = 10;
        } else 
        if (v  == ATK_STATE_HORIZONTAL) {
            r = 11;
        } else 
        if (v  == ATK_STATE_ICONIFIED) {
            r = 12;
        } else 
        if (v  == ATK_STATE_INVALID) {
            r = 13;
        } else 
        if (v  == ATK_STATE_LAST_DEFINED) {
            r = 14;
        } else 
        if (v  == ATK_STATE_MODAL) {
            r = 15;
        } else 
        if (v  == ATK_STATE_MULTISELECTABLE) {
            r = 16;
        } else 
        if (v  == ATK_STATE_MULTI_LINE) {
            r = 17;
        } else 
        if (v  == ATK_STATE_OPAQUE) {
            r = 18;
        } else 
        if (v  == ATK_STATE_PRESSED) {
            r = 19;
        } else 
        if (v  == ATK_STATE_RESIZABLE) {
            r = 20;
        } else 
        if (v  == ATK_STATE_SELECTABLE) {
            r = 21;
        } else 
        if (v  == ATK_STATE_SELECTED) {
            r = 22;
        } else 
        if (v  == ATK_STATE_SENSITIVE) {
            r = 23;
        } else 
        if (v  == ATK_STATE_SHOWING) {
            r = 24;
        } else 
        if (v  == ATK_STATE_SINGLE_LINE) {
            r = 25;
        } else 
        if (v  == ATK_STATE_STALE) {
            r = 26;
        } else 
        if (v  == ATK_STATE_TRANSIENT) {
            r = 27;
        } else 
        if (v  == ATK_STATE_VERTICAL) {
            r = 28;
        } else 
        if (v  == ATK_STATE_VISIBLE) {
            r = 29;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkStateType AtkStateTypetFromWord(word w) {
    AtkStateType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_STATE_ACTIVE;
            break;
        case 1: r = ATK_STATE_ARMED;
            break;
        case 2: r = ATK_STATE_BUSY;
            break;
        case 3: r = ATK_STATE_CHECKED;
            break;
        case 4: r = ATK_STATE_DEFUNCT;
            break;
        case 5: r = ATK_STATE_EDITABLE;
            break;
        case 6: r = ATK_STATE_ENABLED;
            break;
        case 7: r = ATK_STATE_EXPANDABLE;
            break;
        case 8: r = ATK_STATE_EXPANDED;
            break;
        case 9: r = ATK_STATE_FOCUSABLE;
            break;
        case 10: r = ATK_STATE_FOCUSED;
            break;
        case 11: r = ATK_STATE_HORIZONTAL;
            break;
        case 12: r = ATK_STATE_ICONIFIED;
            break;
        case 13: r = ATK_STATE_INVALID;
            break;
        case 14: r = ATK_STATE_LAST_DEFINED;
            break;
        case 15: r = ATK_STATE_MODAL;
            break;
        case 16: r = ATK_STATE_MULTISELECTABLE;
            break;
        case 17: r = ATK_STATE_MULTI_LINE;
            break;
        case 18: r = ATK_STATE_OPAQUE;
            break;
        case 19: r = ATK_STATE_PRESSED;
            break;
        case 20: r = ATK_STATE_RESIZABLE;
            break;
        case 21: r = ATK_STATE_SELECTABLE;
            break;
        case 22: r = ATK_STATE_SELECTED;
            break;
        case 23: r = ATK_STATE_SENSITIVE;
            break;
        case 24: r = ATK_STATE_SHOWING;
            break;
        case 25: r = ATK_STATE_SINGLE_LINE;
            break;
        case 26: r = ATK_STATE_STALE;
            break;
        case 27: r = ATK_STATE_TRANSIENT;
            break;
        case 28: r = ATK_STATE_VERTICAL;
            break;
        case 29: r = ATK_STATE_VISIBLE;
            break;
        default:
            Error ("AtkStateTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_StateTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkStateTypetFromWord(x0));
} END
DEFINE1(Atk_StateTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkStateTypetToWord((AtkStateType)i));
} END
DEFINE0(Atk_StateTypeGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_STATE_TYPE));
} END
word AtkRelationTypetToWord(AtkRelationType v) {
    unsigned r = 0;
        if (v  == ATK_RELATION_CONTROLLED_BY) {
            r = 0;
        } else 
        if (v  == ATK_RELATION_CONTROLLER_FOR) {
            r = 1;
        } else 
        if (v  == ATK_RELATION_LABELLED_BY) {
            r = 2;
        } else 
        if (v  == ATK_RELATION_LABEL_FOR) {
            r = 3;
        } else 
        if (v  == ATK_RELATION_LAST_DEFINED) {
            r = 4;
        } else 
        if (v  == ATK_RELATION_MEMBER_OF) {
            r = 5;
        } else 
        if (v  == ATK_RELATION_NODE_CHILD_OF) {
            r = 6;
        } else 
        if (v  == ATK_RELATION_NULL) {
            r = 7;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkRelationType AtkRelationTypetFromWord(word w) {
    AtkRelationType r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_RELATION_CONTROLLED_BY;
            break;
        case 1: r = ATK_RELATION_CONTROLLER_FOR;
            break;
        case 2: r = ATK_RELATION_LABELLED_BY;
            break;
        case 3: r = ATK_RELATION_LABEL_FOR;
            break;
        case 4: r = ATK_RELATION_LAST_DEFINED;
            break;
        case 5: r = ATK_RELATION_MEMBER_OF;
            break;
        case 6: r = ATK_RELATION_NODE_CHILD_OF;
            break;
        case 7: r = ATK_RELATION_NULL;
            break;
        default:
            Error ("AtkRelationTypetFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_RelationTypeToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkRelationTypetFromWord(x0));
} END
DEFINE1(Atk_RelationTypeFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkRelationTypetToWord((AtkRelationType)i));
} END
DEFINE0(Atk_RelationTypeGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_RELATION_TYPE));
} END
word AtkLayertToWord(AtkLayer v) {
    unsigned r = 0;
        if (v  == ATK_LAYER_BACKGROUND) {
            r = 0;
        } else 
        if (v  == ATK_LAYER_CANVAS) {
            r = 1;
        } else 
        if (v  == ATK_LAYER_INVALID) {
            r = 2;
        } else 
        if (v  == ATK_LAYER_MDI) {
            r = 3;
        } else 
        if (v  == ATK_LAYER_OVERLAY) {
            r = 4;
        } else 
        if (v  == ATK_LAYER_POPUP) {
            r = 5;
        } else 
        if (v  == ATK_LAYER_WIDGET) {
            r = 6;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkLayer AtkLayertFromWord(word w) {
    AtkLayer r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_LAYER_BACKGROUND;
            break;
        case 1: r = ATK_LAYER_CANVAS;
            break;
        case 2: r = ATK_LAYER_INVALID;
            break;
        case 3: r = ATK_LAYER_MDI;
            break;
        case 4: r = ATK_LAYER_OVERLAY;
            break;
        case 5: r = ATK_LAYER_POPUP;
            break;
        case 6: r = ATK_LAYER_WIDGET;
            break;
        default:
            Error ("AtkLayertFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_LayerToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkLayertFromWord(x0));
} END
DEFINE1(Atk_LayerFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkLayertToWord((AtkLayer)i));
} END
DEFINE0(Atk_LayerGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_LAYER));
} END
word AtkRoletToWord(AtkRole v) {
    unsigned r = 0;
        if (v  == ATK_ROLE_ACCEL_LABEL) {
            r = 0;
        } else 
        if (v  == ATK_ROLE_ALERT) {
            r = 1;
        } else 
        if (v  == ATK_ROLE_ANIMATION) {
            r = 2;
        } else 
        if (v  == ATK_ROLE_ARROW) {
            r = 3;
        } else 
        if (v  == ATK_ROLE_CALENDAR) {
            r = 4;
        } else 
        if (v  == ATK_ROLE_CANVAS) {
            r = 5;
        } else 
        if (v  == ATK_ROLE_CHECK_BOX) {
            r = 6;
        } else 
        if (v  == ATK_ROLE_CHECK_MENU_ITEM) {
            r = 7;
        } else 
        if (v  == ATK_ROLE_COLOR_CHOOSER) {
            r = 8;
        } else 
        if (v  == ATK_ROLE_COLUMN_HEADER) {
            r = 9;
        } else 
        if (v  == ATK_ROLE_COMBO_BOX) {
            r = 10;
        } else 
        if (v  == ATK_ROLE_DATE_EDITOR) {
            r = 11;
        } else 
        if (v  == ATK_ROLE_DESKTOP_FRAME) {
            r = 12;
        } else 
        if (v  == ATK_ROLE_DESKTOP_ICON) {
            r = 13;
        } else 
        if (v  == ATK_ROLE_DIAL) {
            r = 14;
        } else 
        if (v  == ATK_ROLE_DIALOG) {
            r = 15;
        } else 
        if (v  == ATK_ROLE_DIRECTORY_PANE) {
            r = 16;
        } else 
        if (v  == ATK_ROLE_DRAWING_AREA) {
            r = 17;
        } else 
        if (v  == ATK_ROLE_FILE_CHOOSER) {
            r = 18;
        } else 
        if (v  == ATK_ROLE_FILLER) {
            r = 19;
        } else 
        if (v  == ATK_ROLE_FONT_CHOOSER) {
            r = 20;
        } else 
        if (v  == ATK_ROLE_FRAME) {
            r = 21;
        } else 
        if (v  == ATK_ROLE_GLASS_PANE) {
            r = 22;
        } else 
        if (v  == ATK_ROLE_HTML_CONTAINER) {
            r = 23;
        } else 
        if (v  == ATK_ROLE_ICON) {
            r = 24;
        } else 
        if (v  == ATK_ROLE_IMAGE) {
            r = 25;
        } else 
        if (v  == ATK_ROLE_INTERNAL_FRAME) {
            r = 26;
        } else 
        if (v  == ATK_ROLE_INVALID) {
            r = 27;
        } else 
        if (v  == ATK_ROLE_LABEL) {
            r = 28;
        } else 
        if (v  == ATK_ROLE_LAST_DEFINED) {
            r = 29;
        } else 
        if (v  == ATK_ROLE_LAYERED_PANE) {
            r = 30;
        } else 
        if (v  == ATK_ROLE_LIST) {
            r = 31;
        } else 
        if (v  == ATK_ROLE_LIST_ITEM) {
            r = 32;
        } else 
        if (v  == ATK_ROLE_MENU) {
            r = 33;
        } else 
        if (v  == ATK_ROLE_MENU_BAR) {
            r = 34;
        } else 
        if (v  == ATK_ROLE_MENU_ITEM) {
            r = 35;
        } else 
        if (v  == ATK_ROLE_OPTION_PANE) {
            r = 36;
        } else 
        if (v  == ATK_ROLE_PAGE_TAB) {
            r = 37;
        } else 
        if (v  == ATK_ROLE_PAGE_TAB_LIST) {
            r = 38;
        } else 
        if (v  == ATK_ROLE_PANEL) {
            r = 39;
        } else 
        if (v  == ATK_ROLE_PASSWORD_TEXT) {
            r = 40;
        } else 
        if (v  == ATK_ROLE_POPUP_MENU) {
            r = 41;
        } else 
        if (v  == ATK_ROLE_PROGRESS_BAR) {
            r = 42;
        } else 
        if (v  == ATK_ROLE_PUSH_BUTTON) {
            r = 43;
        } else 
        if (v  == ATK_ROLE_RADIO_BUTTON) {
            r = 44;
        } else 
        if (v  == ATK_ROLE_RADIO_MENU_ITEM) {
            r = 45;
        } else 
        if (v  == ATK_ROLE_ROOT_PANE) {
            r = 46;
        } else 
        if (v  == ATK_ROLE_ROW_HEADER) {
            r = 47;
        } else 
        if (v  == ATK_ROLE_SCROLL_BAR) {
            r = 48;
        } else 
        if (v  == ATK_ROLE_SCROLL_PANE) {
            r = 49;
        } else 
        if (v  == ATK_ROLE_SEPARATOR) {
            r = 50;
        } else 
        if (v  == ATK_ROLE_SLIDER) {
            r = 51;
        } else 
        if (v  == ATK_ROLE_SPIN_BUTTON) {
            r = 52;
        } else 
        if (v  == ATK_ROLE_SPLIT_PANE) {
            r = 53;
        } else 
        if (v  == ATK_ROLE_STATUSBAR) {
            r = 54;
        } else 
        if (v  == ATK_ROLE_TABLE) {
            r = 55;
        } else 
        if (v  == ATK_ROLE_TABLE_CELL) {
            r = 56;
        } else 
        if (v  == ATK_ROLE_TABLE_COLUMN_HEADER) {
            r = 57;
        } else 
        if (v  == ATK_ROLE_TABLE_ROW_HEADER) {
            r = 58;
        } else 
        if (v  == ATK_ROLE_TEAR_OFF_MENU_ITEM) {
            r = 59;
        } else 
        if (v  == ATK_ROLE_TERMINAL) {
            r = 60;
        } else 
        if (v  == ATK_ROLE_TEXT) {
            r = 61;
        } else 
        if (v  == ATK_ROLE_TOGGLE_BUTTON) {
            r = 62;
        } else 
        if (v  == ATK_ROLE_TOOL_BAR) {
            r = 63;
        } else 
        if (v  == ATK_ROLE_TOOL_TIP) {
            r = 64;
        } else 
        if (v  == ATK_ROLE_TREE) {
            r = 65;
        } else 
        if (v  == ATK_ROLE_TREE_TABLE) {
            r = 66;
        } else 
        if (v  == ATK_ROLE_UNKNOWN) {
            r = 67;
        } else 
        if (v  == ATK_ROLE_VIEWPORT) {
            r = 68;
        } else 
        if (v  == ATK_ROLE_WINDOW) {
            r = 69;
        } else 
        { Error (""); }
    return Store::IntToWord (r);
}
AtkRole AtkRoletFromWord(word w) {
    AtkRole r;
    s_int wi = Store::WordToInt(w);
    switch (wi) {
        case 0: r = ATK_ROLE_ACCEL_LABEL;
            break;
        case 1: r = ATK_ROLE_ALERT;
            break;
        case 2: r = ATK_ROLE_ANIMATION;
            break;
        case 3: r = ATK_ROLE_ARROW;
            break;
        case 4: r = ATK_ROLE_CALENDAR;
            break;
        case 5: r = ATK_ROLE_CANVAS;
            break;
        case 6: r = ATK_ROLE_CHECK_BOX;
            break;
        case 7: r = ATK_ROLE_CHECK_MENU_ITEM;
            break;
        case 8: r = ATK_ROLE_COLOR_CHOOSER;
            break;
        case 9: r = ATK_ROLE_COLUMN_HEADER;
            break;
        case 10: r = ATK_ROLE_COMBO_BOX;
            break;
        case 11: r = ATK_ROLE_DATE_EDITOR;
            break;
        case 12: r = ATK_ROLE_DESKTOP_FRAME;
            break;
        case 13: r = ATK_ROLE_DESKTOP_ICON;
            break;
        case 14: r = ATK_ROLE_DIAL;
            break;
        case 15: r = ATK_ROLE_DIALOG;
            break;
        case 16: r = ATK_ROLE_DIRECTORY_PANE;
            break;
        case 17: r = ATK_ROLE_DRAWING_AREA;
            break;
        case 18: r = ATK_ROLE_FILE_CHOOSER;
            break;
        case 19: r = ATK_ROLE_FILLER;
            break;
        case 20: r = ATK_ROLE_FONT_CHOOSER;
            break;
        case 21: r = ATK_ROLE_FRAME;
            break;
        case 22: r = ATK_ROLE_GLASS_PANE;
            break;
        case 23: r = ATK_ROLE_HTML_CONTAINER;
            break;
        case 24: r = ATK_ROLE_ICON;
            break;
        case 25: r = ATK_ROLE_IMAGE;
            break;
        case 26: r = ATK_ROLE_INTERNAL_FRAME;
            break;
        case 27: r = ATK_ROLE_INVALID;
            break;
        case 28: r = ATK_ROLE_LABEL;
            break;
        case 29: r = ATK_ROLE_LAST_DEFINED;
            break;
        case 30: r = ATK_ROLE_LAYERED_PANE;
            break;
        case 31: r = ATK_ROLE_LIST;
            break;
        case 32: r = ATK_ROLE_LIST_ITEM;
            break;
        case 33: r = ATK_ROLE_MENU;
            break;
        case 34: r = ATK_ROLE_MENU_BAR;
            break;
        case 35: r = ATK_ROLE_MENU_ITEM;
            break;
        case 36: r = ATK_ROLE_OPTION_PANE;
            break;
        case 37: r = ATK_ROLE_PAGE_TAB;
            break;
        case 38: r = ATK_ROLE_PAGE_TAB_LIST;
            break;
        case 39: r = ATK_ROLE_PANEL;
            break;
        case 40: r = ATK_ROLE_PASSWORD_TEXT;
            break;
        case 41: r = ATK_ROLE_POPUP_MENU;
            break;
        case 42: r = ATK_ROLE_PROGRESS_BAR;
            break;
        case 43: r = ATK_ROLE_PUSH_BUTTON;
            break;
        case 44: r = ATK_ROLE_RADIO_BUTTON;
            break;
        case 45: r = ATK_ROLE_RADIO_MENU_ITEM;
            break;
        case 46: r = ATK_ROLE_ROOT_PANE;
            break;
        case 47: r = ATK_ROLE_ROW_HEADER;
            break;
        case 48: r = ATK_ROLE_SCROLL_BAR;
            break;
        case 49: r = ATK_ROLE_SCROLL_PANE;
            break;
        case 50: r = ATK_ROLE_SEPARATOR;
            break;
        case 51: r = ATK_ROLE_SLIDER;
            break;
        case 52: r = ATK_ROLE_SPIN_BUTTON;
            break;
        case 53: r = ATK_ROLE_SPLIT_PANE;
            break;
        case 54: r = ATK_ROLE_STATUSBAR;
            break;
        case 55: r = ATK_ROLE_TABLE;
            break;
        case 56: r = ATK_ROLE_TABLE_CELL;
            break;
        case 57: r = ATK_ROLE_TABLE_COLUMN_HEADER;
            break;
        case 58: r = ATK_ROLE_TABLE_ROW_HEADER;
            break;
        case 59: r = ATK_ROLE_TEAR_OFF_MENU_ITEM;
            break;
        case 60: r = ATK_ROLE_TERMINAL;
            break;
        case 61: r = ATK_ROLE_TEXT;
            break;
        case 62: r = ATK_ROLE_TOGGLE_BUTTON;
            break;
        case 63: r = ATK_ROLE_TOOL_BAR;
            break;
        case 64: r = ATK_ROLE_TOOL_TIP;
            break;
        case 65: r = ATK_ROLE_TREE;
            break;
        case 66: r = ATK_ROLE_TREE_TABLE;
            break;
        case 67: r = ATK_ROLE_UNKNOWN;
            break;
        case 68: r = ATK_ROLE_VIEWPORT;
            break;
        case 69: r = ATK_ROLE_WINDOW;
            break;
        default:
            Error ("AtkRoletFromWord: invalid enum");
            break;
    }
    return r;
}
DEFINE1(Atk_RoleToInt) {
    if (Store::WordToInt (x0) == INVALID_INT) { REQUEST(x0); }
    RETURN_INT(AtkRoletFromWord(x0));
} END
DEFINE1(Atk_RoleFromInt) {
    DECLARE_INT(i, x0);
    RETURN(AtkRoletToWord((AtkRole)i));
} END
DEFINE0(Atk_RoleGetType) {
    RETURN1(Store::IntToWord(ATK_TYPE_ROLE));
} END
DEFINE0(Atk_UtilgetType) {
    GType cres = (GType)atk_util_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Atk_StateSetxorSets) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    DECLARE_OBJECT_OF_TYPE(a1, x1, ATK_TYPE_STATE_SET);
    AtkStateSet* cres = (AtkStateSet*)atk_state_set_xor_sets(
        (AtkStateSet*)a0
        ,(AtkStateSet*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_StateSetorSets) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    DECLARE_OBJECT_OF_TYPE(a1, x1, ATK_TYPE_STATE_SET);
    AtkStateSet* cres = (AtkStateSet*)atk_state_set_or_sets(
        (AtkStateSet*)a0
        ,(AtkStateSet*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_StateSetandSets) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    DECLARE_OBJECT_OF_TYPE(a1, x1, ATK_TYPE_STATE_SET);
    AtkStateSet* cres = (AtkStateSet*)atk_state_set_and_sets(
        (AtkStateSet*)a0
        ,(AtkStateSet*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_StateSetremoveState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
AtkStateType a1 = AtkStateTypetFromWord(x1);
    gboolean cres = (gboolean)atk_state_set_remove_state(
        (AtkStateSet*)a0
        ,(AtkStateType)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Atk_StateSetcontainsStates) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    DECLARE_C_ARG_ARRAY(a1, a1size, x1, gint, AtkStateType, if (Store::WordToInt(elem_alice) == INVALID_INT) {REQUEST(elem_alice);}
AtkStateType elem_c = AtkStateTypetFromWord(elem_alice););
    gboolean cres = (gboolean)atk_state_set_contains_states(
        (AtkStateSet*)a0
        ,(AtkStateType*)a1, (gint)a1size
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE2(Atk_StateSetcontainsState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
AtkStateType a1 = AtkStateTypetFromWord(x1);
    gboolean cres = (gboolean)atk_state_set_contains_state(
        (AtkStateSet*)a0
        ,(AtkStateType)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Atk_StateSetclearStates) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    atk_state_set_clear_states(
        (AtkStateSet*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_StateSetaddStates) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    DECLARE_C_ARG_ARRAY(a1, a1size, x1, gint, AtkStateType, if (Store::WordToInt(elem_alice) == INVALID_INT) {REQUEST(elem_alice);}
AtkStateType elem_c = AtkStateTypetFromWord(elem_alice););
    atk_state_set_add_states(
        (AtkStateSet*)a0
        ,(AtkStateType*)a1, (gint)a1size
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_StateSetaddState) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
AtkStateType a1 = AtkStateTypetFromWord(x1);
    gboolean cres = (gboolean)atk_state_set_add_state(
        (AtkStateSet*)a0
        ,(AtkStateType)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Atk_StateSetisEmpty) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_STATE_SET);
    gboolean cres = (gboolean)atk_state_set_is_empty(
        (AtkStateSet*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE0(Atk_StateSetgetType) {
    GType cres = (GType)atk_state_set_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_RelationSetnew) {
    AtkRelationSet* cres = (AtkRelationSet*)atk_relation_set_new(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_RelationSetgetRelationByType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION_SET);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
AtkRelationType a1 = AtkRelationTypetFromWord(x1);
    AtkRelation* cres = (AtkRelation*)atk_relation_set_get_relation_by_type(
        (AtkRelationSet*)a0
        ,(AtkRelationType)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_RelationSetgetRelation) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION_SET);
    DECLARE_INT(a1, x1);
    AtkRelation* cres = (AtkRelation*)atk_relation_set_get_relation(
        (AtkRelationSet*)a0
        ,(gint)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Atk_RelationSetgetNRelations) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION_SET);
    gint cres = (gint)atk_relation_set_get_n_relations(
        (AtkRelationSet*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Atk_RelationSetadd) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION_SET);
    DECLARE_OBJECT_OF_TYPE(a1, x1, ATK_TYPE_RELATION);
    atk_relation_set_add(
        (AtkRelationSet*)a0
        ,(AtkRelation*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_RelationSetremove) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION_SET);
    DECLARE_OBJECT_OF_TYPE(a1, x1, ATK_TYPE_RELATION);
    atk_relation_set_remove(
        (AtkRelationSet*)a0
        ,(AtkRelation*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_RelationSetcontains) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION_SET);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
AtkRelationType a1 = AtkRelationTypetFromWord(x1);
    gboolean cres = (gboolean)atk_relation_set_contains(
        (AtkRelationSet*)a0
        ,(AtkRelationType)a1
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE0(Atk_RelationSetgetType) {
    GType cres = (GType)atk_relation_set_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_RelationgetTarget) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION);
    GPtrArray* cres = (GPtrArray*)atk_relation_get_target(
        (AtkRelation*)a0
        );
    word res = OBJECT_TO_WORD (cres, TYPE_BOXED);
    RETURN1(res);
} END
DEFINE1(Atk_RelationgetRelationType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_RELATION);
    AtkRelationType cres = (AtkRelationType)atk_relation_get_relation_type(
        (AtkRelation*)a0
        );
    word res = AtkRelationTypetToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_RelationgetType) {
    GType cres = (GType)atk_relation_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Atk_RegistrygetFactory) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_REGISTRY);
    DECLARE_INT(a1, x1);
    AtkObjectFactory* cres = (AtkObjectFactory*)atk_registry_get_factory(
        (AtkRegistry*)a0
        ,(GType)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_RegistrygetFactoryType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_REGISTRY);
    DECLARE_INT(a1, x1);
    GType cres = (GType)atk_registry_get_factory_type(
        (AtkRegistry*)a0
        ,(GType)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE3(Atk_RegistrysetFactoryType) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_REGISTRY);
    DECLARE_INT(a1, x1);
    DECLARE_INT(a2, x2);
    atk_registry_set_factory_type(
        (AtkRegistry*)a0
        ,(GType)a1
        ,(GType)a2
        );
    RETURN_UNIT;
} END
DEFINE0(Atk_RegistrygetType) {
    GType cres = (GType)atk_registry_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_NoOpObjectFactorynew) {
    AtkObjectFactory* cres = (AtkObjectFactory*)atk_no_op_object_factory_new(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Atk_NoOpObjectFactorygetType) {
    GType cres = (GType)atk_no_op_object_factory_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectFactoryinvalidate) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT_FACTORY);
    atk_object_factory_invalidate(
        (AtkObjectFactory*)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_ObjectFactorycreateAccessible) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT_FACTORY);
    DECLARE_OBJECT_OF_TYPE(a1, x1, G_TYPE_OBJECT);
    AtkObject* cres = (AtkObject*)atk_object_factory_create_accessible(
        (AtkObjectFactory*)a0
        ,(GObject*)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Atk_ObjectFactorygetType) {
    GType cres = (GType)atk_object_factory_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_NoOpObjectnew) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, G_TYPE_OBJECT);
    AtkNoOpObject* cres = (AtkNoOpObject*)atk_no_op_object_new(
        (GObject*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Atk_NoOpObjectgetType) {
    GType cres = (GType)atk_no_op_object_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Atk_ObjectremovePropertyChangeHandler) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    DECLARE_INT(a1, x1);
    atk_object_remove_property_change_handler(
        (AtkObject*)a0
        ,(guint)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_ObjectsetRole) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    if (Store::WordToInt(x1) == INVALID_INT) {REQUEST(x1);}
AtkRole a1 = AtkRoletFromWord(x1);
    atk_object_set_role(
        (AtkObject*)a0
        ,(AtkRole)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_ObjectsetParent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    DECLARE_OBJECT_OF_TYPE(a1, x1, ATK_TYPE_OBJECT);
    atk_object_set_parent(
        (AtkObject*)a0
        ,(AtkObject*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_ObjectsetDescription) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    DECLARE_CSTRING(a1, x1);
    atk_object_set_description(
        (AtkObject*)a0
        ,(const gchar*)a1
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_ObjectsetName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    DECLARE_CSTRING(a1, x1);
    atk_object_set_name(
        (AtkObject*)a0
        ,(const gchar*)a1
        );
    RETURN_UNIT;
} END
DEFINE1(Atk_ObjectgetIndexInParent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    gint cres = (gint)atk_object_get_index_in_parent(
        (AtkObject*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectrefStateSet) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    AtkStateSet* cres = (AtkStateSet*)atk_object_ref_state_set(
        (AtkObject*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetMdiZorder) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    gint cres = (gint)atk_object_get_mdi_zorder(
        (AtkObject*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetLayer) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    AtkLayer cres = (AtkLayer)atk_object_get_layer(
        (AtkObject*)a0
        );
    word res = AtkLayertToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetRole) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    AtkRole cres = (AtkRole)atk_object_get_role(
        (AtkObject*)a0
        );
    word res = AtkRoletToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectrefRelationSet) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    AtkRelationSet* cres = (AtkRelationSet*)atk_object_ref_relation_set(
        (AtkObject*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_ObjectrefAccessibleChild) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    DECLARE_INT(a1, x1);
    AtkObject* cres = (AtkObject*)atk_object_ref_accessible_child(
        (AtkObject*)a0
        ,(gint)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetNAccessibleChildren) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    gint cres = (gint)atk_object_get_n_accessible_children(
        (AtkObject*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetParent) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    AtkObject* cres = (AtkObject*)atk_object_get_parent(
        (AtkObject*)a0
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetDescription) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    const gchar* cres = (const gchar*)atk_object_get_description(
        (AtkObject*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE1(Atk_ObjectgetName) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    const gchar* cres = (const gchar*)atk_object_get_name(
        (AtkObject*)a0
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Atk_ObjectgetType) {
    GType cres = (GType)atk_object_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_HyperlinkgetNAnchors) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_HYPERLINK);
    gint cres = (gint)atk_hyperlink_get_n_anchors(
        (AtkHyperlink*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_HyperlinkisValid) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_HYPERLINK);
    gboolean cres = (gboolean)atk_hyperlink_is_valid(
        (AtkHyperlink*)a0
        );
    word res = BOOL_TO_WORD(cres);
    RETURN1(res);
} END
DEFINE1(Atk_HyperlinkgetStartIndex) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_HYPERLINK);
    gint cres = (gint)atk_hyperlink_get_start_index(
        (AtkHyperlink*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_HyperlinkgetEndIndex) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_HYPERLINK);
    gint cres = (gint)atk_hyperlink_get_end_index(
        (AtkHyperlink*)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Atk_HyperlinkgetObject) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_HYPERLINK);
    DECLARE_INT(a1, x1);
    AtkObject* cres = (AtkObject*)atk_hyperlink_get_object(
        (AtkHyperlink*)a0
        ,(gint)a1
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE2(Atk_HyperlinkgetUri) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_HYPERLINK);
    DECLARE_INT(a1, x1);
    gchar* cres = (gchar*)atk_hyperlink_get_uri(
        (AtkHyperlink*)a0
        ,(gint)a1
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Atk_HyperlinkgetType) {
    GType cres = (GType)atk_hyperlink_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_ImplementorgetType) {
    GType cres = (GType)atk_implementor_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_TextgetType) {
    GType cres = (GType)atk_text_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_StreamablecontentGetType) {
    GType cres = (GType)atk_streamable_content_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_ImagegetType) {
    GType cres = (GType)atk_image_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_FocustrackerNotify) {
    DECLARE_OBJECT_OF_TYPE(a0, x0, ATK_TYPE_OBJECT);
    atk_focus_tracker_notify(
        (AtkObject*)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Atk_FocustrackerInit) {
    DECLARE_OBJECT (a0, x0);
    atk_focus_tracker_init(
        (AtkEventListenerInit)a0
        );
    RETURN_UNIT;
} END
DEFINE2(Atk_AddkeyEventListener) {
    AtkKeySnoopFunc a0 = 0; /* FIXME: can't be done with current seam*/
    DECLARE_OBJECT(a1, x1);
    guint cres = (guint)atk_add_key_event_listener(
        (AtkKeySnoopFunc)a0
        ,(gpointer)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE2(Atk_AddglobalEventListener) {
    DECLARE_OBJECT (a0, x0);
    DECLARE_CSTRING(a1, x1);
    guint cres = (guint)atk_add_global_event_listener(
        (GSignalEmissionHook)a0
        ,(const gchar*)a1
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_AddfocusTracker) {
    DECLARE_OBJECT (a0, x0);
    guint cres = (guint)atk_add_focus_tracker(
        (AtkEventListener)a0
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_HypertextgetType) {
    GType cres = (GType)atk_hypertext_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_EditabletextGetType) {
    GType cres = (GType)atk_editable_text_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_DocumentgetType) {
    GType cres = (GType)atk_document_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_TablegetType) {
    GType cres = (GType)atk_table_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE1(Atk_RemovekeyEventListener) {
    DECLARE_INT(a0, x0);
    atk_remove_key_event_listener(
        (guint)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Atk_RemoveglobalEventListener) {
    DECLARE_INT(a0, x0);
    atk_remove_global_event_listener(
        (guint)a0
        );
    RETURN_UNIT;
} END
DEFINE1(Atk_RemovefocusTracker) {
    DECLARE_INT(a0, x0);
    atk_remove_focus_tracker(
        (guint)a0
        );
    RETURN_UNIT;
} END
DEFINE0(Atk_GettoolkitVersion) {
    const gchar* cres = (const gchar*)atk_get_toolkit_version(
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Atk_GettoolkitName) {
    const gchar* cres = (const gchar*)atk_get_toolkit_name(
        );
    word res = String::New (cres != 0 ? cres : empty_str)->ToWord ();
    RETURN1(res);
} END
DEFINE0(Atk_Getroot) {
    AtkObject* cres = (AtkObject*)atk_get_root(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Atk_GetdefaultRegistry) {
    AtkRegistry* cres = (AtkRegistry*)atk_get_default_registry(
        );
    word res = OBJECT_TO_WORD(cres,TYPE_G_OBJECT);
    RETURN1(res);
} END
DEFINE0(Atk_SelectiongetType) {
    GType cres = (GType)atk_selection_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_ComponentgetType) {
    GType cres = (GType)atk_component_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
DEFINE0(Atk_ActiongetType) {
    GType cres = (GType)atk_action_get_type(
        );
    word res = Store::IntToWord(cres);
    RETURN1(res);
} END
word NativeAtk_CreateComponent() {
    Record *record = Record::New ((unsigned)105);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ActiongetType",Atk_ActiongetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ComponentgetType",Atk_ComponentgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "SelectiongetType",Atk_SelectiongetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "GetdefaultRegistry",Atk_GetdefaultRegistry, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "Getroot",Atk_Getroot, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "GettoolkitName",Atk_GettoolkitName, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "GettoolkitVersion",Atk_GettoolkitVersion, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RemovefocusTracker",Atk_RemovefocusTracker, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RemoveglobalEventListener",Atk_RemoveglobalEventListener, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RemovekeyEventListener",Atk_RemovekeyEventListener, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TablegetType",Atk_TablegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "DocumentgetType",Atk_DocumentgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "EditabletextGetType",Atk_EditabletextGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HypertextgetType",Atk_HypertextgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "AddfocusTracker",Atk_AddfocusTracker, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "AddglobalEventListener",Atk_AddglobalEventListener, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "AddkeyEventListener",Atk_AddkeyEventListener, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "FocustrackerInit",Atk_FocustrackerInit, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "FocustrackerNotify",Atk_FocustrackerNotify, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ImagegetType",Atk_ImagegetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StreamablecontentGetType",Atk_StreamablecontentGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextgetType",Atk_TextgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ImplementorgetType",Atk_ImplementorgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkgetType",Atk_HyperlinkgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkgetUri",Atk_HyperlinkgetUri, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkgetObject",Atk_HyperlinkgetObject, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkgetEndIndex",Atk_HyperlinkgetEndIndex, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkgetStartIndex",Atk_HyperlinkgetStartIndex, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkisValid",Atk_HyperlinkisValid, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "HyperlinkgetNAnchors",Atk_HyperlinkgetNAnchors, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetType",Atk_ObjectgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetName",Atk_ObjectgetName, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetDescription",Atk_ObjectgetDescription, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetParent",Atk_ObjectgetParent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetNAccessibleChildren",Atk_ObjectgetNAccessibleChildren, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectrefAccessibleChild",Atk_ObjectrefAccessibleChild, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectrefRelationSet",Atk_ObjectrefRelationSet, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetRole",Atk_ObjectgetRole, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetLayer",Atk_ObjectgetLayer, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetMdiZorder",Atk_ObjectgetMdiZorder, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectrefStateSet",Atk_ObjectrefStateSet, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectgetIndexInParent",Atk_ObjectgetIndexInParent, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectsetName",Atk_ObjectsetName, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectsetDescription",Atk_ObjectsetDescription, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectsetParent",Atk_ObjectsetParent, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectsetRole",Atk_ObjectsetRole, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectremovePropertyChangeHandler",Atk_ObjectremovePropertyChangeHandler, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "NoOpObjectgetType",Atk_NoOpObjectgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "NoOpObjectnew",Atk_NoOpObjectnew, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectFactorygetType",Atk_ObjectFactorygetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectFactorycreateAccessible",Atk_ObjectFactorycreateAccessible, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "ObjectFactoryinvalidate",Atk_ObjectFactoryinvalidate, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "NoOpObjectFactorygetType",Atk_NoOpObjectFactorygetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "NoOpObjectFactorynew",Atk_NoOpObjectFactorynew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RegistrygetType",Atk_RegistrygetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RegistrysetFactoryType",Atk_RegistrysetFactoryType, 3, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RegistrygetFactoryType",Atk_RegistrygetFactoryType, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RegistrygetFactory",Atk_RegistrygetFactory, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationgetType",Atk_RelationgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationgetRelationType",Atk_RelationgetRelationType, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationgetTarget",Atk_RelationgetTarget, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetgetType",Atk_RelationSetgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetcontains",Atk_RelationSetcontains, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetremove",Atk_RelationSetremove, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetadd",Atk_RelationSetadd, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetgetNRelations",Atk_RelationSetgetNRelations, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetgetRelation",Atk_RelationSetgetRelation, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetgetRelationByType",Atk_RelationSetgetRelationByType, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationSetnew",Atk_RelationSetnew, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetgetType",Atk_StateSetgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetisEmpty",Atk_StateSetisEmpty, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetaddState",Atk_StateSetaddState, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetaddStates",Atk_StateSetaddStates, 2, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetclearStates",Atk_StateSetclearStates, 1, 0);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetcontainsState",Atk_StateSetcontainsState, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetcontainsStates",Atk_StateSetcontainsStates, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetremoveState",Atk_StateSetremoveState, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetandSets",Atk_StateSetandSets, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetorSets",Atk_StateSetorSets, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateSetxorSets",Atk_StateSetxorSets, 2, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "UtilgetType",Atk_UtilgetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RoleGetType",Atk_RoleGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RoleFromInt",Atk_RoleFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RoleToInt",Atk_RoleToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "LayerGetType",Atk_LayerGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "LayerFromInt",Atk_LayerFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "LayerToInt",Atk_LayerToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationTypeGetType",Atk_RelationTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationTypeFromInt",Atk_RelationTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "RelationTypeToInt",Atk_RelationTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateTypeGetType",Atk_StateTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateTypeFromInt",Atk_StateTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "StateTypeToInt",Atk_StateTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextAttributeGetType",Atk_TextAttributeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextAttributeFromInt",Atk_TextAttributeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextAttributeToInt",Atk_TextAttributeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextBoundaryGetType",Atk_TextBoundaryGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextBoundaryFromInt",Atk_TextBoundaryFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "TextBoundaryToInt",Atk_TextBoundaryToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "KeyEventTypeGetType",Atk_KeyEventTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "KeyEventTypeFromInt",Atk_KeyEventTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "KeyEventTypeToInt",Atk_KeyEventTypeToInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "CoordTypeGetType",Atk_CoordTypeGetType, 0, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "CoordTypeFromInt",Atk_CoordTypeFromInt, 1, 1);
    INIT_STRUCTURE_N(record, "NativeLibs.NativeAtk", "CoordTypeToInt",Atk_CoordTypeToInt, 1, 1);
    return record->ToWord ();
}
