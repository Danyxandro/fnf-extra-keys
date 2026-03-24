package shaders;

import flixel.system.FlxAssets.FlxShader;

class SolidColorShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform vec4 uColor;

        void main()
        {
            // Samplea la textura original para obtener el alpha
            vec4 tex = flixel_texture2D(bitmap, openfl_TextureCoordv);

            // Si el pixel es completamente transparente, descartarlo
            if (tex.a == 0.0)
            {
                gl_FragColor = vec4(0.0);
                return;
            }

            // Aplica el color solido conservando el alpha original del sprite
            gl_FragColor = vec4(uColor.r * tex.a, uColor.g * tex.a, uColor.b * tex.a, uColor.a * tex.a);
        }
    ')

    public function new()
    {
        super();
    }

    public function setColor(red:Int, green:Int, blue:Int):Void
    {
        var rgb:Array<Float> = [1.0,1.0,1.0];
        rgb[0] = red / 255;
        rgb[1] = green / 255;
        rgb[2] = blue / 255;
        if(red > 255)
            rgb[0] = 1;
        if(red < 0)
            rgb[0] = 0;
        if(green > 255)
            rgb[1] = 1;
        if(green < 0)
            rgb[1] = 0;
        if(blue > 255)
            rgb[2] = 1;
        if(blue < 0)
            rgb[2] = 0;
        uColor.value = [rgb[0], rgb[1], rgb[2],1.0];
    }
}
