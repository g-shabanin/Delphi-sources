#TXplatIniFile class

Ётот класс предоставл€ет способ использовать IniFile, не беспоко€сь о платформе.
IniFile, созданный с использованием этого класса, будет иметь собственный формат платформы, как показано ниже.

|Platform|Format          |
|--------|----------------|
|Windows |IniFile         |
|OS X    |plist           |
|iOS     |plist           |
|Android |SharedPreference|

##ГtГ@ГCГЛ

И»ЙЇВћГtГ@ГCГЛВрСSВƒГ_ГEГУГНБ[ГhВµВ№ВЈБB

    FMX.IniFile.pas          Ѕазовы класс IniFile без прив€зки платформ
    FMX.IniFile.Apple.pas     ласс IniFile дл€ OS X / iOS
    FMX.IniFile.Android.pas   ласс IniFile дл€ Android

##  ак пользоватьс€

¬ы можете использовать его как обычный TIniFile, как показано ниже.

```pascal
uses
  FMX.IniFile;

var
  IniFile: TXplatIniFile;
begin
  IniFile: = CreateIniFile ('название компании'); // название компании требуетс€ в Windows, но может быть пустым на других платформах
††IniFile.WriteString ('section', 'key name', 'value to write');
††IniFile.ReadString ('section', 'key name', 'default value');
end;
```

## »звестные ошибки ѕри использовании ReadSections в OS X системные параметры также извлекаютс€ в дополнение к разделам IniFile.

## јвторские права FMX.IniFile.Apple.pas основаны на Apple.IniFile.pas, предоставленном Embarcadero Technologies.
—ледовательно, Embarcadero Technologies также владеет авторским правом FMX.IniFile.Apple.pas.
¬ результате, чтобы использовать FMX.IniFile в OS X / iOS, вы должны быть действительным пользователем Delphi / C ++ Builder / RAD Studio / AppMethod.
ƒругие файлы могут свободно использоватьс€ независимо от коммерческого или некоммерческого использовани€.

ƒругими словами, если вы €вл€етесь пользователем Delphi / C ++ Builder / RAD Studio / AppMethod, вы можете использовать его как обычно.

јвторское право не оставлено.