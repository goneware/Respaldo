unit Unit1;

interface

uses
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  System.Classes,
  Vcl.Controls,
  uClassCFDiReader;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  LeeCFdi: tClassCFDiReader;
  archivo: string;
  _listaDeConceptos: listaConceptos;
  _listaDeImpuestos: listaImpuestos;
  I: Integer;
begin
  if not openDialog1.Execute then exit;

  archivo := openDialog1.FileName;
  LeeCFdi := tClassCFDiReader.Create(archivo);
  Memo1.Lines.Add(LeeCFdi.regresaValor(1,'folio'));

  Memo1.Lines.Add(LeeCFdi.regresaValor(2,'rfc'));
  Memo1.Lines.Add(LeeCFdi.regresaValor(2,'nombre'));
  Memo1.Lines.Add(LeeCFdi.regresaValor(3,'calle'));
  Memo1.Lines.Add(LeeCFdi.regresaValor(3,'colonia'));
  Memo1.Lines.Add(LeeCFdi.regresaValor(3,'municipio'));
  Memo1.Lines.Add(LeeCFdi.regresaValor(3,'estado'));
  Memo1.Lines.Add(LeeCFdi.regresaValor(3,'codigoostal'));
  Memo1.Lines.Add('');

  _listaDeConceptos := LeeCFdi.regresaConceptos;
  for I := Low(_listaDeConceptos) to High(_listaDeConceptos) do
  begin
    Memo1.Lines.Add(_listaDeConceptos[I].cantidad);
    Memo1.Lines.Add(_listaDeConceptos[I].unidad);
    Memo1.Lines.Add(_listaDeConceptos[I].descripcion);
    Memo1.Lines.Add(_listaDeConceptos[I].valorUnitario);
    Memo1.Lines.Add(_listaDeConceptos[I].importe);
    Memo1.Lines.Add('');
  end;
  Memo1.Lines.Add('');

  _listaDeImpuestos := LeeCFdi.regresaImpuestos;
  for I := Low(_listaDeImpuestos) to High(_listaDeImpuestos) do
  begin
    Memo1.Lines.Add(_listaDeImpuestos[I].impuesto);
    Memo1.Lines.Add(_listaDeImpuestos[I].tasa);
    Memo1.Lines.Add(_listaDeImpuestos[I].importe);
    Memo1.Lines.Add('');
  end;
  Memo1.Lines.Add('');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
