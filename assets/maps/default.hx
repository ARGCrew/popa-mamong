function create()
{
    import('flixel.FlxSprite');
    import('flixel.FlxG');
    import('flixel.utils.FlxColor');

    this.add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE));
}