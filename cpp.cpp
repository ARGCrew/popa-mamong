#include <dwmapi.h>

static void changeWindowColor(int color) {
    DwmSetWindowAttribute(GetActiveWindow(), DWMWA_BORDER_COLOR, &color, sizeof(color));
}