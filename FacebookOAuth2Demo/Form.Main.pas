unit Form.Main;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  IPPeerClient,
  REST.Client,
  REST.Authenticator.OAuth,
  Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    ButtonStep1: TButton;
    OAuth2_Facebook: TOAuth2Authenticator;
    ButtonStep2: TButton;
    edt_Facebook_AppID: TEdit;
    Label2: TLabel;
    edt_Facebook_BaseURL: TEdit;
    Label1: TLabel;
    edt_Facebook_ResourceURI: TEdit;
    Label3: TLabel;
    procedure ButtonStep1Click(Sender: TObject);
    procedure ButtonStep2Click(Sender: TObject);
    procedure RESTRequest1AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest1HTTPProtocolError(Sender: TCustomRESTRequest);
  strict private
    FFaceBook_AccessToken: string;
  private
    procedure AddToMemo(const APrefix, AText: string);

    procedure OAuth2_Facebook_AccessTokenRedirect(const AURL: string; var DoCloseWebView: Boolean);

    procedure ResetRESTComponentsToDefaults;
  end;

var
  MainForm: TMainForm;

implementation

uses
  REST.Json,
  REST.Utils,
  REST.Types,
  REST.Authenticator.OAuth.WebForm.Win;

{$R *.dfm}

procedure TMainForm.AddToMemo(const APrefix, AText: string);
begin
  Memo1.Lines.Add('');
  Memo1.Lines.Add(APrefix + AText);
end;

procedure TMainForm.ButtonStep1Click(Sender: TObject);
var
  LURL: string;
  wv: Tfrm_OAuthWebForm;
begin
  FFaceBook_AccessToken := '';

  LURL := 'https://www.facebook.com/dialog/oauth';
  LURL := LURL + '?client_id=' + URIEncode(edt_Facebook_AppID.Text);
  LURL := LURL + '&response_type=token';
  LURL := LURL + '&scope=' + URIEncode('public_profile,email');
  LURL := LURL + '&redirect_uri=' + URIEncode('https://www.facebook.com/connect/login_success.html');

  AddToMemo('URL: ', LURL);

  wv := Tfrm_OAuthWebForm.Create(self);
  try
    wv.OnAfterRedirect := OAuth2_Facebook_AccessTokenRedirect;
    wv.ShowModalWithURL(LURL);
  finally
    wv.Release;
  end;
end;

procedure TMainForm.OAuth2_Facebook_AccessTokenRedirect(const AURL: string; var DoCloseWebView: Boolean);
var
  LATPos: integer;
  LToken: string;
begin
  LATPos := Pos('access_token=', AURL);
  if (LATPos > 0) then
  begin
    LToken := Copy(AURL, LATPos + 13, Length(AURL));
    if (Pos('&', LToken) > 0) then
    begin
      LToken := Copy(LToken, 1, Pos('&', LToken) - 1);
    end;

    FFaceBook_AccessToken := LToken;
    AddToMemo('AccessToken: ', LToken);

    if (LToken <> '') then
      DoCloseWebView := TRUE;
  end;
end;

procedure TMainForm.ResetRESTComponentsToDefaults;
begin
  RESTRequest1.ResetToDefaults;
  RESTClient1.ResetToDefaults;
  RESTResponse1.ResetToDefaults;
end;

procedure TMainForm.ButtonStep2Click(Sender: TObject);
begin
  ResetRESTComponentsToDefaults;

  RESTClient1.BaseURL := edt_Facebook_BaseURL.Text;
  RESTClient1.Authenticator := OAuth2_Facebook;

  RESTRequest1.Resource := edt_Facebook_ResourceURI.Text;

  OAuth2_Facebook.AccessToken := FFaceBook_AccessToken;

  RESTRequest1.Execute;
end;

procedure TMainForm.RESTRequest1AfterExecute(Sender: TCustomRESTRequest);
begin
  AddToMemo('URI: ', Sender.GetFullRequestURL
    + ' Execution time: '
    + Sender.ExecutionPerformance.TotalExecutionTime.ToString
    + 'ms');

  if Assigned(RESTResponse1.JSONValue) then
    AddToMemo('JSON: ', TJson.Format(RESTResponse1.JSONValue))
  else
    AddToMemo('JSON: ', RESTResponse1.Content)
end;

procedure TMainForm.RESTRequest1HTTPProtocolError(Sender: TCustomRESTRequest);
begin
  //  show errors...
  AddToMemo('Error Statustext: ', Sender.Response.StatusText);
  AddToMemo('Error Content: ', Sender.Response.Content);
end;

end.
