package;

import flixel.FlxG;
import flixel.FlxSprite;

class MegaSprite extends FlxSprite
{
    public function new()
    {
        super(0, 0);
        init();
    }

    function init()
    {
        create();
    }

    function create()
    {
        this.frames = FlxG.bitmap.create(100, 200, 0xffFFFFFF).imageFrame;
        this.setGraphicSize(Std.int(this.width), Std.int(this.height));
        this.scale.x = 1;
        this.scale.y = 1;
        this.scrollFactor.x = 1;
        this.scrollFactor.y = 1;
        this.cameras = [FlxG.camera];
        this.antialiasing = false;
        this.dirty = true;
        this.angle = 0;
        this.acceleration.x = 0;
        this.acceleration.y = 0;
        this.velocity.x = 0;
        this.velocity.y = 0;
        this.visible = true;
        this.alpha = 1;
        this.flipX = false;
        this.flipY = false;
        this.color = 0xffFFFFFF;
        this.shader = null;
        this.width = Math.abs(this.scale.x) * this.frameWidth;
        this.height = Math.abs(this.scale.y) * this.frameHeight;
        this.offset.x = -0.5 * (this.width - this.frameWidth);
        this.offset.y = -0.5 * (this.height - this.frameHeight);
        this.origin.x = this.frameWidth * 0.5;
        this.origin.y = this.frameHeight * 0.5;
        this.x = 0;
        this.y = 0;
    }
}