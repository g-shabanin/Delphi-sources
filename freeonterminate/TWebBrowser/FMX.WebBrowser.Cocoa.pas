﻿(*
 * TWebBrowserEx Classes
 *   WebBrowser Componet for FireMonkey.
 *
 * Copyright (c) 2013, 2015 HOSOKAWA Jun.
 *
 * Last Update 2015/10/29
 *
 * Platform:
 *   Windows, OS X, iOS, Android
 *   Delphi / C++Builder XE5, XE6, XE7, XE8, 10 seattle
 *   Appmethod 1.14, 1.15, 1.16, 1.17
 *
 * Contact:
 *   Twitter @pik or freeonterminate@gmail.com
 *
 * Original Source:
 *   https://github.com/freeonterminate/delphi/tree/master/TWebBrowser
 *
 * How to Use:
 *   1. Add FMX.WebBroserEx to "uses" block.
 *
 *   2. Create WebBroserEx and Set parent.
 *      procedure TForm1.FormCreate(Sender: TObject);
 *      begin
 *        FWebBrowser := TWebBrowserEx.Create(Self);
 *        FWebBrowser.Parent := Panel1;
 *        FWebBrowser.Align := TAlignLayout.Client;
 *      end;
 *
 *   3. Set URL property.
 *      procedure TForm1.Button1Click(Sender: TObject);
 *      begin
 *        FWebBrowser.URL := 'https://twitter.com/pik';
 *      end;
 *
 * LICENSE:
 *   本ソフトウェアは「現状のまま」で、明示であるか暗黙であるかを問わず、
 *   何らの保証もなく提供されます。
 *   本ソフトウェアの使用によって生じるいかなる損害についても、
 *   作者は一切の責任を負わないものとします。
 *
 *   以下の制限に従う限り、商用アプリケーションを含めて、本ソフトウェアを
 *   任意の目的に使用し、自由に改変して再頒布することをすべての人に許可します。
 *
 *   1. 本ソフトウェアの出自について虚偽の表示をしてはなりません。
 *      あなたがオリジナルのソフトウェアを作成したと主張してはなりません。
 *      あなたが本ソフトウェアを製品内で使用する場合、製品の文書に謝辞を入れて
 *      いただければ幸いですが、必須ではありません。
 *
 *   2. ソースを変更した場合は、そのことを明示しなければなりません。
 *      オリジナルのソフトウェアであるという虚偽の表示をしてはなりません。
 *
 *   3. ソースの頒布物から、この表示を削除したり、表示の内容を変更したりしては
 *      なりません。
 *
 *   This software is provided 'as-is', without any express or implied warranty.
 *   In no event will the authors be held liable for any damages arising from
 *   the use of this software.
 *
 *   Permission is granted to anyone to use this software for any purpose,
 *   including commercial applications, and to alter it and redistribute
 *   it freely, subject to the following restrictions:
 *
 *   1. The origin of this software must not be misrepresented;
 *      you must not claim that you wrote the original software.
 *      If you use this software in a product, an acknowledgment in the product
 *      documentation would be appreciated but is not required.
 *
 *   2. Altered source versions must be plainly marked as such,
 *      and must not be misrepresented as being the original software.
 *
 *   3. This notice may not be removed or altered from any source distribution.
 *)

unit FMX.WebBrowser.Cocoa;

interface

uses
  FMX.WebBrowserEx;

procedure RegisterWebBrowserService;
procedure UnRegisterWebBrowserService;

implementation

uses
  System.Classes, System.SysUtils, System.Types, System.Math, System.UITypes
  , System.Rtti
  , Macapi.CoreFoundation, Macapi.ObjectiveC, Macapi.WebView, Macapi.Foundation
  , Macapi.AppKit, Macapi.CocoaTypes, Macapi.CoreGraphics, Macapi.Helpers
  , FMX.Types, FMX.WebBrowser, FMX.Platform, FMX.Platform.Mac, FMX.Forms
  , FMX.Graphics, FMX.Surfaces
  ;

type
  TMacWebBrowserService = class;

  TWebPolicyDelegate = class(TOCLocal, WebPolicyDelegate)
  private var
    FMacWebBrowserService: TMacWebBrowserService;
    FWebControl: TCustomWebBrowser;
  public
    procedure SetWebControl(const iMacWebBrowserService: TMacWebBrowserService);
  public
    [MethodName('webView:decidePolicyForNavigationAction:request:frame:decisionListener:')]
    procedure webViewDecidePolicyForNavigationActionRequestFrameDecisionListener(
      WebView: WebView;
      decidePolicyForNavigationAction: NSDictionary;
      request: NSURLRequest;
      frame: WebFrame;
      decisionListener: Pointer); cdecl;
    [MethodName('webView:decidePolicyForNewWindowAction:request:newFrameName:decisionListener:')]
    procedure webViewDecidePolicyForNewWindowActionRequestNewFrameNameDecisionListener(
      WebView: WebView;
      decidePolicyForNewWindowAction: NSDictionary;
      request: NSURLRequest;
      newFrameName: NSString;
      decisionListener: Pointer); cdecl;
    [MethodName('webView:decidePolicyForMIMEType:request:frame:decisionListener:')]
    procedure webViewDecidePolicyForMIMETypeRequestFrameDecisionListener(
      WebView: WebView;
      decidePolicyForMIMEType: NSString;
      request: NSURLRequest;
      frame: WebFrame;
      decisionListener: Pointer); cdecl;
    [MethodName('webView:unableToImplementPolicyWithError:frame:')]
    procedure webViewUnableToImplementPolicyWithErrorFrame(
      WebView: WebView;
      unableToImplementPolicyWithError: NSError;
      frame: WebFrame); cdecl;
  end;

  TWebPolicyDecisionListener = class(TOCGenericImport<NSObjectClass, WebPolicyDecisionListener>)
  end;

  TWebFrameLoadDelegate = class(TOCLocal, WebFrameLoadDelegate)
  private var
    FMacWebBrowserService: TMacWebBrowserService;
    FWebControl: TCustomWebBrowser;
  public
    procedure SetWebControl(const iMacWebBrowserService: TMacWebBrowserService);
    procedure webView(
      sender: WebView;
      didStartProvisionalLoadForFrame: WebFrame); overload; cdecl;
    procedure webView(
      sender: WebView;
      didReceiveServerRedirectForProvisionalLoadForFrame: WebFrame2);
      overload; cdecl;
    procedure webView(
      sender: WebView;
      didFailProvisionalLoadWithError: NSError;
      frame: WebFrame); overload; cdecl;
    procedure webView(
      sender: WebView;
      didCommitLoadForFrame: WebFrame3); overload; cdecl;
    procedure webView(
      sender: WebView;
      didReceiveTitle: NSString;
      frame: WebFrame); overload; cdecl;
    procedure webView(
      sender: WebView;
      didReceiveIcon: NSImage;
      frame: WebFrame); overload; cdecl;
    procedure webView(
      sender: WebView;
      didFinishLoadForFrame: WebFrame4); overload; cdecl;
    procedure webView(
      sender: WebView;
      didFailLoadWithError: NSError;
      frame: WebFrame5); overload; cdecl;
    procedure webView(
      sender: WebView;
      didChangeLocationWithinPageForFrame: WebFrame6); overload; cdecl;
    procedure webView(
      sender: WebView;
      willPerformClientRedirectToURL: NSURL;
      seconds: NSTimeInterval;
      date: NSDate;
      frame: WebFrame); overload; cdecl;
    procedure webView(
      sender: WebView;
      didCancelClientRedirectForFrame: WebFrame7); overload; cdecl;
    procedure webView(
      sender: WebView;
      willCloseFrame: WebFrame8); overload; cdecl;
    procedure webView(
      sender: WebView;
      didClearWindowObject: WebScriptObject;
      frame: WebFrame); overload; cdecl;
  end;

  TMacCursorService = class(TInterfacedObject, IFMXCursorService)
  private var
    FOrgCursorService: IFMXCursorService;
    FProhibiting: Boolean;
  public
    procedure SetCursor(const ACursor: TCursor);
    function GetCursor: TCursor;
  end;

  TMacWebBrowserService =
    class(TInterfacedObject, ICustomBrowser, IWebBrowserEx)
  private var
    FURL: String;
    FWebView: WebView;
    FWebViewId: Pointer;
    FWebControl: TCustomWebBrowser;
    FNSCachePolicy: NSURLRequestCachePolicy;
    FModule: HMODULE;
    FForm: TCommonCustomForm;
    FDelegate: TWebFrameLoadDelegate;
    FPolicyDelegate: TWebPolicyDelegate;
    FVMIntercepter: TVirtualMethodInterceptor;
    FTrackingArea: NSTrackingArea;
    FCursorService: TMacCursorService;
  private
    function GetBounds: TRectF;
    function GetNSBounds: NSRect;
    procedure RemoveIntercepter;
    procedure RemoveTrackingArea;
    procedure AddTrackingArea;
    procedure SetCursorService;
    procedure ResetCursorService;
    procedure ProcMouseMove(
      const iMethod: TRttiMethod;
      const iArgs: TArray<TValue>;
      const iSet: Boolean);
  protected
    function GetView: NSView; inline;
    { ICustomBrowser }
    function GetURL: string;
    function CaptureBitmap: TBitmap;
    function GetCanGoBack: Boolean;
    function GetCanGoForward: Boolean;
    procedure SetURL(const AValue: string);
    function GetEnableCaching: Boolean;
    procedure SetEnableCaching(const Value : Boolean);
    procedure SetWebBrowserControl(const AValue: TCustomWebBrowser);
    function GetParent: TFmxObject;
    function GetVisible : Boolean;
    procedure UpdateContentFromControl;
    procedure Navigate;
    procedure Reload;
    procedure Stop;
    procedure EvaluateJavaScript(const JavaScript: string);
    procedure LoadFromStrings(const Content: string; const BaseUrl: string);
    procedure GoBack;
    procedure GoForward;
    procedure GoHome;
    procedure Show;
    procedure Hide;
    property URL: string read GetURL write SetURL;
    property EnableCaching: Boolean read GetEnableCaching write SetEnableCaching;
    property CanGoBack: Boolean read GetCanGoBack;
    property CanGoForward: Boolean read GetCanGoForward;
    { IWebBrowserEx }
    function GetTagValue(const iTagName, iValueName: String): String;
    function GetHTMLSource: String;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TMacWBService = class(TWBFactoryService)
  protected
    function DoCreateWebBrowser: ICustomBrowser; override;
  end;

  TOpenForm = class(TCommonCustomForm);

var
  GWBService: TMacWBService;

{ TMacWBService }

function TMacWBService.DoCreateWebBrowser: ICustomBrowser;
begin
  Result := TMacWebBrowserService.Create;
end;

procedure RegisterWebBrowserService;
begin
  GWBService := TMacWBService.Create;
  TPlatformServices.Current.AddPlatformService(IFMXWBService, GWBService);
end;

procedure UnRegisterWebBrowserService;
begin
  TPlatformServices.Current.RemovePlatformService(IFMXWBService);
end;

{ TMacCursorService }

function TMacCursorService.GetCursor: TCursor;
begin
  Result := FOrgCursorService.GetCursor;
end;

procedure TMacCursorService.SetCursor(const ACursor: TCursor);
begin
  if (not FProhibiting) then
    FOrgCursorService.SetCursor(ACursor);
end;

{ TMacWebBrowserService }

procedure TMacWebBrowserService.AddTrackingArea;
var
  View: NSView;
begin
  RemoveTrackingArea;

  View := GetView;

  if (View = nil) then
    Exit;

  FTrackingArea :=
    TNSTrackingArea.Wrap(
      TNSTrackingArea.Alloc.initWithRect(
        GetNSBounds,
        NSTrackingMouseMoved
          or NSTrackingActiveAlways
          or NSTrackingAssumeInside,
        View.superview,
        nil
      )
    );

  View.addTrackingArea(FTrackingArea);
end;

function TMacWebBrowserService.CaptureBitmap: TBitmap;
var
  Surface: TBitmapSurface;
  Size: NSSize;
  ContRef: CGContextRef;
  OldWantLayer: Boolean;
begin
  Result := TBitmap.Create;

  Surface := TBitmapSurface.Create;
  try
    Size := FWebView.frame.size;
    Surface.SetSize(Ceil(Size.width), Ceil(Size.height));

    ContRef :=
      CGBitmapContextCreate(
        Surface.Bits,
        Surface.Width,
        Surface.Height,
        8,
        4 * Surface.Width,
        CGColorSpaceCreateDeviceRGB,
        kCGImageAlphaPremultipliedLast or kCGBitmapByteOrder32Big);
    try
      OldWantLayer := FWebView.wantsLayer;
      FWebView.setWantsLayer(True);
      try
        if (FWebView.layer <> nil) then
          FWebView.layer.renderInContext(ContRef);
      finally
        FWebView.setWantsLayer(OldWantLayer);
      end;
    finally
      CGContextRelease(ContRef);
    end;

    Result.Assign(Surface);
  finally
    Surface.Free;
  end;
end;

constructor TMacWebBrowserService.Create;
begin
  inherited;

  FModule := LoadLibrary(PWideChar(WEBKIT_FRAMEWORK));
  FNSCachePolicy := NSURLRequestReloadRevalidatingCacheData;

  FDelegate := TWebFrameLoadDelegate.Create;
  FPolicyDelegate := TWebPolicyDelegate.Create;

  FCursorService := TMacCursorService.Create;

  FWebViewId :=
    TWebView.Alloc.initWithFrame(MakeNSRect(0, 0, 100, 100), nil, nil);
  FWebView := TWebView.Wrap(FWebViewId);

  FWebView.setAcceptsTouchEvents(True);
  FWebView.setFrameLoadDelegate(FDelegate.GetObjectID);
  FWebView.setPolicyDelegate(FPolicyDelegate.GetObjectID);
end;

destructor TMacWebBrowserService.Destroy;
begin
  //RemoveTrackingArea; // Already destroid View.
  RemoveIntercepter;
  ResetCursorService;

  FCursorService := nil;

  FWebView.release;

  FreeLibrary(FModule);

  inherited;
end;

procedure TMacWebBrowserService.EvaluateJavaScript(const JavaScript: String);
begin
  FWebView.stringByEvaluatingJavaScriptFromString(StrToNSSTR(JavaScript));
  UpdateContentFromControl;
end;

function TMacWebBrowserService.GetBounds: TRectF;
var
  Pt: TPointF;
begin
  Result.Empty;

  if (FWebControl <> nil) and (FForm <> nil) then
  begin
    Pt := FWebControl.LocalToAbsolute(FWebControl.Position.Point);
    Result :=
      TRectF.Create(
        Pt.X,
        FForm.ClientHeight - Pt.Y - FWebControl.Height,
        FWebControl.Width,
        FWebControl.Height);
  end;
end;

function TMacWebBrowserService.GetCanGoBack: Boolean;
begin
  Result := FWebView.canGoBack;
end;

function TMacWebBrowserService.GetCanGoForward: Boolean;
begin
  Result := FWebView.canGoForward;
end;

function TMacWebBrowserService.GetEnableCaching: Boolean;
begin
  Result := (FNSCachePolicy = NSURLRequestReloadRevalidatingCacheData);
end;

function TMacWebBrowserService.GetHTMLSource: String;
begin
  Result :=
    NSStrToStr(
      FWebView.stringByEvaluatingJavaScriptFromString(
        StrToNSSTR('document.getElementsByTagName("html")[0].outerHTML')
      )
    );
end;

function TMacWebBrowserService.GetNSBounds: NSRect;
var
  Bounds: TRectF;
begin
  Bounds := GetBounds;
  Result := MakeNSRect(Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom);
end;

function TMacWebBrowserService.GetParent: TFmxObject;
begin
  if (FWebControl <> nil) then
    Result := FWebControl.Parent
  else
    Result := nil;
end;

function TMacWebBrowserService.GetTagValue(
  const iTagName, iValueName: String): String;
var
  Res: NSString;
begin
  Res :=
    FWebView.stringByEvaluatingJavaScriptFromString(
      StrToNSSTR(
        'document.getElementById("' + iTagName + '").' + iValueName
      )
    );

  Result := String(Res.UTF8String);
end;

function TMacWebBrowserService.GetURL: string;
begin
  Result := FURL;
end;

function TMacWebBrowserService.GetView: NSView;
begin
  if (FForm = nil) then
    Result := nil
  else
    Result := WindowHandleToPlatform(FForm.Handle).View;
end;

function TMacWebBrowserService.GetVisible: Boolean;
begin
  if (FWebControl <> nil) then
    Result := FWebControl.Visible
  else
    Result := False;
end;

procedure TMacWebBrowserService.GoBack;
begin
  FWebView.goBack;
end;

procedure TMacWebBrowserService.GoForward;
begin
  FWebView.goForward;
end;

procedure TMacWebBrowserService.GoHome;
begin

end;

procedure TMacWebBrowserService.Hide;
begin
  if (FWebView <> nil) and (not FWebView.isHidden) then
    FWebView.setHidden(True);
end;

procedure TMacWebBrowserService.LoadFromStrings(const Content, BaseUrl: String);
var
  tmpContent: NSString;
  URL: NSURL;
  Base: NSString;
begin
  tmpContent := StrToNSStr(Content);

  if (BaseUrl.IsEmpty) then
    URL := nil
  else
  begin
    Base := StrToNSStr(BaseUrl);
    URL := TNSUrl.Wrap(TNSUrl.OCClass.URLWithString(Base));
  end;

  FWebView.mainFrame.loadHTMLString(tmpContent, URL);

  UpdateContentFromControl;
end;

procedure TMacWebBrowserService.Navigate;
const
  cTheTimeoutIntervalForTheNewRequest = 0;
var
  Url: NSURL;
  Req: NSURLRequest;
begin
  Url := TNSURL.Wrap(TNSURL.Alloc.initWithString(StrToNSSTR(FURL)));

  Req :=
    TNSURLRequest.Wrap(
      TNSURLRequest.OCClass.requestWithURL(
        Url,
        FNSCachePolicy,
        cTheTimeoutIntervalForTheNewRequest
      )
    );

  FWebView.mainFrame.loadRequest(Req);

  UpdateContentFromControl;
end;

procedure TMacWebBrowserService.ProcMouseMove(
  const iMethod: TRttiMethod;
  const iArgs: TArray<TValue>;
  const iSet: Boolean);
var
  P: TPointF;
begin
  if (iMethod.Name = 'MouseMove') then
  begin
    P := PointF(iArgs[1].AsType<Single>, iArgs[2].AsType<Single>);

    if (FWebControl.PointInObject(P.X, P.Y)) then
    begin
      FCursorService.FProhibiting := iSet;
    end;
  end;
end;

procedure TMacWebBrowserService.Reload;
begin
  if (FWebView <> nil) then
    FWebView.reload(FWebViewId);
end;

procedure TMacWebBrowserService.RemoveIntercepter;
begin
  if (FVMIntercepter <> nil) then
  begin
    if  (FForm <> nil) then
      FVMIntercepter.Unproxify(FForm);

    FVMIntercepter.DisposeOf;
    FVMIntercepter := nil;
  end;
end;

procedure TMacWebBrowserService.RemoveTrackingArea;
var
  View: NSView;
begin
  View := GetView;

  if (FTrackingArea <> nil) and (View <> nil) then
    View.removeTrackingArea(FTrackingArea);

  FTrackingArea := nil;
end;

procedure TMacWebBrowserService.ResetCursorService;
begin
  if (FForm <> nil) and (FCursorService.FOrgCursorService <> nil) then
  begin
    TOpenForm(FForm).FCursorService := FCursorService.FOrgCursorService;
    FCursorService.FOrgCursorService := nil;
  end;
end;

procedure TMacWebBrowserService.SetCursorService;
begin
  ResetCursorService;

  if (FForm <> nil) then
  begin
    FCursorService.FOrgCursorService := TOpenForm(FForm).FCursorService;
    TOpenForm(FForm).FCursorService := FCursorService;
  end;
end;

procedure TMacWebBrowserService.SetEnableCaching(const Value: Boolean);
begin
  if (Value) then
    FNSCachePolicy := NSURLRequestReloadRevalidatingCacheData
  else
    FNSCachePolicy := NSURLRequestReloadIgnoringLocalCacheData;
end;

procedure TMacWebBrowserService.SetURL(const AValue: string);
begin
  FURL := AValue;
end;

procedure TMacWebBrowserService.SetWebBrowserControl(
  const AValue: TCustomWebBrowser);
begin
  RemoveIntercepter;

  FWebControl := AValue;

  FDelegate.SetWebControl(Self);
  FPolicyDelegate.SetWebControl(Self);

  if
    (FWebControl <> nil)
    and (FWebControl.Root <> nil)
    and (FWebControl.Root.GetObject is TCommonCustomForm)
  then
  begin
    ResetCursorService;
    FForm := TCommonCustomForm(FWebControl.Root.GetObject);
    SetCursorService;

    FVMIntercepter := TVirtualMethodInterceptor.Create(FForm.ClassType);
    FVMIntercepter.OnBefore :=
      procedure(
        iInstance: TObject;
        iMethod: TRttiMethod;
        const iArgs: TArray<TValue>;
        out iDoInvoke: Boolean;
        out iResult: TValue)
      begin
        ProcMouseMove(iMethod, iArgs, True);
      end;

    FVMIntercepter.OnAfter :=
      procedure(
        iInstance: TObject;
        iMethod: TRttiMethod;
        const iArgs: TArray<TValue>;
        var iResult: TValue)
      begin
        ProcMouseMove(iMethod, iArgs, False);
      end;

    FVMIntercepter.Proxify(FForm);
  end;
end;

procedure TMacWebBrowserService.Show;
begin
  if (FWebView <> nil) and (FWebView.isHidden) then
    FWebView.setHidden(False);
end;

procedure TMacWebBrowserService.Stop;
begin
  if (FWebView <> nil) then
    FWebView.stopLoading(Pointer(FWebView));
end;

procedure TMacWebBrowserService.UpdateContentFromControl;
var
  View: NSView;
  Bounds: TRectF;
begin
  if (FWebView <> nil) then
  begin
    if
      (FWebControl <> nil)
      and not (csDesigning in FWebControl.ComponentState)
      and (FForm <> nil)
    then
    begin
      Bounds := GetBounds;

      View := GetView;
      if (View <> nil) then
      begin
        View.addSubview(FWebView);
        AddTrackingArea;

        if (SameValue(Bounds.Width, 0)) or (SameValue(Bounds.Height, 0)) then
          // Hide WebView
          FWebView.setHidden(True)
        else
        begin
          // Show WebView
          FWebView.setFrame(GetNSBounds);
          FWebView.setHidden(not FWebControl.ParentedVisible);
        end;
      end;
    end
    else
      FWebView.setHidden(True);
  end;
end;

{ TWebFrameLoadDelegate }

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didReceiveTitle: NSString;
  frame: WebFrame);
begin
  // didReceiveTitle
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didReceiveIcon: NSImage; frame: WebFrame);
begin
  // didReceiveIcon
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didFinishLoadForFrame: WebFrame4);
begin
  // didFinishLoadForFrame
  if (FWebControl <> nil) then
    FWebControl.FinishLoading;
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didCommitLoadForFrame: WebFrame3);
begin
  // didCommitLoadForFrame
  if (FWebControl <> nil) then
    FWebControl.ShouldStartLoading(FWebControl.URL);
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didStartProvisionalLoadForFrame: WebFrame);
begin
  // didStartProvisionalLoadForFrame
  if (FWebControl <> nil) then
    FWebControl.StartLoading;
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didReceiveServerRedirectForProvisionalLoadForFrame: WebFrame2);
begin
  // didReceiveServerRedirectForProvisionalLoadForFrame
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didFailProvisionalLoadWithError: NSError; frame: WebFrame);
begin
  // didFailProvisionalLoadWithError
  if (FWebControl <> nil) then
    FWebControl.FailLoadingWithError;
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  willCloseFrame: WebFrame8);
begin
  // willCloseFrame
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didClearWindowObject: WebScriptObject; frame: WebFrame);
begin
  // didClearWindowObject
end;

procedure TWebFrameLoadDelegate.SetWebControl(
  const iMacWebBrowserService: TMacWebBrowserService);
begin
  FMacWebBrowserService := iMacWebBrowserService;
  FWebControl := FMacWebBrowserService.FWebControl;
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didCancelClientRedirectForFrame: WebFrame7);
begin
  // didCancelClientRedirectForFrame
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didFailLoadWithError: NSError;
  frame: WebFrame5);
begin
  // didFailLoadWithError
  if (FWebControl <> nil) then
    FWebControl.FailLoadingWithError;
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  didChangeLocationWithinPageForFrame: WebFrame6);
begin
  // didChangeLocationWithinPageForFrame
end;

procedure TWebFrameLoadDelegate.webView(
  sender: WebView;
  willPerformClientRedirectToURL: NSURL;
  seconds: NSTimeInterval;
  date: NSDate;
  frame: WebFrame);
begin
  // willPerformClientRedirectToURL
end;

{ TWebPolicyDelegate }

procedure TWebPolicyDelegate.SetWebControl(
  const iMacWebBrowserService: TMacWebBrowserService);
begin
  FMacWebBrowserService := iMacWebBrowserService;
  FWebControl := FMacWebBrowserService.FWebControl;
end;

procedure TWebPolicyDelegate.webViewDecidePolicyForMIMETypeRequestFrameDecisionListener(
  WebView: WebView;
  decidePolicyForMIMEType: NSString;
  request: NSURLRequest;
  frame: WebFrame;
  decisionListener: Pointer);
var
  Listener: WebPolicyDecisionListener;
begin
  Listener := TWebPolicyDecisionListener.Wrap(decisionListener);
  Listener.use;
end;

procedure TWebPolicyDelegate.webViewDecidePolicyForNavigationActionRequestFrameDecisionListener(
  WebView: WebView;
  decidePolicyForNavigationAction: NSDictionary;
  request: NSURLRequest;
  frame: WebFrame;
  decisionListener: Pointer);
var
  Listener: WebPolicyDecisionListener;
  WebBrowserCanNavigate: IWebBrowserCanNavigate;
  OK: Boolean;
  Dic: NSDictionary;
  Obj: Pointer;
  Str: NSString;
begin
  OK := True;
  Listener := TWebPolicyDecisionListener.Wrap(decisionListener);

  if
    (FWebControl <> nil) and
    (Supports(FWebControl, IWebBrowserCanNavigate, WebBrowserCanNavigate)) and
    (decidePolicyForNavigationAction <> nil)
  then
  begin
    // is Click ?
    Obj :=
      decidePolicyForNavigationAction.objectForKey(
        TWebActionKeys.GetNavigationTypeKeyObj
      );

    if (Obj <> nil) then
    begin
      Str := TNSString.Wrap(Obj);

      if Str.intValue = TWebNavigationType.LinkClicked then
      begin
        // Get linked url
        Obj :=
          decidePolicyForNavigationAction.objectForKey(
            TWebActionKeys.GetElementKeyObj
          );

        if (Obj <> nil) then
        begin
          Dic := TNSDictionary.Wrap(Obj);
          Obj := Dic.objectForKey(TWebElement.GetLinkURLKeyObj);

          // Check url
          if (Obj <> nil) then
            OK :=
              WebBrowserCanNavigate.CanNavigate(NSURLToStr(TNSUrl.Wrap(Obj)));
        end;
      end;
    end;
  end;

  if (OK) then
    Listener.use
  else
    Listener.ignore;
end;

procedure TWebPolicyDelegate.webViewDecidePolicyForNewWindowActionRequestNewFrameNameDecisionListener(
  WebView: WebView;
  decidePolicyForNewWindowAction: NSDictionary;
  request: NSURLRequest;
  newFrameName: NSString;
  decisionListener: Pointer);
var
  Listener: WebPolicyDecisionListener;
begin
  Listener := TWebPolicyDecisionListener.Wrap(decisionListener);
  Listener.use;
end;

procedure TWebPolicyDelegate.webViewUnableToImplementPolicyWithErrorFrame(
  WebView: WebView;
  unableToImplementPolicyWithError:
  NSError; frame: WebFrame);
begin

end;

// XE8 以降は RegisterWebBrowserService が自動的に呼ばれる
{$IF RTLVersion < 29}
initialization
  RegisterWebBrowserService;
{$ENDIF}

end.
