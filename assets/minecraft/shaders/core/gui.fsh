#version 330

// Копия ванильного gui.fsh (1.21.11) + отбраковка подложки сайдбара.
//
// Ванилла рисует под строками борда полупрозрачный чёрный прямоугольник и НЕ даёт убрать его
// с сервера: измеренная ширина борда зажата снизу нулём, поэтому подложка всегда не меньше 2px
// у правого края, и рисуется она ПОВЕРХ панели — ни схлопнуть, ни накрыть её нельзя.
// Единственный способ убрать совсем — отбраковать её фрагменты здесь.
//
// Признак: чистый чёрный (rgb = 0) с альфой ровно 0.3 у строк и 0.4 у заголовка
// (Gui.displayScoreboardSidebar -> Options.getBackgroundOpacity(0.3F/0.4F)).
// Фон чата и таб-листа сюда не попадает: чат берёт textBackgroundOpacity (по умолчанию 0.5),
// таб-лист — 0x80000000, то есть альфа ~0.502.
//
// Ограничение: если игрок выключит в настройках «Фон только для чата», сайдбар начнёт брать
// ту же textBackgroundOpacity, что и чат, и по альфе их станет не различить — тогда подложка
// у такого игрока вернётся. Ломаться при этом ничего не будет.
//
// moj_import тут использовать нельзя — шейдер грузится до ресурс-паков, поэтому блок
// DynamicTransforms скопирован дословно из ванильного файла.

layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
};

in vec4 vertexColor;

out vec4 fragColor;

const float SIDEBAR_ROW_ALPHA = 76.0 / 255.0;    // 0.3
const float SIDEBAR_TITLE_ALPHA = 102.0 / 255.0; // 0.4
const float EPS = 0.002;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    if (color.r + color.g + color.b == 0.0
            && (abs(color.a - SIDEBAR_ROW_ALPHA) < EPS || abs(color.a - SIDEBAR_TITLE_ALPHA) < EPS)) {
        discard;
    }
    fragColor = color * ColorModulator;
}
