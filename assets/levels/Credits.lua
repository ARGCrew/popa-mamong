function onCreatePost()
    local sprite = luaSprite(10, getClassProperty("flixel.FlxG", "height") / 2)
    spriteLoadGraphic(sprite, "buttons/SQUARE")
    add(sprite)

    local text = luaText(10, 10, 1280, "Text", 128)
    textSetFormat(text, 128, "0xffFFFFFF", "left", "none", "0x00000000")
    add(text)

    local tween = doTween(sprite, {x = 100}, 1, {onComplete = "onTweenComplete"})
end

function onTweenComplete()
    doTween(sprite, {x = 10}, 1)
end