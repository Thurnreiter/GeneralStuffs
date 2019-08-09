object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Main'
  ClientHeight = 374
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 199
    Top = 20
    Width = 42
    Height = 13
    Caption = 'Client-ID'
  end
  object Label1: TLabel
    Left = 199
    Top = 51
    Width = 40
    Height = 13
    Caption = 'Base-Url'
  end
  object Label3: TLabel
    Left = 199
    Top = 83
    Width = 67
    Height = 13
    Caption = 'Resource-URI'
  end
  object Memo1: TMemo
    Left = 16
    Top = 120
    Width = 593
    Height = 238
    TabOrder = 0
  end
  object ButtonStep1: TButton
    Left = 16
    Top = 15
    Width = 169
    Height = 25
    Caption = 'Step #1 fetch auth code'
    TabOrder = 1
    OnClick = ButtonStep1Click
  end
  object ButtonStep2: TButton
    Left = 16
    Top = 46
    Width = 169
    Height = 25
    Caption = 'Step #2 fetch data'
    TabOrder = 2
    OnClick = ButtonStep2Click
  end
  object edt_Facebook_AppID: TEdit
    Left = 272
    Top = 17
    Width = 337
    Height = 21
    TabOrder = 3
    Text = '327724244550321'
  end
  object edt_Facebook_BaseURL: TEdit
    Left = 272
    Top = 48
    Width = 337
    Height = 21
    TabOrder = 4
    Text = 'https://graph.facebook.com/'
  end
  object edt_Facebook_ResourceURI: TEdit
    Left = 272
    Top = 80
    Width = 337
    Height = 21
    TabOrder = 5
    Text = 'me?fields=name,birthday,friends.limit(10).fields(name)'
  end
  object RESTClient1: TRESTClient
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 112
    Top = 168
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    OnAfterExecute = RESTRequest1AfterExecute
    SynchronizedEvents = False
    OnHTTPProtocolError = RESTRequest1HTTPProtocolError
    Left = 112
    Top = 224
  end
  object RESTResponse1: TRESTResponse
    Left = 112
    Top = 280
  end
  object OAuth2_Facebook: TOAuth2Authenticator
    AuthorizationEndpoint = 'https://www.facebook.com/dialog/oauth'
    RedirectionEndpoint = 'https://www.facebook.com/connect/login_success.html'
    ResponseType = rtTOKEN
    Scope = 'user_about_me,user_birthday'
    Left = 200
    Top = 168
  end
end
