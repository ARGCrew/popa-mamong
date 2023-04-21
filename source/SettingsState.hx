package;

import flixel.tweens.FlxTween;
import controls.Controls.Control;
import controls.Controls.KeyboardScheme;
import UIButtons;
import flixel.FlxG;

class SettingsState extends MusicBeatState {
    var daPlaying:Bool;

    public static var instance:SettingsState;

    public static var curCata:Int = 0;
    public static var catas:Array<SettingsCata> = [];

    public var cataButtons:Array<UIButton> = [];

    public function new(game:Bool) {
        super(false);
        daPlaying = game;

        instance = this;
        persistentDraw = persistentUpdate = true;
    }

    override function create() {
        #if desktop
        changePresence("Settings Menu", null);
        #end

        catas = [
            new SettingsCata(210, 10, "Appearance", [
                new UIDropDown("Buttons Skin", ["Square", "Circle"], Settings.skin, function(value:String) {
                    Settings.skin = value;
                }),
                new UICheckBox("Camera Beat", Settings.camBeat, function(value:Bool) {
                    Settings.camBeat = value;
                })
            ]),
            new SettingsCata(415, 10, "Gameplay", [
                new UICheckBox("Ghost Tapping", Settings.ghostTapping, function(value:Bool) {
                    Settings.ghostTapping = value;
                }),
                new UIDropDown("Keyboard Scheme", ["Numpad", "No Numpad"], Settings.scheme, function(value:String) {
                    Utils.keys.setScheme(KeyboardScheme.fromString(value));
                })
            ]),
            new SettingsCata(620, 10, "Audio", [
                new UISlider("Master Volume", Settings.masterVolume, function(value:Float) {
                    Settings.masterVolume = value;
                }),
                new UISlider("Sound Volume", Settings.soundVolume, function(value:Float) {
                    Settings.soundVolume = value;
                }),
                new UISlider("Music Volume", Settings.musicVolume, function(value:Float) {
                    Settings.musicVolume = value;
                })
            ]),
            new SettingsCata(825, 10, "Misc", []),
            /*
            new SettingsCata(FlxG.width, 10, "Controls", [
                new UIBind(Control.toString(SEVEN), "NUMPADSEVEN")
            ])
            */
        ];
        add(catas[curCata]);

        super.create();
    }

    public function addCata(cat:UIButton) {
        cataButtons.push(cat);
        add(cat);
    }

    override function update(elapsed:Float) {
        if (controls.BACK) {
            daPlaying ? {
                FlxG.switchState(new PlayState());
            } : {
                FlxG.switchState(new MainMenuState());
            }
        }

        for (cat in cataButtons) {
            if (curCata == cataButtons.indexOf(cat)) {
                FlxTween.tween(cat.background, {alpha: 0.2}, 0.05);
            } else if (FlxG.mouse.overlaps(cat.background)) {
                FlxTween.tween(cat.background, {alpha: 0.6}, 0.05);
            } else {
                FlxTween.tween(cat.background, {alpha: 0.4}, 0.05);
            }
        }

        super.update(elapsed);
    }

    override function destroy() {
        Settings.save();
        super.destroy();
    }
}

class SettingsCata extends UIMenu {
    var titleObject:SettingsButton;

    public function new(x:Float = 0, y:Float = 0, title:String, settings:Array<UIInteractive>) {
        titleObject = new SettingsButton(x, y, 200, 45, title);
        titleObject.onChange = function() {
            SettingsState.instance.remove(SettingsState.catas[SettingsState.curCata]);
            SettingsState.curCata = SettingsState.catas.indexOf(this);
            
            SettingsState.instance.add(this);
        }
        SettingsState.instance.addCata(titleObject);

        for (i in 0...settings.length) {
            var setting = settings[i];
            var offset:Float = 20 + 50 * i;

            setting.x = 20;
            setting.y = offset;

            settings[i] = setting;
        }

        super(210, 90, settings);

        background.setGraphicSize(Std.int((200 * SettingsState.catas.length) + (5 * SettingsState.catas.length)), Std.int(FlxG.height - FlxG.height / 4));
        background.updateHitbox();
    }
}

class SettingsButton extends UIButton {
    public function new(x:Float = 0, y:Float = 0, width:Float, height:Float, title:String, onChange:Dynamic = null) {
        super(x, y, width, height, title, onChange);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background) && FlxG.mouse.justPressed && onChange != null) {
            onChange();
        }
    }
}