{
   Clase para la extracción de información de archivos xml de facturación
   electrónica (CFDi).

   Autor: Eliseo González Nieto
   Fecha: 20 de Mayo de 2016
}

unit uClassCFDiReader;

interface

uses
  System.SysUtils,
  Xml.XMLIntf,
  xml.xmlDoc;

type
  comprobante = array of record
     campo: string;
     valor: string;
  end;

  emisor = array of record
     campo: string;
     valor: string;
  end;

  domicilioEmisor = array of record
     campo: string;
     valor: string;
  end;

  receptor = array of record
     campo: string;
     valor: string;
  end;

  domicilioReceptor = array of record
     campo: string;
     valor: string;
  end;

  timbre = array of record
     campo: string;
     valor: string;
  end;

  conceptos = array of record
     campo: string;
     valor: string;
  end;

  impuestos = array of record
     campo: string;
     valor: string;
  end;

  listaConceptos = array of record
     cantidad: string;
     unidad: string;
     descripcion: string;
     valorUnitario: string;
     importe: string;
  end;

//  listaRetenciones = array of record
//     impuesto: string;
//     importe: string;
//  end;

  listaImpuestos = array of record
     impuesto: string;
     tasa: string;
     importe: string;
  end;

  tClassCFDiReader = class
  private
    xml: IXMLDocument;
    nodoComprobante: IXMLNode;
    nodoEmisor: IXMLNode;
    nodoDomEmisor: IXMLNode;
    nodoReceptor: IXMLNode;
    nodoDomReceptor: IXMLNode;
    nodoConceptos: IXMLNode;
    nodoConcepto: IXMLNode;
    nodoImpuestos: IXMLNode;
    nodoTraslados: IXMLNode;
    nodoTraslado: IXMLNode;
    nodoComplemento: IXMLNode;
    nodoTimbre: IXMLNode;

    procedure leeCFDi(const archivo: string);

  public
    _comprobante: comprobante;
    _emisor: emisor;
    _domEmisor: domicilioEmisor;
    _receptor: receptor;
    _domReceptor: domicilioReceptor;
    _arrConceptos: array of conceptos;
    _conceptos: conceptos;
    _arrTraslados: array of impuestos;
    _traslado: impuestos;
    _timbre: timbre;
    /// <summary>Método Create</summary>
    /// <param name="archivo"><see cref="uClassCFDiReader|System.string" /></param>
    /// <remarks>Realiza la creación del objeto CFDiReader y leé la factura electrónica (CFDi)
    /// contenida en el archivo XML declarado en el parámetro [archivo].
    /// En dicho parametro se debe indicar la ruta y el nombre del archivo XML a procesar</remarks>
    constructor create(const archivo: string);
    /// <summary>Función regresaValor(Nodo,Campo) - Retorna el valor del campo del nodo solicitado</summary>
    /// <param name="Nodo"><see cref="uClassCFDiReader|System.Integer" /></param>
    /// <param name="Campo"><see cref="uClassCFDiReader|System.string" /></param>
    /// <remarks> Los nodos disponibles son: 1 - Comprobante, 2 - Emisor, 3 - domicilioEmisor,
    /// 4 - Receptor, 5 - domicilioReceptor, 6 - Timbre. Los campos dependerán del nodo a buscar.</remarks>
    function regresaValor(const Nodo: Integer; Campo: string): string;
    /// <summary>Función regresaConceptos</summary>
    /// <remarks> Retorna una lista de los conceptos de la factura.</remarks>
    function regresaConceptos: listaConceptos;
    /// <summary>Función regresaImpuestos</summary>
    /// <remarks> Retorna una lista de los Impuestos trasladados de la factura.</remarks>
    function regresaImpuestos: listaImpuestos;
  end;

implementation

{ tClassCFDiReader }

constructor tClassCFDiReader.create(const archivo: string);
begin
  leeCFDi(archivo);
end;

procedure tClassCFDiReader.leeCFDi;
var
  I: integer;
  J: Integer;
begin
  xml := NewXMLDocument;
  xml.LoadFromFile( archivo );

  nodoComprobante := xml.ChildNodes.FindNode('Comprobante');
  SetLength(_comprobante, nodoComprobante.AttributeNodes.Count);
  for I := 0 to nodoComprobante.AttributeNodes.Count-1 do
  begin
    _comprobante[I].campo :=  nodoComprobante.AttributeNodes[I].NodeName;
    _comprobante[I].valor :=  nodoComprobante.AttributeNodes[I].NodeValue;
  end;

  nodoEmisor := nodoComprobante.ChildNodes.FindNode('Emisor');
  SetLength(_emisor, nodoEmisor.AttributeNodes.Count);
  for I := 0 to nodoEmisor.AttributeNodes.Count-1 do
  begin
    _emisor[I].campo := nodoEmisor.AttributeNodes[I].NodeName;
    _emisor[I].valor := nodoEmisor.AttributeNodes[I].NodeValue;
  end;

  nodoDomEmisor := nodoEmisor.ChildNodes.FindNode('DomicilioFiscal');
  SetLength(_domEmisor, nodoDomEmisor.AttributeNodes.Count);
  for I := 0 to nodoDomEmisor.AttributeNodes.Count-1 do
  begin
    _domEmisor[I].campo := nodoDomEmisor.AttributeNodes[I].NodeName;
    _domEmisor[I].valor := nodoDomEmisor.AttributeNodes[I].NodeValue;
  end;

  nodoReceptor := nodoComprobante.ChildNodes.FindNode('Receptor');
  SetLength(_receptor, nodoReceptor.AttributeNodes.Count);
  for I := 0 to nodoEmisor.AttributeNodes.Count-1 do
  begin
    _receptor[I].campo := nodoReceptor.AttributeNodes[I].NodeName;
    _receptor[I].valor := nodoReceptor.AttributeNodes[I].NodeValue;
  end;

  nodoDomReceptor := nodoReceptor.ChildNodes.FindNode('Domicilio');
  SetLength(_domReceptor, nodoDomReceptor.AttributeNodes.Count);
  for I := 0 to nodoDomReceptor.AttributeNodes.Count-1 do
  begin
    _domReceptor[I].campo := nodoDomReceptor.AttributeNodes[I].NodeName;
    _domReceptor[I].valor := nodoDomReceptor.AttributeNodes[I].NodeValue;
  end;

  nodoConceptos := nodoComprobante.ChildNodes.FindNode('Conceptos');
  SetLength(_arrConceptos, nodoConceptos.ChildNodes.Count);
  for I := 0 to nodoConceptos.ChildNodes.Count-1 do
  begin
    nodoConcepto := nodoConceptos.ChildNodes[I];
    SetLength(_conceptos, nodoConcepto.AttributeNodes.Count);
    for J := 0 to nodoConcepto.AttributeNodes.Count-1 do
    begin
      _conceptos[J].campo := nodoConcepto.AttributeNodes[J].NodeName;
      _conceptos[J].valor := nodoConcepto.AttributeNodes[J].NodeValue;
    end;
    _arrConceptos[I] := _conceptos;
  end;

  nodoImpuestos := nodoComprobante.ChildNodes.FindNode('Impuestos');
  nodoTraslados := nodoImpuestos.ChildNodes.FindNode('Traslados');
  SetLength(_arrTraslados, nodoTraslados.ChildNodes.Count);
  for I := 0 to nodoTraslados.ChildNodes.Count-1 do
  begin
    nodoTraslado := nodoTraslados.ChildNodes[I];
    SetLength(_traslado, nodoTraslado.AttributeNodes.Count);
    for J := 0 to nodoTraslado.AttributeNodes.Count-1 do
    begin
      _traslado[J].campo := nodoTraslado.AttributeNodes[J].NodeName;
      _traslado[J].valor := nodoTraslado.AttributeNodes[J].NodeValue;
    end;
    _arrTraslados[I] := _traslado;
  end;

  nodoComplemento := nodoComprobante.ChildNodes.FindNode('Complemento');
  nodoTimbre := nodoComplemento.ChildNodes[0];
  SetLength(_timbre, nodoTimbre.AttributeNodes.Count);
  for I := 0 to nodoTimbre.AttributeNodes.Count-1 do
  begin
    _timbre[I].campo := nodoTimbre.AttributeNodes[I].NodeName;
    _timbre[I].valor := nodoTimbre.AttributeNodes[I].NodeValue;
  end;

end;

function tClassCFDiReader.regresaConceptos: listaConceptos;
var
  I: Integer;
  concept: conceptos;
  listaC: listaConceptos;

      function dameValor(const atributo: string; lista: conceptos; Indice: Integer): string;
      var
        Idx: Integer;
      begin
        for Idx := 0 to length(lista) do
        begin
          if SameText(atributo, lista[Indice].campo) then
          begin
            Result := lista[Indice].valor;
            Exit;
          end;
        end;
      end;

begin
  SetLength(listaC, length(_arrConceptos));
    for I := Low(_arrConceptos) to High(_arrConceptos) do
    begin
      concept := _arrConceptos[I];
      listaC[I].cantidad      := dameValor(concept[0].campo, concept, 0);
      listaC[I].unidad        := dameValor(concept[1].campo, concept, 1);
      listaC[I].descripcion   := dameValor(concept[2].campo, concept, 2);
      listaC[I].valorUnitario := dameValor(concept[3].campo, concept, 3);
      listaC[I].importe       := dameValor(concept[4].campo, concept, 4);
    end;
    Result := listaC;
end;

function tClassCFDiReader.regresaImpuestos: listaImpuestos;
var
  I: Integer;
  traslado: impuestos;
  listaI: listaImpuestos;

      function dameValor(const atributo: string; lista: impuestos; Indice: Integer): string;
      var
        Idx: Integer;
      begin
        for Idx := 0 to length(lista) do
        begin
          if SameText(atributo, lista[Indice].campo) then
          begin
            Result := lista[Indice].valor;
            Exit;
          end;
        end;
      end;

begin
    SetLength(listaI, length(_arrTraslados));
    for I := Low(_arrTraslados) to High(_arrTraslados) do
    begin
      traslado := _arrTraslados[I];
      listaI[I].impuesto  := dameValor(traslado[1].campo, traslado, 1);
      listaI[I].tasa      := dameValor(traslado[2].campo, traslado, 2);
      listaI[I].importe   := dameValor(traslado[3].campo, traslado, 3);
    end;
    Result := listaI;
end;

function tClassCFDiReader.regresaValor(const Nodo: Integer; Campo: string): string;
var
  I: Integer;
begin
  case Nodo of
    1: begin
         for I := 0 to length(_comprobante) do
         begin
           if SameText(Campo, _comprobante[I].campo) then
           begin
             Result := _comprobante[I].valor;
             Exit;
           end;
         end;
    end;
    2: begin
         for I := 0 to length(_emisor) do
         begin
           if SameText(Campo, _emisor[I].campo) then
           begin
             Result := _emisor[I].valor;
             Exit;
           end;
         end;
    end;
    3: begin
         for I := 0 to length(_domEmisor) do
         begin
           if SameText(Campo, _domEmisor[I].campo) then
           begin
             Result := _domEmisor[I].valor;
             Exit;
           end;
         end;
    end;
    4: begin
         for I := 0 to length(_receptor) do
         begin
           if SameText(Campo, _receptor[I].campo) then
           begin
             Result := _receptor[I].valor;
             Exit;
           end;
         end;
    end;
    5: begin
         for I := 0 to length(_domReceptor) do
         begin
           if SameText(Campo, _domReceptor[I].campo) then
           begin
             Result := _domReceptor[I].valor;
             Exit;
           end;
         end;
    end;
    6: begin
         for I := 0 to length(_timbre) do
         begin
           if SameText(Campo, _timbre[I].campo) then
           begin
             Result := _timbre[I].valor;
             Exit;
           end;
         end;
    end;
  end;
end;

end.
