#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

// change this variable name to your Edition's name
// YOU MUST USE THIS VARIABLE IN THE vec4 effect AT LEAST ONCE
// ^^ CRITICALLY IMPORTANT (IDK WHY)
extern MY_HIGHP_OR_MEDIUMP vec2 fluorescent;

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

// the following four vec4 are (as far as I can tell) required and shouldn't be changed

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    
    vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

number hue(number s, number t, number h)
{
    number hs = mod(h, 1.)*6.;
    if (hs < 1.) return (t-s) * hs + s;
    if (hs < 3.) return t;
    if (hs < 4.) return (t-s) * (4.-hs) + s;
    return s;
}

vec4 RGB(vec4 c)
{
    if (c.y < 0.0001)
        return vec4(vec3(c.z), c.a);

    number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
    number s = 2.0 * c.z - t;
    return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
    number low = min(c.r, min(c.g, c.b));
    number high = max(c.r, max(c.g, c.b));
    number delta = high - low;
    number sum = high+low;

    vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
    if (delta == .0)
        return hsl;

    hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

    if (high == c.r)
        hsl.x = (c.g - c.b) / delta;
    else if (high == c.g)
        hsl.x = (c.b - c.r) / delta + 2.0;
    else
        hsl.x = (c.r - c.g) / delta + 4.0;

    hsl.x = mod(hsl.x / 6., 1.);
    return hsl;
}

vec4 saturate(vec4 color, float saturation) {
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    vec3 saturatedColor = mix(vec3(gray), color.rgb, saturation);

    return vec4(saturatedColor, color.a);
}

// Lighten blending mode
vec4 lighten(vec4 colour1, vec4 colour2) {
    vec4 result;
    result.r = max(colour1.r, colour2.r);
    result.g = max(colour1.g, colour2.g);
    result.b = max(colour1.b, colour2.b);
    result.a = max(colour1.a, colour2.a);
    return result;
}

// Overlay blending mode
vec4 overlay(vec4 baseColor, vec4 blendColor) {
    vec3 result;

    for (int i = 0; i < 3; i++) {
        if (baseColor[i] < 0.5) {
            result[i] = 2.0 * baseColor[i] * blendColor[i];
        } else {
            result[i] = 1.0 - 2.0 * (1.0 - baseColor[i]) * (1.0 - blendColor[i]);
        }
    }

    vec3 blendedRGB = mix(baseColor.rgb, result, 1.0);
    return vec4(blendedRGB, baseColor.a);
}

// White-to-color blending mode
vec4 rewhite(vec4 baseColor, vec4 blendColor) {
    float whiteness = (baseColor.r + baseColor.g + baseColor.b) / 3.0;

    float blendFactor = whiteness;

    vec3 blendedRGB = mix(baseColor.rgb, blendColor.rgb, blendFactor);

    return vec4(blendedRGB, baseColor.a);
}

// Hue blending mode (3 functions)
vec4 rgb2hsv(vec4 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec4(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x, c.a);
}

vec4 hsv2rgb(vec4 c) {
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return vec4(c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y), c.a);
}

vec4 hueBlend(vec4 baseColor, vec4 blendColor) {
    vec4 baseHSV = rgb2hsv(baseColor);
    vec4 blendHSV = rgb2hsv(blendColor);

    baseHSV.x = blendHSV.x;  // Replace hue

    vec4 resultRGB = hsv2rgb(baseHSV);
    return vec4(resultRGB.rgb, baseColor.a);
}

// Hueshift
vec4 hueShift(vec4 color, float shift) {
    vec4 hsv = rgb2hsv(color);

    hsv.x = mod(hsv.x + shift, 1.0);

    vec4 resultRGB = hsv2rgb(hsv);
    return vec4(resultRGB.rgb, color.a);
}

// Colorburn blending mode
vec4 colorBurn(vec4 baseColor, vec4 blendColor) {
    vec3 result;

    for(int i = 0; i < 3; i++) {
        if (blendColor[i] == 0.0) {
            result[i] = 0.0;
        } else {
            result[i] = 1.0 - (1.0 - baseColor[i]) / blendColor[i];
        }
    }

    return vec4(result, baseColor.a);
}

// this is what actually changes the look of card
vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // turns the texture into pixels
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    // Dummy, doesn't do anything but at least it makes the shader useable
    if (uv.x > uv.x * 2){
        uv = fluorescent;
    }

    float mod = fluorescent.r * 1.0;

    // From negative shader
    number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
	number delta = high-low -0.1;

    number fac = 0.8 + 0.9*sin(11.*uv.x+4.32*uv.y + mod*12. + cos(mod*5.3 + uv.y*4.2 - uv.x*4.));
    number fac2 = 0.5 + 0.5*sin(8.*uv.x+2.32*uv.y + mod*5. - cos(mod*2.3 + uv.x*8.2));
    number fac3 = 0.5 + 0.5*sin(10.*uv.x+5.32*uv.y + mod*6.111 + sin(mod*5.3 + uv.y*3.2));
    number fac4 = 0.5 + 0.5*sin(3.*uv.x+2.32*uv.y + mod*8.111 + sin(mod*1.3 + uv.y*11.2));
    number fac5 = sin(0.9*16.*uv.x+5.32*uv.y + mod*12. + cos(mod*5.3 + uv.y*4.2 - uv.x*4.));

    number maxfac = (0.7*max(max(fac, max(fac2, max(fac3,0.0))) + (fac+fac2+fac3*fac4), 0.)) - 0.5;

    // Actual shader
    vec4 white = vec4(1.0,1.0,1.0,1.0);
    vec4 black = vec4(0.0,0.0,0.0,1.0);
    vec4 jokerblack = vec4(0.31,0.388,0.404,1.0);

    vec4 final = tex;
    final.rgb = (final.rgb - 1.0) * -1.0; // Invert

    vec4 burned = tex;

    burned = hueShift(tex / 2.0, 0.32); // Burn color hue-shifted
    final = colorBurn(final, burned); // Burn the color

    final = hueBlend(final, tex); // Restore the original hue
    final.r += final.r + final.r;

    vec4 rewhited = rewhite(tex, tex / 1.2) / 0.9;
    rewhited = rgb2hsv(rewhited);
    rewhited.y /= 3.0;
    rewhited = hsv2rgb(rewhited);

    final += rewhited; // Various contrast & jokerblack tweaks
    final += tex * 0.15;
    final = lighten(final, jokerblack + tex * 0.3);

    final.a = tex.a; // Restore alpha

    // required
    return dissolve_mask(final, texture_coords, uv);
}

// for transforming the card while your mouse is on it
extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif