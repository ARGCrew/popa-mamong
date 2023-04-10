function onCreatePost()
    local sprite = luaSprite(10, getClassProperty("flixel.FlxG", "height") / 2)
    spriteLoadGraphic(sprite, "buttons/SQUARE")
    add(sprite)

    local text = luaText(10, 10, 1280, "Text", 128)
    textSetFormat(text, 128, "0xffFFFFFF", "left", "none", "0x00000000")
    add(text)

    local tween = nil
    local timer = runTimer(1, function()
        tween = doTween(sprite, {x = 100, alpha = 0}, 1)
    end)
end

function onTimerCompleted(tmr)
    if (tmr == timer) then
        tween = doTween(sprite, {x = 100, alpha = 0}, 1)
    end
end

-- как вы поняли таймеры каким-то хером не работают, даже через onTimerCompleted