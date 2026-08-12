#version 330

// Can't moj_import in things used during startup, when resource packs don't exist.
// This is a copy of dynamicimports.glsl
layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
    float LineWidth;
};

in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }

// --- VirtusMine: убираем ванильную подложку сайдбара ---------------------------------
// Ванилла заливает её чистым чёрным с альфой ровно 0.3 (строки борда) и 0.4 (заголовок),
// см. Gui.displayScoreboardSidebar -> Options.getBackgroundOpacity(0.3F/0.4F).
// Фон чата берёт textBackgroundOpacity (по умолчанию 0.5), таб-лист — 0x80000000 (~0.502),
// поэтому под условие они не попадают и остаются на месте.
// Если игрок выключит «Фон только для чата», сайдбар возьмёт ту же прозрачность, что чат —
// различить будет нечем, и подложка у него вернётся. Это не поломка, просто вид как раньше.
    if (color.r + color.g + color.b == 0.0
            && (abs(color.a - 76.0 / 255.0) < 0.002 || abs(color.a - 102.0 / 255.0) < 0.002)) {
        discard;
    }
// ------------------------------------------------------------------------------------
    fragColor = color * ColorModulator;
}
