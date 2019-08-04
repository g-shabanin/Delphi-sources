#TXplatIniFile class

���� ����� ������������� ������ ������������ IniFile, �� ���������� � ���������.
IniFile, ��������� � �������������� ����� ������, ����� ����� ����������� ������ ���������, ��� �������� ����.

|Platform|Format          |
|--------|----------------|
|Windows |IniFile         |
|OS X    |plist           |
|iOS     |plist           |
|Android |SharedPreference|

##�t�@�C��

�ȉ��̃t�@�C����S�ă_�E�����[�h���܂��B

    FMX.IniFile.pas          ������ ����� IniFile ��� �������� ��������
    FMX.IniFile.Apple.pas    ����� IniFile ��� OS X / iOS
    FMX.IniFile.Android.pas  ����� IniFile ��� Android

## ��� ������������

�� ������ ������������ ��� ��� ������� TIniFile, ��� �������� ����.

```pascal
uses
  FMX.IniFile;

var
  IniFile: TXplatIniFile;
begin
  IniFile: = CreateIniFile ('�������� ��������'); // �������� �������� ��������� � Windows, �� ����� ���� ������ �� ������ ����������
��IniFile.WriteString ('section', 'key name', 'value to write');
��IniFile.ReadString ('section', 'key name', 'default value');
end;
```

## ��������� ������ ��� ������������� ReadSections � OS X ��������� ��������� ����� ����������� � ���������� � �������� IniFile.

## ��������� ����� FMX.IniFile.Apple.pas �������� �� Apple.IniFile.pas, ��������������� Embarcadero Technologies.
�������������, Embarcadero Technologies ����� ������� ��������� ������ FMX.IniFile.Apple.pas.
� ����������, ����� ������������ FMX.IniFile � OS X / iOS, �� ������ ���� �������������� ������������� Delphi / C ++ Builder / RAD Studio / AppMethod.
������ ����� ����� �������� �������������� ���������� �� ������������� ��� ��������������� �������������.

������� �������, ���� �� ��������� ������������� Delphi / C ++ Builder / RAD Studio / AppMethod, �� ������ ������������ ��� ��� ������.

��������� ����� �� ���������.