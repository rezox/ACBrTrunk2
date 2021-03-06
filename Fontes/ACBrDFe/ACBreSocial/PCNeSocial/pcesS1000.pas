{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 29/02/2016: Guilherme Costa
|*  - Alterado os atributos que n�o estavam de acordo com o leiaute/xsd
******************************************************************************}
{$I ACBr.inc}

unit pcesS1000;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador, ACBrUtil,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS1000Collection = class;
  TS1000CollectionItem = class;
  TevtInfoEmpregador = class;

  {Classes espec�ficas deste evento}
  TInfoEmpregador = class;
  TInfoCadastro = class;
  TDadosIsencao = class;
  TInfoOrgInternacional = class;
  TSoftwareHouseCollection = class;
  TSoftwareHouseCollectionItem = class;
  TInfoComplementares = class;
  TSituacaoPJ = class;
  TSituacaoPF = class;
  TInfoOP = class;
  TInfoEFR = class;
  TInfoEnte = class;

  TS1000Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1000CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1000CollectionItem);
  public
    function Add: TS1000CollectionItem;
    property Items[Index: Integer]: TS1000CollectionItem read GetItem write SetItem; default;
  end;

  TS1000CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FevtInfoEmpregador: TevtInfoEmpregador;
    procedure setevtInfoEmpregador(const Value: TevtInfoEmpregador);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtInfoEmpregador: TevtInfoEmpregador read FevtInfoEmpregador write setevtInfoEmpregador;
  end;

  TevtInfoEmpregador = class(TeSocialEvento) //Classe do elemento principal do XML do evento!
  private
    FModoLancamento: TModoLancamento;
    FIdeEvento: TIdeEvento;
    FIdeEmpregador: TIdeEmpregador;
    FInfoEmpregador: TInfoEmpregador;
    FACBreSocial: TObject;

    {Geradores espec�ficos desta classe}
    procedure GerarInfoCadastro;
    procedure GerarDadosIsencao;
    procedure GerarContato;
    procedure GerarInfoOp;
    procedure GerarInfoEFR;
    procedure GerarInfoEnte;
    procedure GerarInfoOrgInternacional;
    procedure GerarSoftwareHouse;
    procedure GerarSituacaoPJ;
    procedure GerarSituacaoPF;
    procedure GerarInfoComplementares;
  public
    constructor Create(AACBreSocial: TObject); overload;
    destructor  Destroy; override;

    function  GerarXML(ATipoEmpregador: TEmpregador): Boolean; override;

    property ModoLancamento: TModoLancamento read FModoLancamento write FModoLancamento;
    property ideEvento: TIdeEvento read FIdeEvento write FIdeEvento;
    property ideEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property infoEmpregador: TInfoEmpregador read FInfoEmpregador write FInfoEmpregador;
  end;

  TInfoEmpregador = class(TPersistent)
  private
    FidePeriodo: TIdePeriodo;
    FinfoCadastro: TInfoCadastro;
    FNovaValidade: TidePeriodo;

    function getInfoCadastro(): TInfoCadastro;
    function getNovaValidade(): TidePeriodo;
  public
    constructor Create;
    destructor Destroy; override;

    function infoCadastroInst(): Boolean;
    function novaValidadeInst(): Boolean;

    property idePeriodo: TIdePeriodo read FidePeriodo write FidePeriodo;
    property infoCadastro: TInfoCadastro read getInfoCadastro write FinfoCadastro;
    property novaValidade: TIdePeriodo read getNovaValidade write FnovaValidade;
  end;

  TInfoCadastro = class(TPersistent)
  private
    FNmRazao: String;
    FClassTrib: TpClassTrib;
    FNatJurid: String;
    FIndCoop: TpIndCoop;
    FIndConstr: TpIndConstr;
    FIndDesFolha: TpIndDesFolha;
    FIndOptRegEletron: TpIndOptRegEletron;
    FIndEntEd: tpSimNao;
    FIndEtt: tpSimNao;
    FNrRegEtt: String;
    FDadosIsencao: TDadosIsencao;
    FContato: TContato;
    FInfoOp: TInfoOp;
    FInfoOrgInternacional: TInfoOrgInternacional;
    FSoftwareHouse: TSoftwareHouseCollection;
    FInfoComplementares: TInfoComplementares;

    function getInfoOp(): TInfoOp;
    function getDadosIsencao(): TDadosIsencao;
    function getInfoOrgInternacional(): TInfoOrgInternacional;
  public
    constructor Create;
    destructor Destroy; override;

    function infoOrgInternacionalInst(): Boolean;
    function dadosIsencaoInst(): Boolean;
    function infoOpInst(): Boolean;

    property NmRazao: String read FNmRazao write FNmRazao;
    property ClassTrib: TpClassTrib read FClassTrib write FClassTrib;
    property NatJurid: String read FNatJurid write FNatJurid;
    property IndCoop: TpIndCoop read FIndCoop write FIndCoop;
    property IndConstr: TpIndConstr read FIndConstr write FIndConstr;
    property IndDesFolha: TpIndDesFolha read FIndDesFolha write FIndDesFolha;
    property IndOptRegEletron: TpIndOptRegEletron read FIndOptRegEletron write FIndOptRegEletron;
    property IndEntEd: tpSimNao read FIndEntEd write FIndEntEd;
    property IndEtt: tpSimNao read FIndEtt write FIndEtt;
    property nrRegEtt: String read FNrRegEtt write FNrRegEtt;
    property DadosIsencao: TDadosIsencao read getDadosIsencao write FDadosIsencao;
    property Contato: TContato read FContato write FContato;
    property InfoOp: TInfoOp read getInfoOp write FInfoOp;
    property InfoOrgInternacional: TInfoOrgInternacional read getInfoOrgInternacional write FInfoOrgInternacional;
    property SoftwareHouse: TSoftwareHouseCollection read FSoftwareHouse write FSoftwareHouse;
    property InfoComplementares: TInfoComplementares read FInfoComplementares write FInfoComplementares;
  end;

  TInfoComplementares = class(TPersistent)
  private
    FSituacaoPJ: TSituacaoPJ;
    FSituacaoPF: TSituacaoPF;

    function getSituacaoPJ(): TSituacaoPJ;
    function getSituacaoPF(): TSituacaoPF;
  public
    destructor destroy; override;

    function situacaoPFInst(): Boolean;
    function situacaoPJInst(): Boolean;

    property SituacaoPJ: TSituacaoPJ read getSituacaoPJ write FSituacaoPJ;
    property SituacaoPF: TSituacaoPF read getSituacaoPF write FSituacaoPF;
  end;

  TSituacaoPJ = class(TPersistent)
  private
    FIndSitPJ: tpIndSitPJ;
  public
    property IndSitPJ: tpIndSitPJ read FIndSitPJ write FIndSitPJ;
  end;

  TSituacaoPF = class(TPersistent)
  private
    FIndSitPF: tpIndSitPF;
  public
    property IndSitPF: tpIndSitPF read FIndSitPF write FIndSitPF;
  end;

  TDadosIsencao = class(TPersistent)
  private
    FIdeMinLei: String;
    FNrCertif: String;
    FDtEmisCertif : TDateTime;
    FDtVencCertif: TDateTime;
    FNrProtRenov: String;
    FDtProtRenov: TDateTime;
    FDtDou: TDateTime;
    FPagDou: String;
  public
    property IdeMinLei: String read FIdeMinLei write FIdeMinLei;
    property NrCertif: String read FNrCertif write FNrCertif;
    property DtEmisCertif: TDateTime read FDtEmisCertif write FDtEmisCertif;
    property DtVencCertif: TDateTime read FDtVencCertif write FDtVencCertif;
    property NrProtRenov: String read FNrProtRenov write FNrProtRenov;
    property DtProtRenov: TDateTime read FDtProtRenov write FDtProtRenov;
    property DtDou: TDateTime read FDtDou write FDtDou;
    property PagDou: String read FPagDou write FPagDou;
  end;

  TInfoOrgInternacional = class(TPersistent)
  private
    FIndAcordoIsenMulta: tpIndAcordoIsencaoMulta;
  public
    property IndAcordoIsenMulta: tpIndAcordoIsencaoMulta read FIndAcordoIsenMulta write FIndAcordoIsenMulta;
  end;

  TSoftwareHouseCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TSoftwareHouseCollectionItem;
    procedure SetItem(Index: Integer; Value: TSoftwareHouseCollectionItem);
  public
    constructor create(); reintroduce;
    function Add: TSoftwareHouseCollectionItem;
    property Items[Index: Integer]: TSoftwareHouseCollectionItem read GetItem write SetItem; default;
  end;

  TSoftwareHouseCollectionItem = class(TCollectionItem)
  private
    FCnpjSoftHouse: String;
    FNmRazao: String;
    FNmCont: String;
    FTelefone: String;
    Femail: String;
  public
    constructor create; reintroduce;

    property CnpjSoftHouse: String read FCnpjSoftHouse write FCnpjSoftHouse;
    property NmRazao: String read FNmRazao write FNmRazao;
    property NmCont: String read FNmCont write FNmCont;
    property Telefone: String read FTelefone write FTelefone;
    property email: String read Femail write Femail;
  end;

  TInfoEFR = class(TPersistent)
  private
     FideEFR: tpSimNao;
     FcnpjEFR: String;
  public
    property ideEFR: tpSimNao read FideEFR write FideEFR;
    property cnpjEFR: String read FcnpjEFR write FcnpjEFR;
  end;

  TInfoEnte = class(TPersistent)
  private
    FNmEnte: String;
    FUf: tpuf;
    FCodMunic: Integer;
    FIndRPPS: tpSimNao;
    FSubteto: tpIdeSubteto;
    FVrSubTeto: Double;
  public
    property nmEnte: String read FNmEnte write FNmEnte;
    property uf: tpuf read FUf write FUf;
    property codMunic: Integer read FCodMunic write FCodMunic;
    property indRPPS: tpSimNao read FIndRPPS write FIndRPPS;
    property subteto: tpIdeSubteto read FSubteto write FSubteto;
    property vrSubteto: Double read FVrSubTeto write FVrSubTeto;
  end;

  TInfoOp = class(TPersistent)
  private
     FNrSiafi: String;
     FInfoEFR: TInfoEFR;
     FInfoEnte: TInfoEnte;

     function getInfoEFR(): TInfoEFR;
     function getInfoEnte(): TInfoEnte;
  public
    constructor Create;
    destructor Destroy; override;
    
    function InfoEFRInst(): Boolean;
    function InfoEnteInst(): Boolean;

    property nrSiafi: String read FNrSiafi write FNrSiafi;
    property infoEFR: TInfoEFR read getInfoEFR write FInfoEFR;
    property infoEnte: TInfoEnte read getInfoEnte write FInfoEnte;
  end;

implementation

{ TS1000Collection }

function TS1000Collection.Add: TS1000CollectionItem;
begin
  Result := TS1000CollectionItem(inherited Add);
end;

function TS1000Collection.GetItem(Index: Integer): TS1000CollectionItem;
begin
  Result := TS1000CollectionItem(inherited GetItem(Index));
end;

procedure TS1000Collection.SetItem(Index: Integer; Value: TS1000CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS1000CollectionItem }

procedure TS1000CollectionItem.AfterConstruction;
begin
  inherited;
  FTipoEvento := teS1000;
  FevtInfoEmpregador := TevtInfoEmpregador.Create(Collection.Owner);
end;

procedure TS1000CollectionItem.BeforeDestruction;
begin
  inherited;
  FevtInfoEmpregador.Free;
end;

procedure TS1000CollectionItem.setevtInfoEmpregador(const Value: TevtInfoEmpregador);
begin
  FevtInfoEmpregador.Assign(Value);
end;

{ TevtInfoEmpregador }

constructor TevtInfoEmpregador.Create(AACBreSocial: TObject);
begin
  inherited;

  FACBreSocial := AACBreSocial;
  FIdeEmpregador:= TIdeEmpregador.create;
  FIdeEvento:= TIdeEvento.create;
  FInfoEmpregador := TInfoEmpregador.Create;
end;

destructor TevtInfoEmpregador.Destroy;
begin
  FIdeEmpregador.Free;
  FIdeEvento.Free;
  FInfoEmpregador.Free;

  inherited;
end;

procedure TevtInfoEmpregador.GerarContato;
begin
  Gerador.wGrupo('contato');
  Gerador.wCampo(tcStr, '', 'nmCtt',     1, 70, 1, Self.infoEmpregador.infoCadastro.Contato.NmCtt);
  Gerador.wCampo(tcStr, '', 'cpfCtt',   11, 11, 1, Self.infoEmpregador.infoCadastro.Contato.CpfCtt);
  Gerador.wCampo(tcStr, '', 'foneFixo',  1, 13, 0, Self.infoEmpregador.infoCadastro.Contato.FoneFixo);
  Gerador.wCampo(tcStr, '', 'foneCel',   1, 13, 0, Self.infoEmpregador.infoCadastro.Contato.FoneCel);
  Gerador.wCampo(tcStr, '', 'email',     1, 60, 0, Self.infoEmpregador.infoCadastro.Contato.email);

  Gerador.wGrupo('/contato');
end;

procedure TevtInfoEmpregador.GerarInfoEFR;
begin
  if infoEmpregador.infoCadastro.InfoOp.InfoEFRInst() and (infoEmpregador.infoCadastro.InfoOp.infoEFR.cnpjEFR <> EmptyStr) then
  begin
    Gerador.wGrupo('infoEFR');

    Gerador.wCampo(tcStr, '', 'ideEFR',   1,  1, 1, eSSimNaoToStr(infoEmpregador.infoCadastro.InfoOp.infoEFR.ideEFR));
    Gerador.wCampo(tcStr, '', 'cnpjEFR', 14, 14, 0, infoEmpregador.infoCadastro.InfoOp.infoEFR.cnpjEFR);

    Gerador.wGrupo('/infoEFR')
  end;
end;

procedure TevtInfoEmpregador.GerarInfoEnte;
begin
  if infoEmpregador.infoCadastro.InfoOp.InfoEnteInst() and (infoEmpregador.infoCadastro.InfoOp.infoEnte.nmEnte <> EmptyStr) then
  begin
    Gerador.wGrupo('infoEnte');

    Gerador.wCampo(tcStr, '', 'nmEnte',    1, 100, 1, infoEmpregador.infoCadastro.InfoOp.infoEnte.nmEnte);
    Gerador.wCampo(tcStr, '', 'uf',        2,   2, 1, eSufToStr(infoEmpregador.infoCadastro.InfoOp.infoEnte.uf));
    Gerador.wCampo(tcInt, '', 'codMunic',  7,   7, 0, infoEmpregador.infoCadastro.InfoOp.infoEnte.codMunic);
    Gerador.wCampo(tcStr, '', 'indRPPS',   1,   1, 1, eSSimNaoToStr(infoEmpregador.infoCadastro.InfoOp.infoEnte.indRPPS));
    Gerador.wCampo(tcInt, '', 'subteto',   1,   1, 1, eSIdeSubtetoToStr(infoEmpregador.infoCadastro.InfoOp.infoEnte.subteto));
    Gerador.wCampo(tcDe2, '', 'vrSubteto', 1,  14, 1, infoEmpregador.infoCadastro.InfoOp.infoEnte.vrSubteto);

    Gerador.wGrupo('/infoEnte');
  end;
end;

procedure TevtInfoEmpregador.GerarInfoOp;
begin
  if infoEmpregador.infoCadastro.infoOpInst() and (infoEmpregador.infoCadastro.InfoOp.nrSiafi <> EmptyStr) then
  begin
    Gerador.wGrupo('infoOP');

    Gerador.wCampo(tcStr, '', 'nrSiafi', 1, 6, 1, infoEmpregador.infoCadastro.InfoOp.nrSiafi);

    GerarInfoEFR;
    GerarInfoEnte;

    Gerador.wGrupo('/infoOP');
  end;
end;

procedure TevtInfoEmpregador.GerarDadosIsencao;
begin
  if infoEmpregador.infoCadastro.dadosIsencaoInst() then
  begin
    Gerador.wGrupo('dadosIsencao');

    Gerador.wCampo(tcStr, '', 'ideMinLei',     1, 70, 1, infoEmpregador.infoCadastro.DadosIsencao.IdeMinLei);
    Gerador.wCampo(tcStr, '', 'nrCertif',      1, 40, 1, infoEmpregador.infoCadastro.DadosIsencao.NrCertif);
    Gerador.wCampo(tcDat, '', 'dtEmisCertif', 10, 10, 1, infoEmpregador.infoCadastro.DadosIsencao.DtEmisCertif);
    Gerador.wCampo(tcDat, '', 'dtVencCertif', 10, 10, 1, infoEmpregador.infoCadastro.DadosIsencao.DtVencCertif);
    Gerador.wCampo(tcStr, '', 'nrProtRenov',   0, 40, 0, infoEmpregador.infoCadastro.DadosIsencao.NrProtRenov);

    if (DateToStr(infoEmpregador.infoCadastro.DadosIsencao.DtProtRenov) <> dDataBrancoNula) then
      Gerador.wCampo(tcDat, '', 'dtProtRenov', 10, 10, 0, infoEmpregador.infoCadastro.DadosIsencao.DtProtRenov);

    if (DateToStr(infoEmpregador.infoCadastro.DadosIsencao.DtDou) <> dDataBrancoNula) then
      Gerador.wCampo(tcDat, '', 'dtDou', 10, 10, 0, infoEmpregador.infoCadastro.DadosIsencao.DtDou);

    Gerador.wCampo(tcStr, '', 'pagDou', 1, 5, 0, infoEmpregador.infoCadastro.DadosIsencao.PagDou); // N�o deveria ser do tipo Integer

    Gerador.wGrupo('/dadosIsencao');
  end;
end;

procedure TevtInfoEmpregador.GerarInfoCadastro;
begin
  Gerador.wGrupo('infoCadastro');

  Gerador.wCampo(tcStr, '', 'nmRazao',          1, 100, 1, Self.infoEmpregador.infoCadastro.NmRazao);
  Gerador.wCampo(tcStr, '', 'classTrib',        2, 002, 1, tpClassTribToStr(Self.infoEmpregador.infoCadastro.ClassTrib));
  Gerador.wCampo(tcStr, '', 'natJurid',         4, 004, 0, Self.infoEmpregador.infoCadastro.NatJurid); // criar enumerador
  Gerador.wCampo(tcStr, '', 'indCoop',          1, 001, 0, eSIndCooperativaToStr(Self.infoEmpregador.infoCadastro.IndCoop));
  Gerador.wCampo(tcStr, '', 'indConstr',        1, 001, 0, eSIndConstrutoraToStr(Self.infoEmpregador.infoCadastro.IndConstr));
  Gerador.wCampo(tcStr, '', 'indDesFolha',      1, 001, 1, eSIndDesFolhaToStr(Self.infoEmpregador.infoCadastro.IndDesFolha));
  Gerador.wCampo(tcStr, '', 'indOptRegEletron', 1, 001, 1, eSIndOptRegEletronicoToStr(Self.infoEmpregador.infoCadastro.IndOptRegEletron));
  Gerador.wCampo(tcStr, '', 'indEntEd',         1, 001, 0, eSSimNaoToStr(Self.infoEmpregador.infoCadastro.IndEntEd));
  Gerador.wCampo(tcStr, '', 'indEtt',           1, 001, 1, eSSimNaoToStr(Self.infoEmpregador.infoCadastro.IndEtt));
  Gerador.wCampo(tcStr, '', 'nrRegEtt',         0, 030, 0, Self.infoEmpregador.infoCadastro.nrRegEtt);

  GerarDadosIsencao;
  GerarContato;
  GerarInfoOp;
  GerarInfoOrgInternacional;
  GerarSoftwareHouse;
  GerarInfoComplementares;

  Gerador.wGrupo('/infoCadastro');
end;

procedure TevtInfoEmpregador.GerarInfoComplementares;
begin
  Gerador.wGrupo('infoComplementares');

  GerarSituacaoPJ;
  GerarSituacaoPF;

  Gerador.wGrupo('/infoComplementares');
end;

procedure TevtInfoEmpregador.GerarInfoOrgInternacional;
begin
  if infoEmpregador.infoCadastro.infoOrgInternacionalInst() then
  begin
    Gerador.wGrupo('infoOrgInternacional');

    Gerador.wCampo(tcStr, '', 'indAcordoIsenMulta', 1, 1, 1, eSIndAcordoIsencaoMultaToStr(infoEmpregador.infoCadastro.InfoOrgInternacional.IndAcordoIsenMulta));

    Gerador.wGrupo('/infoOrgInternacional');
  end;
end;

procedure TevtInfoEmpregador.GerarSituacaoPF;
begin
  if infoEmpregador.infoCadastro.InfoComplementares.situacaoPFInst() then
  begin
    Gerador.wGrupo('situacaoPF');

    Gerador.wCampo(tcStr, '', 'indSitPF', 1, 1, 1, eSIndSitPFToStr(Self.infoEmpregador.infoCadastro.InfoComplementares.SituacaoPF.IndSitPF));

    Gerador.wGrupo('/situacaoPF');
  end;
end;

procedure TevtInfoEmpregador.GerarSituacaoPJ;
begin
  if infoEmpregador.infoCadastro.InfoComplementares.situacaoPJInst() then
  begin
    Gerador.wGrupo('situacaoPJ');

    Gerador.wCampo(tcStr, '', 'indSitPJ', 1, 1, 1, eSIndSitPJToStr(infoEmpregador.infoCadastro.InfoComplementares.SituacaoPJ.IndSitPJ));

    Gerador.wGrupo('/situacaoPJ');
  end;
end;

procedure TevtInfoEmpregador.GerarSoftwareHouse;
var
  i: Integer;
begin
  for i := 0 to infoEmpregador.infoCadastro.SoftwareHouse.Count - 1 do
  begin
    Gerador.wGrupo('softwareHouse');
    Gerador.wCampo(tcStr, '', 'cnpjSoftHouse', 14,  14, 1, infoEmpregador.infoCadastro.SoftwareHouse[i].CnpjSoftHouse);
    Gerador.wCampo(tcStr, '', 'nmRazao',        1, 100, 1, infoEmpregador.infoCadastro.SoftwareHouse[i].NmRazao);
    Gerador.wCampo(tcStr, '', 'nmCont',         1,  70, 1, infoEmpregador.infoCadastro.SoftwareHouse[i].NmCont);
    Gerador.wCampo(tcStr, '', 'telefone',       1,  13, 1, infoEmpregador.infoCadastro.SoftwareHouse[i].Telefone);
    Gerador.wCampo(tcStr, '', 'email',          1,  60, 0,  infoEmpregador.infoCadastro.SoftwareHouse[i].email);

    Gerador.wGrupo('/softwareHouse');
  end;

  if infoEmpregador.infoCadastro.SoftwareHouse.Count > 99 then
    Gerador.wAlerta('', 'softwareHouse', 'Lista de Software House', ERR_MSG_MAIOR_MAXIMO + '99');
end;

function TevtInfoEmpregador.GerarXML(ATipoEmpregador: TEmpregador): Boolean;
begin
  try
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc,
     self.Sequencial, ATipoEmpregador);

    GerarCabecalho('evtInfoEmpregador');
    Gerador.wGrupo('evtInfoEmpregador Id="' + Self.Id + '"');

    GerarIdeEvento(Self.IdeEvento);
    GerarIdeEmpregador(Self.IdeEmpregador);

    Gerador.wGrupo('infoEmpregador');

    GerarModoAbertura(Self.ModoLancamento);
    GerarIdePeriodo(Self.infoEmpregador.idePeriodo);

    if (Self.ModoLancamento <> mlExclusao) then
    begin
      GerarInfoCadastro;
      if ModoLancamento = mlAlteracao then
        if (InfoEmpregador.novaValidadeInst()) then
          GerarIdePeriodo(InfoEmpregador.novaValidade, 'novaValidade');
    end;

    GerarModoFechamento(Self.ModoLancamento);

    Gerador.wGrupo('/infoEmpregador');
    Gerador.wGrupo('/evtInfoEmpregador');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtInfoEmpregador');

    Validar(schevtInfoEmpregador);
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '');
end;

{ TInfoEmpregador }

constructor TInfoEmpregador.Create;
begin
  inherited;

  FidePeriodo:= TIdePeriodo.Create;
  FinfoCadastro:= nil;
  FNovaValidade:= nil;
end;

destructor TInfoEmpregador.Destroy;
begin
  FidePeriodo.Free;
  FreeAndNil(FinfoCadastro);
  FreeAndNil(FNovaValidade);

  inherited;
end;

function TInfoEmpregador.getInfoCadastro: TInfoCadastro;
begin
  if Not(Assigned(FinfoCadastro)) then
    FinfoCadastro := TInfoCadastro.Create;
  Result := FinfoCadastro;
end;

function TInfoEmpregador.getNovaValidade: TidePeriodo;
begin
  if Not(Assigned(FNovaValidade)) then
    FNovaValidade := TIdePeriodo.Create;
  Result := FNovaValidade;
end;

function TInfoEmpregador.infoCadastroInst: Boolean;
begin
  Result := Assigned(FinfoCadastro);
end;

function TInfoEmpregador.novaValidadeInst: Boolean;
begin
  Result := Assigned(FNovaValidade);
end;

{ TInfoCadastro }

constructor TInfoCadastro.Create;
begin
  FDadosIsencao:= nil;
  FContato := TContato.Create;
  FInfoOrgInternacional := nil;
  FSoftwareHouse := TSoftwareHouseCollection.Create;
  FInfoComplementares := TInfoComplementares.Create;
  FInfoOp := TInfoOp.Create;
end;

function TInfoCadastro.dadosIsencaoInst: Boolean;
begin
  Result := Assigned(FDadosIsencao);
end;

destructor TInfoCadastro.Destroy;
begin
  FreeAndNil(FDadosIsencao);
  FContato.Free;
  FreeAndNil(FInfoOrgInternacional);
  FSoftwareHouse.Free;
  FInfoComplementares.Free;
  FreeAndNil(FInfoOp);

  inherited;
end;

function TInfoCadastro.getInfoOp: TInfoOp;
begin
  if Not(Assigned(FInfoOp)) then
    FInfoOp := TInfoOp.Create;
  Result := FInfoOp;
end;

function TInfoCadastro.infoOpInst: Boolean;
begin
  Result := Assigned(FInfoOp);
end;

function TInfoCadastro.getDadosIsencao: TDadosIsencao;
begin
  if Not(Assigned(FDadosIsencao)) then
    FDadosIsencao := TDadosIsencao.Create;
  Result := FDadosIsencao;
end;

function TInfoCadastro.getInfoOrgInternacional: TInfoOrgInternacional;
begin
  if Not(Assigned(FInfoOrgInternacional)) then
    FInfoOrgInternacional := TInfoOrgInternacional.Create;
  Result := FInfoOrgInternacional;
end;

function TInfoCadastro.infoOrgInternacionalInst: Boolean;
begin
  Result := Assigned(FInfoOrgInternacional);
end;

{ TInfoOp }

constructor TInfoOp.Create;
begin
  FInfoEFR := TInfoEFR.Create;
  FInfoEnte := TInfoEnte.Create;
end;

destructor TInfoOp.Destroy;
begin
  FreeAndNil(FInfoEFR);
  FreeAndNil(FInfoEnte);
end;

function TInfoOp.getInfoEFR: TInfoEFR;
begin
  if Not(Assigned(FInfoEFR)) then
    FInfoEFR := TInfoEFR.Create;
  Result := FInfoEFR;
end;

function TInfoOp.getInfoEnte: TInfoEnte;
begin
  if Not(Assigned(FInfoEnte)) then
     FInfoEnte := TInfoEnte.Create;
  result := FInfoEnte;
end;

function TInfoOp.InfoEFRInst: Boolean;
begin
  result := Assigned(FInfoEFR);
end;

function TInfoOp.InfoEnteInst: Boolean;
begin
  Result := Assigned(FInfoEnte);
end;

{ TInfoComplementares }

destructor TInfoComplementares.destroy;
begin
  FreeAndNil(FSituacaoPJ);
  FreeAndNil(FSituacaoPF);

  inherited;
end;

function TInfoComplementares.getSituacaoPF: TSituacaoPF;
begin
  if Not(Assigned(FSituacaoPF)) then
    FSituacaoPF := TSituacaoPF.Create;
  Result := FSituacaoPF;
end;

function TInfoComplementares.getSituacaoPJ(): TSituacaoPJ;
begin
  if Not(Assigned(FSituacaoPJ)) then
    FSituacaoPJ := TSituacaoPJ.Create;
  Result := FSituacaoPJ;
end;

function TInfoComplementares.situacaoPFInst: Boolean;
begin
  Result := Assigned(FSituacaoPF);
end;

function TInfoComplementares.situacaoPJInst: Boolean;
begin
  Result := Assigned(FSituacaoPJ);
end;

{ TSoftwareHouseCollection }

function TSoftwareHouseCollection.Add: TSoftwareHouseCollectionItem;
begin
  Result := TSoftwareHouseCollectionItem(inherited add());
  Result.Create;
end;

constructor TSoftwareHouseCollection.create;
begin
  Inherited create(TSoftwareHouseCollectionItem);
end;

function TSoftwareHouseCollection.GetItem(
  Index: Integer): TSoftwareHouseCollectionItem;
begin
  Result := TSoftwareHouseCollectionItem(inherited GetItem(Index));
end;

procedure TSoftwareHouseCollection.SetItem(Index: Integer;
  Value: TSoftwareHouseCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TSoftwareHouseCollectionItem }

constructor TSoftwareHouseCollectionItem.create;
begin

end;

end.
