# Утилита журнала

Эта утилита предоставляет унифицированный способ использования «Вывод журнала» в приложениях Windows / OS X / iOS / Android.
Журналы, использующие эту утилиту, выводятся в следующую папку.

|Platform|Out to                                   |Implementation      |
|--------|-----------------------------------------|--------------------|
|Windows |Console and Delphi's  Event Log          |WriteLn             |
|OS X    |Console (PAServer)                       |WriteLn             |
|iOS     |Device Log (Xcode -> Devices -> Log)     |NSLog               |
|Android |System Log (adb logcat)                  |__android_log_write |

##動作環境
Delphi / C++Builder / RAD Studio の XE5, XE6, XE7, XE8, 10 Seattle  
Appmethod 1.14, 1.15, 1.16, 1.17  

##最終更新日
2016/02/16

##ファイル

以下のファイルをダウンロードします。  

    FMX.Log.pas

##使用方法

FMX.Log を uses すると Log クラスが使えるようになります。  
Log.d といったクラスメソッドを使うとログが出力されます。  
  
レベルによって下記の様に使うメソッドが変わります。  

|Level   |Method Name|
|--------|-----------|
|VERBOSE |Log.v      |
|DEBUG   |Log.d      |
|INFO    |Log.i      |
|WARN    |Log.w      |
|ERROR   |Log.e      |
|FATAL   |Log.f      |

複数の値を渡すこともできます。  

```pascal
  Log.d('文字列');              // １つの引数版は文字列のみ指定可能  
  Log.d(['文字列', 123, True]); // 複数引数版は、様々な値を指定可能  
```

TRectF, TPointF, TSizeF, TRect, TPoint を文字列に変換するメソッドもあります。

```pascal
  Log.d(Log.PointFToString(TPointF.Create(100, 100)));    
  Log.d(Log.RectFToString(TRectF.Create(100, 100, 100, 100)));    
```

Enabled プロパティによって、出力を抑制できます。

```pascal
  {$IFDEF RELEASE}  
  Log.Enabled := False; // リリースビルドではログを出力しない  
  {$ENDIF}  
```

##例
```pascal
uses
  FMX.Log;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Log.i('ボタン１が押されたよ'); // Info Level で出力
  Log.d(['文字列', 100]);        // Debug Level で出力
end;

```

## Авторские права 
Это программное обеспечение «как есть» и предоставляется без явных или подразумеваемых гарантий. Ни при каких обстоятельствах авторы не будут нести ответственность за любые убытки, возникшие в результате использования данного программного обеспечения.

Это программное обеспечение может использоваться для любых целей, включая коммерческие приложения, и может свободно изменяться и распространяться при соблюдении следующих ограничений.

1.    Вы не должны искажать происхождение этого программного обеспечения. Не утверждайте, что вы создали оригинальное программное обеспечение. Если вы используете программное обеспечение в продукте, было бы полезно, если бы вы согласились с документацией на продукт, но это не требуется.

2.    Если вы меняете источник, вы должны указать это. Не вводите в заблуждение, что программное обеспечение является оригинальным.

3.    Вы не должны удалять это отображение или изменять отображение из исходного распределения.


This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented;
   you must not claim that you wrote the original software.
   If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
