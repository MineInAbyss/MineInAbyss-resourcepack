#version 150

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

int get_id(int offset) {
    if (offset <= 0)
        return 0;
    return int(offset/1000);
}

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

    int id = get_id((int(round(guiSize.y - Position.y)) - ACTIONBAR_OFFSET) * -1);
    
    // Detect if GUI text.
    if (Position.z > 0.0 && Position.z < 0.1 && id != 0 && Color.a != 0.0) {
        pos.y -= int((id*1000) + 500 - ACTIONBAR_OFFSET);
        pos.x -= (guiSize.x * 0.5);

        float yOffset = 0;
        float xOffset = 0;

        switch (id) {
            case 1:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+22;
                break;
            case 2:
                yOffset = int(guiSize.y * (0.0/100))+39;
                xOffset = int(guiSize.x * (-50.0/100))+40;
                break;
            case 3:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+19;
                break;
            case 4:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+16;
                break;
            case 5:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+13;
                break;
            case 6:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+10;
                break;
            case 7:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+7;
                break;
            case 8:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+4;
                break;
            case 9:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))+1;
                break;
            case 10:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-2;
                break;
            case 11:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-5;
                break;
            case 12:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-8;
                break;
            case 13:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-11;
                break;
            case 14:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-14;
                break;
            case 15:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-17;
                break;
            case 16:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-20;
                break;
            case 17:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-23;
                break;
            case 18:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-26;
                break;
            case 19:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-29;
                break;
            case 20:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-32;
                break;
            case 21:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-35;
                break;
            case 22:
                yOffset = int(guiSize.y * (100.0/100))-6;
                xOffset = int(guiSize.x * (-50.0/100))+80;
                break;
            case 23:
                yOffset = int(guiSize.y * (100.0/100))-12;
                xOffset = int(guiSize.x * (-50.0/100))+60;
                break;
            case 24:
                yOffset = int(guiSize.y * (0.0/100))+41;
                xOffset = int(guiSize.x * (-50.0/100))-5;
                break;
            case 25:
                yOffset = int(guiSize.y * (0.0/100))+43;
                xOffset = int(guiSize.x * (-50.0/100))-17;
                break;
            case 26:
                yOffset = int(guiSize.y * (0.0/100))+41;
                xOffset = int(guiSize.x * (-50.0/100))-23;
                break;
            case 27:
                yOffset = int(guiSize.y * (0.0/100))+44;
                xOffset = int(guiSize.x * (-50.0/100))-29;
                break;
            case 28:
                yOffset = int(guiSize.y * (0.0/100))+42;
                xOffset = int(guiSize.x * (-50.0/100))-32;
                break;
            case 29:
                yOffset = int(guiSize.y * (0.0/100))+42;
                xOffset = int(guiSize.x * (-50.0/100))-35;
                break;
            case 30:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+22;
                break;
            case 31:
                yOffset = int(guiSize.y * (0.0/100))+49;
                xOffset = int(guiSize.x * (-50.0/100))+40;
                break;
            case 32:
                yOffset = int(guiSize.y * (-500.0/100));
                xOffset = int(guiSize.x * (-0.0/100));
                break;
            case 33:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+19;
                break;
            case 34:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+16;
                break;
            case 35:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+13;
                break;
            case 36:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+10;
                break;
            case 37:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+7;
                break;
            case 38:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+4;
                break;
            case 39:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))+1;
                break;
            case 40:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-2;
                break;
            case 41:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-5;
                break;
            case 42:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-8;
                break;
            case 43:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-11;
                break;
            case 44:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-14;
                break;
            case 45:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-17;
                break;
            case 46:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-20;
                break;
            case 47:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-23;
                break;
            case 48:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-26;
                break;
            case 49:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-29;
                break;
            case 50:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-32;
                break;
            case 51:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-35;
                break;
            case 52:
                yOffset = int(guiSize.y * (0.0/100))+83;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 53:
                yOffset = int(guiSize.y * (0.0/100))+102;
                xOffset = int(guiSize.x * (-100.0/100))+24;
                break;
            case 54:
                yOffset = int(guiSize.y * (0.0/100))+29;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 55:
                yOffset = int(guiSize.y * (0.0/100))+35;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 56:
                yOffset = int(guiSize.y * (0.0/100))+41;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 57:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 58:
                yOffset = int(guiSize.y * (0.0/100))+53;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 59:
                yOffset = int(guiSize.y * (0.0/100))+59;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 60:
                yOffset = int(guiSize.y * (0.0/100))+65;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 61:
                yOffset = int(guiSize.y * (0.0/100))+71;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 62:
                yOffset = int(guiSize.y * (0.0/100))+77;
                xOffset = int(guiSize.x * (-100.0/100))+22;
                break;
            case 63:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-53;
                break;
            case 64:
                yOffset = int(guiSize.y * (0.0/100))+49;
                xOffset = int(guiSize.x * (-50.0/100))-47;
                break;
            case 65:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-110;
                break;
            case 66:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-107;
                break;
            case 67:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-104;
                break;
            case 68:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-101;
                break;
            case 69:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-98;
                break;
            case 70:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-95;
                break;
            case 71:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-92;
                break;
            case 72:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-89;
                break;
            case 73:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-86;
                break;
            case 74:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-83;
                break;
            case 75:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-80;
                break;
            case 76:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-77;
                break;
            case 77:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-74;
                break;
            case 78:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-71;
                break;
            case 79:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-68;
                break;
            case 80:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-65;
                break;
            case 81:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-62;
                break;
            case 82:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-59;
                break;
            case 83:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-50.0/100))-56;
                break;
            case 84:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-53;
                break;
            case 85:
                yOffset = int(guiSize.y * (0.0/100))+39;
                xOffset = int(guiSize.x * (-50.0/100))-47;
                break;
            case 86:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-110;
                break;
            case 87:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-107;
                break;
            case 88:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-104;
                break;
            case 89:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-101;
                break;
            case 90:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-98;
                break;
            case 91:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-95;
                break;
            case 92:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-92;
                break;
            case 93:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-89;
                break;
            case 94:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-86;
                break;
            case 95:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-83;
                break;
            case 96:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-80;
                break;
            case 97:
                yOffset = int(guiSize.y * (0.0/100))+40;
                xOffset = int(guiSize.x * (-50.0/100))-77;
                break;
            case 98:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-74;
                break;
            case 99:
                yOffset = int(guiSize.y * (0.0/100))+42;
                xOffset = int(guiSize.x * (-50.0/100))-71;
                break;
            case 100:
                yOffset = int(guiSize.y * (0.0/100))+40;
                xOffset = int(guiSize.x * (-50.0/100))-68;
                break;
            case 101:
                yOffset = int(guiSize.y * (0.0/100))+42;
                xOffset = int(guiSize.x * (-50.0/100))-65;
                break;
            case 102:
                yOffset = int(guiSize.y * (0.0/100))+42;
                xOffset = int(guiSize.x * (-50.0/100))-62;
                break;
            case 103:
                yOffset = int(guiSize.y * (0.0/100))+40;
                xOffset = int(guiSize.x * (-50.0/100))-59;
                break;
            case 104:
                yOffset = int(guiSize.y * (0.0/100))+39;
                xOffset = int(guiSize.x * (-50.0/100))-56;
                break;
            case 105:
                yOffset = int(guiSize.y * (0.0/100))+43;
                xOffset = int(guiSize.x * (-50.0/100))-53;
                break;
            case 106:
                yOffset = int(guiSize.y * (0.0/100))+83;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 107:
                yOffset = int(guiSize.y * (0.0/100))+102;
                xOffset = int(guiSize.x * (-100.0/100))+7;
                break;
            case 108:
                yOffset = int(guiSize.y * (0.0/100))+26;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 109:
                yOffset = int(guiSize.y * (0.0/100))+29;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 110:
                yOffset = int(guiSize.y * (0.0/100))+32;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 111:
                yOffset = int(guiSize.y * (0.0/100))+35;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 112:
                yOffset = int(guiSize.y * (0.0/100))+38;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 113:
                yOffset = int(guiSize.y * (0.0/100))+41;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 114:
                yOffset = int(guiSize.y * (0.0/100))+44;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 115:
                yOffset = int(guiSize.y * (0.0/100))+47;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 116:
                yOffset = int(guiSize.y * (0.0/100))+50;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 117:
                yOffset = int(guiSize.y * (0.0/100))+53;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 118:
                yOffset = int(guiSize.y * (0.0/100))+56;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 119:
                yOffset = int(guiSize.y * (0.0/100))+59;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 120:
                yOffset = int(guiSize.y * (0.0/100))+62;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 121:
                yOffset = int(guiSize.y * (0.0/100))+65;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 122:
                yOffset = int(guiSize.y * (0.0/100))+68;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 123:
                yOffset = int(guiSize.y * (0.0/100))+71;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 124:
                yOffset = int(guiSize.y * (0.0/100))+74;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 125:
                yOffset = int(guiSize.y * (0.0/100))+77;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 126:
                yOffset = int(guiSize.y * (0.0/100))+80;
                xOffset = int(guiSize.x * (-100.0/100))+5;
                break;
            case 127:
                yOffset = int(guiSize.y * (100.0/100))-6;
                xOffset = int(guiSize.x * (-50.0/100))-40;
                break;
            case 128:
                yOffset = int(guiSize.y * (100.0/100))-12;
                xOffset = int(guiSize.x * (-50.0/100))-60;
                break;
            case 129:
                yOffset = int(guiSize.y * (0.0/100))+41;
                xOffset = int(guiSize.x * (-50.0/100))-20;
                break;
            case 130:
                yOffset = int(guiSize.y * (0.0/100))+42;
                xOffset = int(guiSize.x * (-50.0/100))-23;
                break;
            case 131:
                yOffset = int(guiSize.y * (0.0/100))+40;
                xOffset = int(guiSize.x * (-50.0/100))-29;
                break;
            case 132:
                yOffset = int(guiSize.y * (0.0/100))+44;
                xOffset = int(guiSize.x * (-50.0/100))-32;
                break;
            case 133:
                yOffset = int(guiSize.y * (0.0/100))+41;
                xOffset = int(guiSize.x * (-50.0/100))-35;
                break;
            case 134:
                yOffset = int(guiSize.y * (0.0/100))+23;
                xOffset = int(guiSize.x * (-50.0/100))-106;
                break;
            case 135:
                yOffset = int(guiSize.y * (0.0/100))+24;
                xOffset = int(guiSize.x * (-50.0/100))-105;
                break;
            case 136:
                yOffset = int(guiSize.y * (0.0/100))+10;
                xOffset = int(guiSize.x * (-50.0/100))-110;
                break;
            case 137:
                yOffset = int(guiSize.y * (100.0/100))-10;
                xOffset = int(guiSize.x * (-50.0/100));
                break;
            case 138:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-9;
                break;
            case 139:
                yOffset = int(guiSize.y * (0.0/100))+40;
                xOffset = int(guiSize.x * (-50.0/100))+3;
                break;
            case 140:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-16;
                break;
            case 141:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-23;
                break;
            case 142:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-30;
                break;
            case 143:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-37;
                break;
            case 144:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-44;
                break;
            case 145:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-51;
                break;
            case 146:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-58;
                break;
            case 147:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-65;
                break;
            case 148:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-72;
                break;
            case 149:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-79;
                break;
            case 150:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-86;
                break;
            case 151:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-93;
                break;
            case 152:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-100;
                break;
            case 153:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-107;
                break;
            case 154:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-114;
                break;
            case 155:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-121;
                break;
            case 156:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-128;
                break;
            case 157:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-135;
                break;
            case 158:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-142;
                break;
            case 159:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-149;
                break;
            case 160:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-156;
                break;
            case 161:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-163;
                break;
            case 162:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-170;
                break;
            case 163:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-177;
                break;
            case 164:
                yOffset = int(guiSize.y * (0.0/100))+27;
                xOffset = int(guiSize.x * (-50.0/100))-184;
                break;
            case 165:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-77;
                break;
            case 166:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-71;
                break;
            case 167:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-68;
                break;
            case 168:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-65;
                break;
            case 169:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-62;
                break;
            case 170:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-59;
                break;
            case 171:
                yOffset = int(guiSize.y * (0.0/100))+37;
                xOffset = int(guiSize.x * (-50.0/100))-56;
                break;
            case 172:
                yOffset = int(guiSize.y * (0.0/100))+70;
                xOffset = int(guiSize.x * (-50.0/100));
                break;
        }

        pos -= vec3(xOffset, yOffset, 0.0);
    }

    int vID = gl_VertexID % 4;
    int offset = int(round(guiSize.y - Position.y));

    if(Position.z == 0.0 // z location is always 0
    && ((length(Color.rgb - vec3(0.501, 1.0, 0.125)) < 0.002 && (isAt(offset, vID, 26) || isAt(offset, vID, 27))) // the bright text starts 27 pixels from the bottom, sometimes at 26
    || (length(Color.rgb - vec3(0.0, 0.0, 0.0)) < 0.002 && (isAt(offset, vID, 25) || isAt(offset, vID, 26) || isAt(offset, vID, 27) || isAt(offset, vID, 28))))) { // the darker background consists out of 3 elements (26,27,28), sometimes (25,26,27)

        /** Reposition (Remove up to Reposition End if unnecessary)**/
        pos += vec3(0.0,0.0,0.0); // apply an offset
        /* Reposition End */

        /** Recolor (Remove up to Recolor End if unnecessary)**/
        if(length(Color.rgb - vec3(0.0, 0.0, 0.0)) < 0.002) {
            vertexColor = vec4(0.4431, 0.3294, 0, 0); // shadow (usually black)
        } else {
            vertexColor = vec4(0.8784, 0.6627, 0, 0); // text (usually green)
        }
        /* Recolor End */

    }

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1);
}
