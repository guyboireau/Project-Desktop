unit attrapeTaKarte;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.StdCtrls, Vcl.Imaging.pngimage,IdHTTP,System.Net.HttpClient, System.JSON,MonCoffre ;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    POLabel: TLabel;
    Label3: TLabel;
    pannelClikable: TPanel;
    Image2: TImage;
    Image5: TImage;
    Image: TImage;
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);


    procedure SendIDHTTPRequest;
  private
  num:integer;

  public
    { D�clarations publiques }    function ExtractCardIDFromJSON(JSONStringList: TStringList):String;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Image2Click(Sender: TObject);
var
NewForm: TForm;
begin

  NewForm:=TForm2.Create(self);
  NewForm.ShowModal;
  NewForm.Free;

end;

procedure TForm1.Image3Click(Sender: TObject);
begin
//
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
  Form1.Height:= 1000;
  form1.Width:=500;
  form1.Top:=0;
  SendIDHTTPRequest;
end;



procedure TForm1.SendIDHTTPRequest;
var
  HTTPClient: THTTPClient;
  ResponseContent: TStringStream;
  id:string;
  temp:Tstringlist;
  sl:Tstringlist;
  fileStream:TfileStream;
  FileHandle: THandle;
begin
  HTTPClient := THTTPClient.Create;
  ResponseContent := TStringStream.Create;
  try
    // Effectuer une requ�te GET
    HTTPClient.Get('https://db.ygoprodeck.com/api/v7/randomcard.php', ResponseContent);
    sl:=TStringList.Create;
    sl.LoadFromStream(ResponseContent);
    ResponseContent.Free;
    HTTPClient.Destroy;



    HTTPClient := THTTPClient.Create;
    ResponseContent := TStringStream.Create;
    id:=ExtractCardIDFromJSON(sl);
    HTTPClient.Get('https://images.ygoprodeck.com/images/cards/'+id+'.jpg', ResponseContent);


    if FileExists('MesCartes.txt')<>true then
    begin
      FileCreate('MesCartes.txt');
    end;


    // Utiliser la r�ponse
    // Par exemple, l'enregistrer dans un fichier
//    sl.SaveToFile('chemin_vers_le_fichier_local.Json');

    Image.Picture.LoadFromStream(ResponseContent);
    if MessageDlg('Voulez-vous enregistrer la carte?', mtConfirmation,[mbYes,mbNo],0,mbYes)=mrYes  then
    begin
      temp:=Tstringlist.Create;


      fileStream:=TFileStream.Create('MesCartes.txt', fmOpenWrite or fmShareDenyNone);
      if Assigned(fileStream)=null then

      fileStream:=TFileStream.Create('MesCartes.txt', fmOpenWrite or fmShareDenyNone);
      FileStream.Position := FileStream.Size; // Positionne le curseur de fichier � la fin

      temp.add(id+',');
      temp.SaveToStream(fileStream);
      fileStream.Free;
      temp.Free;


    end;

  finally
    ResponseContent.Free;
    HTTPClient.Free;

  end;
end;

function TForm1.ExtractCardIDFromJSON(JSONStringList: TStringList):String;
var
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
  CardID: Integer;
begin
  JSONValue := TJSONObject.ParseJSONValue(JSONStringList.Text);
  try
    if JSONValue <> nil then
    begin
      JSONObject := JSONValue as TJSONObject;
      if JSONObject.TryGetValue<Integer>('id', CardID) then
        result:=CardID.ToString
      else
        result:='Card ID not found in JSON.';
    end
    else
      Writeln('Invalid JSON format.');
  finally
    JSONValue.Free;
  end;
end;

end.
