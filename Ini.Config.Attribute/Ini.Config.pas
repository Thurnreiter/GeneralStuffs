unit Ini.Config;

interface

uses
  System.SysUtils,
  System.Rtti;

{$REGION 'Inspired by'}
{
  http://robstechcorner.blogspot.com/2009/10/ini-persistence-rtti-way.html
  http://qaru.site/questions/656124/delphi-is-it-possible-to-enumerate-all-instances-of-a-record-typed-constants-in-the-global-namespace
  https://stackoverflow.com/questions/16210993/delphi-interface-implements
  https://www.delphipraxis.net/27817-interfaces-und-delegation-durch-implements.html
}
{$ENDREGION}

{$M+}

type
  /// <summary>
  ///   This annotation specifies which key / value is to read from configuation.
  /// </summary>
  SettingAttribute = class(TCustomAttribute)
  private
    FSection: string;
    FKey: string;
    FValue: string;
    FDefaultValue: string;
  public
    constructor Create(const ASection, AKey: string); overload;
    constructor Create(const ASection, AKey: string; const ADefaultValue: Integer); overload;
    constructor Create(const ASection, AKey: string; const ADefaultValue: Double); overload;
    constructor Create(const ASection, AKey: string; const ADefaultValue: Boolean); overload;
    constructor Create(const ASection, AKey: string; const ADefaultValue: string); overload;

    property Section: string read FSection write FSection;
    property Key: string read FKey write FKey;
    property Value: string read FValue write FValue;
    property DefaultValue: string read FDefaultValue write FDefaultValue;
  end;


  /// <summary>
  ///   Interface <b>ISettingHandler</b> represented the read, write method.
  /// </summary>
  ISettingHandler = interface(IInvokable)
    ['{76DA39C5-AD08-4D9D-A5FC-1E388E42840A}']
    function ReadString(const ASection, AKey, ADefaultValue: string): string;
    procedure WriteString(const ASection, AKey, AValue: string);
  end;

  /// <summary>
  ///   Implementation of interface <b>ISettingHandler</b>, this represented the read, write method.
  ///   Look at: <see cref="Ini.Config|ISettingHandler">ISettingHandler</see>
  /// </summary>
  TSettingHandler = class(TInterfacedObject, ISettingHandler)
  public
    function ReadString(const ASection, AKey, ADefaultValue: string): string; virtual; abstract;
    procedure WriteString(const ASection, AKey, AValue: string); virtual; abstract;
  end;

  TSettingHandlerClass = class of TSettingHandler;

  /// <summary>
  ///   Inner class. Is used for reading attributes.
  /// </summary>
  TConfigReflection = class
  private
    class function GetValue(var AValue: TValue): string;
    class procedure SetValue(const AData: string; var AValue: TValue);

    class function GetIniAttribute(const Obj: TRttiObject): SettingAttribute;
  public
    class procedure Load(AObj: TObject; AHandler: ISettingHandler);
    class procedure Save(AObj: TObject; AHandler: ISettingHandler);
  end;



  /// <summary>
  ///   Base interface for all inheritance classes...
  /// </summary>
  ISettings = interface(IInvokable)
    ['{BD14D859-F4F9-41BB-B9C5-076A9F84675C}']
    function GetConfigAddress: string;
    procedure SetConfigAddress(const value: string);

    function GetHandler(): ISettingHandler;
    procedure SetHandler(value: ISettingHandler);

    procedure Load;
    procedure Save;

    property ConfigAddress: string read GetConfigAddress write SetConfigAddress;
    property Handler: ISettingHandler read GetHandler write SetHandler;
  end;

  /// <summary>
  ///   Base class for all inheritance classes...
  /// </summary>
  TSettings = class(TInterfacedObject, ISettings)
  strict private
    FConfigAddress: string;
    FHandler: ISettingHandler;
  private
    function GetConfigAddress: string;
    procedure SetConfigAddress(const value: string);

    function GetHandler(): ISettingHandler;
    procedure SetHandler(value: ISettingHandler);
  public
    procedure Load; virtual;
    procedure Save; virtual;

    property ConfigAddress: string read GetConfigAddress write SetConfigAddress;
    property Handler: ISettingHandler read GetHandler write SetHandler;
  end;

{$M-}

implementation

uses
  System.TypInfo;

const
  ExNotSupportedExceptionText = 'Config type not supported!';

{ **************************************************************************** }

{ SettingAttribute }

constructor SettingAttribute.Create(const ASection, AKey: string);
begin
  Create(ASection, AKey, '');
end;

constructor SettingAttribute.Create(const ASection, AKey: string; const ADefaultValue: Integer);
begin
  Create(ASection, AKey, ADefaultValue.ToString);
end;

constructor SettingAttribute.Create(const ASection, AKey: string; const ADefaultValue: Double);
begin
  Create(ASection, AKey, ADefaultValue.ToString);
end;

constructor SettingAttribute.Create(const ASection, AKey: string; const ADefaultValue: Boolean);
begin
  Create(ASection, AKey, BoolToStr(ADefaultValue));
end;

constructor SettingAttribute.Create(const ASection, AKey, ADefaultValue: string);
begin
  FSection := ASection;
  FKey := AKey;
  FValue := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

{ **************************************************************************** }

{ TSettings }

function TSettings.GetConfigAddress: string;
begin
  Result := FConfigAddress;
end;

procedure TSettings.SetConfigAddress(const value: string);
begin
  FConfigAddress := value
end;

function TSettings.GetHandler: ISettingHandler;
begin
  Result := FHandler;
end;

procedure TSettings.SetHandler(value: ISettingHandler);
begin
  FHandler := value;
end;

procedure TSettings.Load();
begin
  TConfigReflection.Load(Self, FHandler);
end;

procedure TSettings.Save();
begin
  TConfigReflection.Save(Self, FHandler);
end;

{ **************************************************************************** }


{ TConfigPersistence }

class function TConfigReflection.GetValue(var AValue: TValue): string;
begin
  if AValue.Kind in
    [tkWChar,
     tkLString,
     tkWString,
     tkString,
     tkChar,
     tkUString,
     tkInteger,
     tkInt64,
     tkFloat,
     tkEnumeration,
     tkSet] then
    Result := aValue.ToString
  else
    raise ENotSupportedException.Create(ExNotSupportedExceptionText);
end;

class procedure TConfigReflection.SetValue(const AData: string; var AValue: TValue);
var
  Idx: Integer;
begin
  case AValue.Kind of
    tkWChar, tkLString, tkWString, tkString, tkChar, tkUString: AValue := AData;

    tkInteger, tkInt64:
      begin
        if AData.IsEmpty then
          AValue := 0
        else
          AValue := AData.ToInteger()
      end;

    tkFloat:
      begin
        if AData.IsEmpty then
          AValue := 0
        else
          AValue := AData.ToDouble;
      end;

    tkEnumeration:
      begin
        if (AValue.TypeInfo = System.TypeInfo(Boolean)) then
          AValue := StrToBoolDef(AData, False) // AData.ToBoolean()   //  AValue := AValue.AsBoolean
        else
          AValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(AValue.TypeInfo, AData));
      end;

    tkSet:
      begin
         Idx := StringToSet(AValue.TypeInfo, AData);
         TValue.Make(@Idx, AValue.TypeInfo, AValue);
      end;

  else
    raise ENotSupportedException.Create(ExNotSupportedExceptionText);
  end;
end;

class function TConfigReflection.GetIniAttribute(const Obj: TRttiObject): SettingAttribute;
var
  LAttr: TCustomAttribute;
begin
  for LAttr in Obj.GetAttributes do
    if LAttr is SettingAttribute then
      Exit(SettingAttribute(LAttr));

  Result := nil;
end;

class procedure TConfigReflection.Load(AObj: TObject; AHandler: ISettingHandler);
var
  RCtx: TRttiContext;
  RType : TRttiType;
  RProp: TRttiProperty;
  RField: TRttiField;

  LSetAttrib: SettingAttribute;
  LValue: TValue;
  LData: string;
begin
  RCtx := TRttiContext.Create;
  RType := RCtx.GetType(AObj.ClassInfo);
  for RProp in RType.GetProperties do
  begin
    LSetAttrib := GetIniAttribute(RProp);
    if Assigned(LSetAttrib) then
    begin
      if Assigned(AHandler) then
        LData := AHandler.ReadString(LSetAttrib.Section, LSetAttrib.Key, LSetAttrib.DefaultValue)
      else
        LData := LSetAttrib.DefaultValue;

      LValue := RProp.GetValue(AObj);
      SetValue(LData, LValue);
      RProp.SetValue(AObj, LValue);
    end;
  end;

  for RField in RType.GetFields do
  begin
    LSetAttrib := GetIniAttribute(RField);
    if Assigned(LSetAttrib) then
    begin
      if Assigned(AHandler) then
        LData := AHandler.ReadString(LSetAttrib.Section, LSetAttrib.Key, LSetAttrib.DefaultValue)
      else
        LData := LSetAttrib.DefaultValue;

      LValue := RField.GetValue(AObj);
      SetValue(LData, LValue);
      RField.SetValue(AObj, LValue);
    end;
  end;
end;

class procedure TConfigReflection.Save(AObj: TObject; AHandler: ISettingHandler);
var
  RCtx: TRttiContext;
  RType: TRttiType;
  RField: TRttiField;
  RProp: TRttiProperty;

  LSetAttrib: SettingAttribute;
  LValue: TValue;
  LData: string;
begin
  RCtx := TRttiContext.Create;
  RType := RCtx.GetType(AObj.ClassInfo);
  for RProp in RType.GetProperties do
  begin
    LSetAttrib := GetIniAttribute(RProp);
    if Assigned(LSetAttrib) then
    begin
      LValue := RProp.GetValue(AObj);
      LData  := GetValue(LValue);
      if Assigned(AHandler) then
        AHandler.WriteString(LSetAttrib.Section, LSetAttrib.Key, LData);
    end;
  end;

  for RField in RType.GetFields do
  begin
    LSetAttrib := GetIniAttribute(RField);
    if Assigned(LSetAttrib) then
    begin
      LValue := RField.GetValue(AObj);
      LData  := GetValue(LValue);
      if Assigned(AHandler) then
        AHandler.WriteString(LSetAttrib.Section, LSetAttrib.Key, LData);
    end;
  end;

  RCtx.Free;
end;

end.
