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

#define ACTIONBAR_OFFSET 64

// Function to convert a vertical ascent into a ID.
float get_id(float offset) {
    if (offset <= 0)
        return 0;
    return trunc(offset/1000);
}

// EXP Number function
bool isAt(int offset, int vID, int pos) {
    return (((vID == 1 || vID == 2) && offset == pos) || ((vID == 0 || vID == 3) && offset == (pos+8)));
}


void main() {
    vec3 pos = Position;

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color;
    texCoord0 = UV0;

    vec2 pixel = vec2(ProjMat[0][0], ProjMat[1][1]) / 2.0;
    int guiScale = int(round(pixel.x / (1 / ScreenSize.x)));
    vec2 guiSize = ScreenSize / guiScale;
    int vID = gl_VertexID % 4;
    int offset = int(round(guiSize.y - Position.y));

    float id = get_id((round(guiSize.y - Position.y + ACTIONBAR_OFFSET)) * -1);
    
    // Detect if GUI text.
    if (id > 99 && Color.a != 0.0) {
        pos.y -= (id*1000) + 500 - ACTIONBAR_OFFSET;
        pos.x -= (guiSize.x * 0.5);

        float yOffset = 0;
        float xOffset = 0;
        int layer = 0;
        bool outlined = false;

        switch (int(id)) {
            case 100:
                xOffset = int(guiSize.x * (-50.0/100))+135;
                yOffset = int(guiSize.y * (0.0/100))+24;
                layer = 1;
                break;
            case 101:
                xOffset = int(guiSize.x * (-50.0/100))+137;
                yOffset = int(guiSize.y * (0.0/100))+24;
                layer = 2;
                outlined = true;
                break;
            case 102:
                xOffset = int(guiSize.x * (-50.0/100))+137;
                yOffset = int(guiSize.y * (0.0/100))+27;
                layer = 2;
                outlined = true;
                break;
            case 103:
                xOffset = int(guiSize.x * (-50.0/100))+135;
                yOffset = int(guiSize.y * (0.0/100))+10;
                layer = 1;
                break;
            case 104:
                xOffset = int(guiSize.x * (-50.0/100))+137;
                yOffset = int(guiSize.y * (0.0/100))+10;
                layer = 2;
                outlined = true;
                break;
            case 105:
                xOffset = int(guiSize.x * (-50.0/100))+137;
                yOffset = int(guiSize.y * (0.0/100))+13;
                layer = 2;
                outlined = true;
                break;
            case 106:
                xOffset = int(guiSize.x * (-50.0/100))-65;
                yOffset = int(guiSize.y * (100.0/100))-8;
                layer = 1;
                break;
            case 107:
                xOffset = int(guiSize.x * (-50.0/100))-85;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 2;
                break;
            case 108:
                xOffset = int(guiSize.x * (-50.0/100))+60;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 1;
                break;
            case 109:
                xOffset = int(guiSize.x * (-50.0/100))+80;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 1;
                break;
            case 110:
                xOffset = int(guiSize.x * (-50.0/100))+72;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 1;
                break;
            case 111:
                xOffset = int(guiSize.x * (-50.0/100))+100;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 1;
                break;
            case 112:
                xOffset = int(guiSize.x * (-50.0/100))+108;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 1;
                break;
            case 113:
                xOffset = int(guiSize.x * (-50.0/100))+105;
                yOffset = int(guiSize.y * (0.0/100))+22;
                layer = 1;
                break;
            case 114:
                xOffset = int(guiSize.x * (-50.0/100))+107;
                yOffset = int(guiSize.y * (0.0/100))+22;
                layer = 2;
                outlined = true;
                break;
            case 115:
                xOffset = int(guiSize.x * (-50.0/100))+107;
                yOffset = int(guiSize.y * (0.0/100))+25;
                layer = 2;
                outlined = true;
                break;
            case 116:
                xOffset = int(guiSize.x * (-50.0/100))+105;
                yOffset = int(guiSize.y * (0.0/100))+10;
                layer = 1;
                break;
            case 117:
                xOffset = int(guiSize.x * (-50.0/100))+107;
                yOffset = int(guiSize.y * (0.0/100))+10;
                layer = 2;
                outlined = true;
                break;
            case 118:
                xOffset = int(guiSize.x * (-50.0/100))+107;
                yOffset = int(guiSize.y * (0.0/100))+13;
                layer = 2;
                outlined = true;
                break;
            case 119:
                xOffset = int(guiSize.x * (-50.0/100))+140;
                yOffset = int(guiSize.y * (100.0/100))-12;
                layer = 1;
                break;
            case 120:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+83;
                layer = 1;
                break;
            case 121:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+27;
                layer = 2;
                break;
            case 122:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+32;
                layer = 2;
                break;
            case 123:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+36;
                layer = 2;
                break;
            case 124:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+41;
                layer = 2;
                break;
            case 125:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+46;
                layer = 2;
                break;
            case 126:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+50;
                layer = 2;
                break;
            case 127:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+55;
                layer = 2;
                break;
            case 128:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+59;
                layer = 2;
                break;
            case 129:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+64;
                layer = 2;
                break;
            case 130:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+69;
                layer = 2;
                break;
            case 131:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+73;
                layer = 2;
                break;
            case 132:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+78;
                layer = 2;
                break;
            case 133:
                xOffset = int(guiSize.x * (-100.0/100))+26;
                yOffset = int(guiSize.y * (0.0/100))+83;
                layer = 2;
                break;
            case 134:
                xOffset = int(guiSize.x * (-100.0/100))+28;
                yOffset = int(guiSize.y * (0.0/100))+102;
                layer = 3;
                break;
            case 135:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+83;
                layer = 1;
                break;
            case 136:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+27;
                layer = 2;
                break;
            case 137:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+32;
                layer = 2;
                break;
            case 138:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+36;
                layer = 2;
                break;
            case 139:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+41;
                layer = 2;
                break;
            case 140:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+46;
                layer = 2;
                break;
            case 141:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+50;
                layer = 2;
                break;
            case 142:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+55;
                layer = 2;
                break;
            case 143:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+59;
                layer = 2;
                break;
            case 144:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+64;
                layer = 2;
                break;
            case 145:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+69;
                layer = 2;
                break;
            case 146:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+73;
                layer = 2;
                break;
            case 147:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+78;
                layer = 2;
                break;
            case 148:
                xOffset = int(guiSize.x * (-100.0/100))+12;
                yOffset = int(guiSize.y * (0.0/100))+83;
                layer = 2;
                break;
            case 149:
                xOffset = int(guiSize.x * (-100.0/100))+14;
                yOffset = int(guiSize.y * (0.0/100))+102;
                layer = 3;
                break;
            case 150:
                xOffset = int(guiSize.x * (-50.0/100))-15;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 1;
                break;
            case 151:
                xOffset = int(guiSize.x * (-50.0/100))-15;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 152:
                xOffset = int(guiSize.x * (-50.0/100))+3;
                yOffset = int(guiSize.y * (0.0/100))+42;
                layer = 3;
                break;
            case 153:
                xOffset = int(guiSize.x * (-50.0/100))-10;
                yOffset = int(guiSize.y * (1.0/100))+27;
                layer = 1;
                break;
            case 154:
                xOffset = int(guiSize.x * (-50.0/100))+2;
                yOffset = int(guiSize.y * (1.0/100))+40;
                layer = 2;
                break;
            case 155:
                xOffset = int(guiSize.x * (-50.0/100))-10;
                yOffset = int(guiSize.y * (1.0/100))+27;
                layer = 3;
                break;
            case 156:
                xOffset = int(guiSize.x * (-50.0/100))-6;
                yOffset = int(guiSize.y * (1.0/100))+36;
                layer = 4;
                outlined = true;
                break;
            case 157:
                xOffset = int(guiSize.x * (-50.0/100))-6;
                yOffset = int(guiSize.y * (1.0/100))+39;
                layer = 4;
                outlined = true;
                break;
            case 158:
                xOffset = int(guiSize.x * (-50.0/100))-20;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 1;
                break;
            case 159:
                xOffset = int(guiSize.x * (-50.0/100))-78;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 160:
                xOffset = int(guiSize.x * (-50.0/100))-75;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 161:
                xOffset = int(guiSize.x * (-50.0/100))-72;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 162:
                xOffset = int(guiSize.x * (-50.0/100))-69;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 163:
                xOffset = int(guiSize.x * (-50.0/100))-66;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 164:
                xOffset = int(guiSize.x * (-50.0/100))-63;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 165:
                xOffset = int(guiSize.x * (-50.0/100))-60;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 166:
                xOffset = int(guiSize.x * (-50.0/100))-57;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 167:
                xOffset = int(guiSize.x * (-50.0/100))-54;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 168:
                xOffset = int(guiSize.x * (-50.0/100))-51;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 169:
                xOffset = int(guiSize.x * (-50.0/100))-48;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 170:
                xOffset = int(guiSize.x * (-50.0/100))-45;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 171:
                xOffset = int(guiSize.x * (-50.0/100))-42;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 172:
                xOffset = int(guiSize.x * (-50.0/100))-39;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 173:
                xOffset = int(guiSize.x * (-50.0/100))-36;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 174:
                xOffset = int(guiSize.x * (-50.0/100))-33;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 175:
                xOffset = int(guiSize.x * (-50.0/100))-30;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 176:
                xOffset = int(guiSize.x * (-50.0/100))-27;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 177:
                xOffset = int(guiSize.x * (-50.0/100))-24;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 178:
                xOffset = int(guiSize.x * (-50.0/100))-21;
                yOffset = int(guiSize.y * (0.0/100))+40;
                layer = 2;
                break;
            case 179:
                xOffset = int(guiSize.x * (-50.0/100))-15;
                yOffset = int(guiSize.y * (0.0/100))+42;
                layer = 3;
                break;
            case 180:
                xOffset = int(guiSize.x * (-50.0/100));
                yOffset = int(guiSize.y * (100.0/100))-6;
                layer = 1;
                break;
            case 181:
                xOffset = int(guiSize.x * (-50.0/100));
                yOffset = int(guiSize.y * (0.0/100))+75;
                layer = 0;
                outlined = true;
                break;
            case 182:
                xOffset = int(guiSize.x * (-50.0/100));
                yOffset = int(guiSize.y * (0.0/100))+78;
                layer = 0;
                outlined = true;
                break;
            case 183:
                xOffset = int(guiSize.x * (-50.0/100));
                yOffset = int(guiSize.y * (0.0/100))+75;
                layer = 100;
                outlined = true;
                break;
        }

        if (Position.z != 0.0 || outlined) {
            pos -= vec3(xOffset, yOffset, 0.0);
            pos.z += layer;
        }

    }

    // offset xp text
    if(Position.z == 0.0 // z location is always 0 
        && ((length(Color.rgb - vec3(0.501, 1.0, 0.125)) < 0.002 && (isAt(offset, vID, 26) || isAt(offset, vID, 27))) // the bright text starts 27 pixels from the bottom, sometimes at 26
        || (length(Color.rgb - vec3(0.0, 0.0, 0.0)) < 0.002 && (isAt(offset, vID, 25) || isAt(offset, vID, 26) || isAt(offset, vID, 27) || isAt(offset, vID, 28))))) { // the darker background consists out of 3 elements (26,27,28), sometimes (25,26,27)
        
        /** Reposition (Remove up to Reposition End if unnecessary)**/
        pos = vec3(0.0,0.0,0.0); // apply an offset
        /* Reposition End */
          
    }
    
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
}
