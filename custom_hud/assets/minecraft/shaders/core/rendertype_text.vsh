#version 110

#moj_import <fog.glsl>
#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

#define HH_VERSION 3
#define HH_OFFSET 67

// Function to convert a vertical ascent into a ID.
float get_id(float offset) {
    if (offset <= 0.0)
        return 0.0;
    return trunc(offset/1000.0);
}

void main() {
    vec3 pos = Position;

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color;
    texCoord0 = UV0;

    vec2 pixel = vec2(ProjMat[0][0], ProjMat[1][1]) / 2.0;
    int guiScale = int(round(pixel.x / (1 / ScreenSize.x)));
    vec2 guiSize = ScreenSize / guiScale;

    float id = get_id((round(HH_OFFSET - Position.y)) * -1);

    // Detect if GUI text.
    if (id > 99 && Color.a != 0.0) {
        float yOffset = 0.0;
        float xOffset = 0.0;
        int layer = 0;
        vec2 scale = vec2(1, 1);
        bool outlined = false;

        switch (int(id)) {
            case 100:
                xOffset = int(guiSize.x * (-50.0/100))+50;
                yOffset = int(guiSize.y * (0.0/100))+51;
                layer = 1;
                break;
            case 101:
                xOffset = int(guiSize.x * (-50.0/100))+33;
                yOffset = int(guiSize.y * (0.0/100))+48;
                layer = 2;
                break;
            case 102:
                xOffset = int(guiSize.x * (-50.0/100))-34;
                yOffset = int(guiSize.y * (0.0/100))+41;
                layer = 1;
                break;
            case 103:
                xOffset = int(guiSize.x * (-50.0/100))-108;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 104:
                xOffset = int(guiSize.x * (-50.0/100))-105;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 105:
                xOffset = int(guiSize.x * (-50.0/100))-102;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 106:
                xOffset = int(guiSize.x * (-50.0/100))-99;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 107:
                xOffset = int(guiSize.x * (-50.0/100))-96;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 108:
                xOffset = int(guiSize.x * (-50.0/100))-93;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 109:
                xOffset = int(guiSize.x * (-50.0/100))-90;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 110:
                xOffset = int(guiSize.x * (-50.0/100))-87;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 111:
                xOffset = int(guiSize.x * (-50.0/100))-84;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 112:
                xOffset = int(guiSize.x * (-50.0/100))-81;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 113:
                xOffset = int(guiSize.x * (-50.0/100))-78;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 114:
                xOffset = int(guiSize.x * (-50.0/100))-75;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 115:
                xOffset = int(guiSize.x * (-50.0/100))-72;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 116:
                xOffset = int(guiSize.x * (-50.0/100))-69;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 117:
                xOffset = int(guiSize.x * (-50.0/100))-66;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 118:
                xOffset = int(guiSize.x * (-50.0/100))-63;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 119:
                xOffset = int(guiSize.x * (-50.0/100))-60;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 120:
                xOffset = int(guiSize.x * (-50.0/100))-57;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 121:
                xOffset = int(guiSize.x * (-50.0/100))-54;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 122:
                xOffset = int(guiSize.x * (-50.0/100))-51;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 123:
                xOffset = int(guiSize.x * (-50.0/100))+50;
                yOffset = int(guiSize.y * (0.0/100))+41;
                layer = 1;
                break;
            case 124:
                xOffset = int(guiSize.x * (-50.0/100))+33;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 125:
                xOffset = int(guiSize.x * (-50.0/100));
                yOffset = int(guiSize.y * (100.0/100))-2;
                layer = 1;
                break;
            case 126:
                xOffset = int(guiSize.x * (-50.0/100))-65;
                yOffset = int(guiSize.y * (100.0/100))-2;
                layer = 1;
                break;
            case 127:
                xOffset = int(guiSize.x * (-50.0/100))-85;
                yOffset = int(guiSize.y * (100.0/100))-6;
                layer = 2;
                break;
            case 128:
                scale.x = 2.0;
                scale.y = 1.4;
                xOffset = int(guiSize.x * (-50.0/100));
                yOffset = int(guiSize.y * (100.0/100));
                layer = 1;
                break;
            case 129:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+104;
                layer = 1;
                break;
            case 130:
                xOffset = int(guiSize.x * (-50.0/100))-13;
                yOffset = int(guiSize.y * (0.0/100))+49;
                layer = 1;
                break;
            case 131:
                xOffset = int(guiSize.x * (-50.0/100))+52;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 1;
                break;
            case 132:
                xOffset = int(guiSize.x * (-50.0/100))+110;
                yOffset = int(guiSize.y * (0.0/100))+31;
                layer = 1;
                break;
            case 133:
                xOffset = int(guiSize.x * (-50.0/100))+123;
                yOffset = int(guiSize.y * (0.0/100))+31;
                layer = 1;
                break;
            case 134:
                xOffset = int(guiSize.x * (-50.0/100))+100;
                yOffset = int(guiSize.y * (100.0/100));
                layer = 1;
                break;
            case 135:
                xOffset = int(guiSize.x * (-50.0/100))+100;
                yOffset = int(guiSize.y * (100.0/100))-6;
                layer = 2;
                break;
            case 136:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (100.0/100));
                layer = 1;
                break;
            case 137:
                xOffset = int(guiSize.x * (-50.0/100))+100;
                yOffset = int(guiSize.y * (100.0/100))-3;
                layer = 2;
                break;
            case 138:
                xOffset = int(guiSize.x * (-50.0/100))+150;
                yOffset = int(guiSize.y * (100.0/100));
                layer = 1;
                break;
            case 139:
                xOffset = int(guiSize.x * (-50.0/100))+130;
                yOffset = int(guiSize.y * (100.0/100))-6;
                layer = 2;
                break;
            case 140:
                xOffset = int(guiSize.x * (-50.0/100))+130;
                yOffset = int(guiSize.y * (100.0/100))-3;
                layer = 2;
                break;
            case 141:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (0.0/100))+26;
                layer = 1;
                break;
            case 142:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (0.0/100))+27;
                layer = 1;
                break;
            case 143:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (0.0/100))+24;
                layer = 1;
                break;
            case 144:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (0.0/100))+12;
                layer = 1;
                break;
            case 145:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (0.0/100))+13;
                layer = 1;
                break;
            case 146:
                xOffset = int(guiSize.x * (-50.0/100))+120;
                yOffset = int(guiSize.y * (0.0/100))+10;
                layer = 1;
                break;
            case 147:
                xOffset = int(guiSize.x * (-50.0/100))+95;
                yOffset = int(guiSize.y * (0.0/100))+26;
                layer = 1;
                break;
            case 148:
                xOffset = int(guiSize.x * (-50.0/100))+95;
                yOffset = int(guiSize.y * (0.0/100))+27;
                layer = 1;
                break;
            case 149:
                xOffset = int(guiSize.x * (-50.0/100))+95;
                yOffset = int(guiSize.y * (0.0/100))+24;
                layer = 1;
                break;
            case 150:
                xOffset = int(guiSize.x * (-50.0/100))+95;
                yOffset = int(guiSize.y * (0.0/100))+12;
                layer = 1;
                break;
            case 151:
                xOffset = int(guiSize.x * (-50.0/100))+95;
                yOffset = int(guiSize.y * (0.0/100))+13;
                layer = 1;
                break;
            case 152:
                xOffset = int(guiSize.x * (-50.0/100))+95;
                yOffset = int(guiSize.y * (0.0/100))+10;
                layer = 1;
                break;
            case 153:
                xOffset = int(guiSize.x * (-50.0/100))-53;
                yOffset = int(guiSize.y * (0.0/100))+47;
                layer = 1;
                break;
            case 154:
                xOffset = int(guiSize.x * (-50.0/100))-47;
                yOffset = int(guiSize.y * (0.0/100))+50;
                layer = 2;
                break;
            case 155:
                xOffset = int(guiSize.x * (-50.0/100))-110;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 156:
                xOffset = int(guiSize.x * (-50.0/100))-107;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 157:
                xOffset = int(guiSize.x * (-50.0/100))-104;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 158:
                xOffset = int(guiSize.x * (-50.0/100))-101;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 159:
                xOffset = int(guiSize.x * (-50.0/100))-98;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 160:
                xOffset = int(guiSize.x * (-50.0/100))-95;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 161:
                xOffset = int(guiSize.x * (-50.0/100))-92;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 162:
                xOffset = int(guiSize.x * (-50.0/100))-89;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 163:
                xOffset = int(guiSize.x * (-50.0/100))-86;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 164:
                xOffset = int(guiSize.x * (-50.0/100))-83;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 165:
                xOffset = int(guiSize.x * (-50.0/100))-80;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 166:
                xOffset = int(guiSize.x * (-50.0/100))-77;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 167:
                xOffset = int(guiSize.x * (-50.0/100))-74;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 168:
                xOffset = int(guiSize.x * (-50.0/100))-71;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 169:
                xOffset = int(guiSize.x * (-50.0/100))-68;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 170:
                xOffset = int(guiSize.x * (-50.0/100))-65;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 171:
                xOffset = int(guiSize.x * (-50.0/100))-62;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 172:
                xOffset = int(guiSize.x * (-50.0/100))-59;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 173:
                xOffset = int(guiSize.x * (-50.0/100))-56;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 174:
                xOffset = int(guiSize.x * (-50.0/100))-53;
                yOffset = int(guiSize.y * (0.0/100))+54;
                layer = 3;
                break;
            case 175:
                xOffset = int(guiSize.x * (-100.0/100))+22;
                yOffset = int(guiSize.y * (0.0/100))+102;
                layer = 1;
                break;
            case 176:
                xOffset = int(guiSize.x * (-100.0/100))+20;
                yOffset = int(guiSize.y * (0.0/100))+83;
                layer = 2;
                break;
            case 177:
                xOffset = int(guiSize.x * (-100.0/100))+10;
                yOffset = int(guiSize.y * (0.0/100))+102;
                layer = 1;
                break;
            case 178:
                xOffset = int(guiSize.x * (-100.0/100))+3;
                yOffset = int(guiSize.y * (0.0/100))+83;
                layer = 2;
                break;
            case 179:
                xOffset = int(guiSize.x * (-50.0/100))-2;
                yOffset = int(guiSize.y * (0.0/100))+32;
                layer = 1;
                break;
            case 180:
                xOffset = int(guiSize.x * (-50.0/100))-182;
                yOffset = int(guiSize.y * (0.0/100))+38;
                layer = 2;
                break;
            case 181:
                xOffset = int(guiSize.x * (-50.0/100))-8;
                yOffset = int(guiSize.y * (0.0/100))+29;
                layer = 3;
                break;
        }

        // -90.0 is required for forge comp
        if ((Position.z != 0.0 && Position.z != -90.0) || outlined) {
            pos.y -= (id*1000) + 500 + HH_OFFSET;
            pos.x -= (guiSize.x * 0.5);

            pos.x *= scale.x;
            pos.y *= scale.y;

            pos.y += guiSize.y;
            // force align guiScale 3
            if (guiScale == 3) {
                pos.x += 1.45;
            }

            pos -= vec3(xOffset, yOffset, 0.0);
            pos.z += layer;
        }
    } 	

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1);
}
