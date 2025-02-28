package shaders;

import flixel.system.FlxAssets.FlxShader;

class SolidColorShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header
        
        uniform float iGreen = 0.2;
        uniform float iRed = 0.3;
        uniform float iBlue = 0.1;
        void main()
        {
            vec4 texColor = texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4(iRed*texColor.a,iGreen*texColor.a,iBlue*texColor.a,texColor.a);
        }
    ')
    
    public function new()
    {
        super();
    }

    public function setColor(red:Int,green:Int,blue:Int){
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
        iRed.value = [rgb[0]];
        iGreen.value = [rgb[1]];
        iBlue.value = [rgb[2]];
    }
}
