# bat

```nix modules/home/bat.nix
{ config, pkgs, lib, ... }:
{
  programs.bat = {
    enable = true;
    themes.jb-light = {
      src = ./bat;
      file = "jb-light.tmTheme";
    };
    config.theme = "jb-light";
  };
}
```

## JB light theme

```xml modules/home/bat/jb-light.tmTheme
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>name</key>
  <string>JB Light</string>
  <key>settings</key>
  <array>
    <dict>
      <key>settings</key>
      <dict>
        <key>background</key>
        <string>#FFFFFF</string>
        <key>foreground</key>
        <string>#080808</string>
        <key>caret</key>
        <string>#000000</string>
        <key>lineHighlight</key>
        <string>#F5F8FE</string>
        <key>selection</key>
        <string>#A6D2FF</string>
        <key>gutterForeground</key>
        <string>#AEB3C2</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Comment</string>
      <key>scope</key>
      <string>comment, punctuation.definition.comment</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#8C8C8C</string>
        <key>fontStyle</key>
        <string>italic</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>String</string>
      <key>scope</key>
      <string>string, punctuation.definition.string, string.regexp</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#067D17</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Escape, builtin</string>
      <key>scope</key>
      <string>constant.character.escape, support.function.builtin, variable.language, markup.raw</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#0037A6</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Number</string>
      <key>scope</key>
      <string>constant.numeric</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#1750EB</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Keyword</string>
      <key>scope</key>
      <string>keyword, keyword.operator.word, storage, storage.type, storage.modifier, constant.language, support.type.builtin, support.type.primitive, entity.name.tag, entity.other.attribute-name, markup.underline.link</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#0033B3</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Operator, punctuation</string>
      <key>scope</key>
      <string>keyword.operator, punctuation</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#080808</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Function</string>
      <key>scope</key>
      <string>entity.name.function, support.function, meta.function-call.generic, variable.function</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#00627A</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Field, property</string>
      <key>scope</key>
      <string>variable.other.member, variable.other.property, variable.other.object.property, meta.property-name, support.type.property-name, entity.name.tag.yaml, meta.mapping.key string</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#871094</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Constant</string>
      <key>scope</key>
      <string>constant.other, variable.other.constant, variable.other.enummember</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#871094</string>
        <key>fontStyle</key>
        <string>italic</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Type, variable, parameter</string>
      <key>scope</key>
      <string>entity.name.type, entity.name.class, support.type, support.class, variable, variable.parameter, entity.name.namespace</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#000000</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Nix attribute names are plain identifiers</string>
      <key>scope</key>
      <string>source.nix entity.other.attribute-name</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#000000</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Annotation, decorator</string>
      <key>scope</key>
      <string>meta.annotation, storage.type.annotation, meta.decorator, entity.name.function.decorator, punctuation.definition.annotation</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#9E880D</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Heading</string>
      <key>scope</key>
      <string>markup.heading, entity.name.section</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#080808</string>
        <key>fontStyle</key>
        <string>bold</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Diff inserted</string>
      <key>scope</key>
      <string>markup.inserted</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#067D17</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Diff deleted</string>
      <key>scope</key>
      <string>markup.deleted</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#C93645</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Diff changed, range</string>
      <key>scope</key>
      <string>markup.changed, meta.diff.range, meta.diff.header</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#0033B3</string>
      </dict>
    </dict>
    <dict>
      <key>name</key>
      <string>Invalid</string>
      <key>scope</key>
      <string>invalid</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>#F50000</string>
      </dict>
    </dict>
  </array>
</dict>
</plist>
```
