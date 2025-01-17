//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade ordem;
string dadosParaLinhaV[20];
datetime horarioDasordens[20];
bool estaNoModoReal = false;
int prinmeiroBreak = 10, breakEven = 20;
input double lotes = 0.01; // QUANTIDADE DE LOTES


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   modoRealouDemo();
   adicionaCorNoGrafico();
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   acoesModoReal();
   acoesParaOhorarioEspecifico();
   enviarOrdem();
   breakeven();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void verificaSeExisteDados()
  {
   if(FileIsExist("mt5-2.txt",FILE_COMMON))
     {
      LerDadosSalvos();
     }
   else
     {
      Print("! ANTES DE FAZE TESTES DO ROBO NO MODO BACKTEST, ADICIONE O ROBO NO GRAFICO REAL PARA SALVAR AS NOTICIAS !");
      ExpertRemove();
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modoRealouDemo()
  {
   int mod = MQLInfoInteger(MQL_TESTER);
   if(mod == 1)//MODO BACKTEST
     {
      verificaSeExisteDados();
     }
   if(mod == 0)//MODO OPERACIONAL
     {
      estaNoModoReal = true;
      if(!TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         Alert("VERIFIQUE SUA CONECÇÃO COM A INTERNET PARA PODER SALVAR OS DADOS");
         ExpertRemove();
        }
      validaUsuario();
      salvarDados();
      LerDadosSalvos();
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void salvarDados()
  {
   string dados[1000];
   int operador = 0;
   ushort caracter;

   MqlDateTime data;
   TimeToStruct(iTime(_Symbol,PERIOD_D1,0),data);

   MqlCalendarValue valores[];
   datetime dataInicial = iTime(_Symbol,PERIOD_MN1,5);
   string dataFinal = (TimeToString(TimeCurrent(),TIME_DATE))+" 23:58:00";
   CalendarValueHistory(valores,dataInicial,dataFinal,NULL,NULL);
   for(int i=0;i<ArraySize(valores);i++)
     {
      MqlCalendarEvent evento;
      CalendarEventById(valores[i].event_id,evento);
      MqlCalendarCountry country;
      CalendarCountryById(evento.country_id,country);
      caracter = StringGetCharacter(" ",0);
      string textEvent[];
      StringSplit(evento.name,caracter,textEvent);
      for(int ind=0;ind<ArraySize(textEvent);ind++)
        {
         if(textEvent[ind] == "(IPC)" || textEvent[ind] == "(IPP)" || textEvent[ind] == "(PMI)" || textEvent[ind] == "(Payroll)")
           {
            operador++;
            dados[operador] = (country.currency+"|"+evento.name+"|"+valores[i].time);
           }
        }
     }
   string dados2[];
   ArrayInsert(dados2,dados,0,0,operador);
   int arquivo = FileOpen("mt5-2.txt",FILE_COMMON|FILE_TXT|FILE_WRITE);
   FileWriteArray(arquivo,dados2,0,operador);
   FileClose(arquivo);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LerDadosSalvos()
  {
   string comentario;
   string dataAtual;
   int resulNegative = 0;
   int operador2 = 0;
   string dadosParaLinhaV2[20];
   dataAtual = TimeToString(TimeCurrent(),TIME_DATE);
   string dadosRecebidosDoBD[];
   int arquivo = FileOpen("mt5-2.txt",FILE_COMMON|FILE_TXT|FILE_READ);
   FileReadArray(arquivo,dadosRecebidosDoBD);
   FileClose(arquivo);

   for(int i=0;i<ArraySize(dadosRecebidosDoBD);i++)
     {
      struct dadosRecebidos
        {
         string      noticia;
         string      ativo;
         string      dataNoticia;
         string      impacto;
        };

      dadosRecebidos pegaDados;
      string dataParaComaracao;
      string elementoDoBd = dadosRecebidosDoBD[i];
      string elementosDivididos[3];
      ushort codigo;

      codigo = StringGetCharacter("|",0);
      StringSplit(elementoDoBd,codigo,elementosDivididos);

      pegaDados.ativo = elementosDivididos[0];
      pegaDados.noticia = elementosDivididos[1];
      pegaDados.dataNoticia = elementosDivididos[2];
      dataParaComaracao = pegaDados.dataNoticia;
      StringSetLength(dataParaComaracao,10);     //tamanho da data

      if(dataParaComaracao == dataAtual)
        {
         operador2++;
         comentario += "\n"+pegaDados.ativo+"|"+pegaDados.noticia+"|"+pegaDados.dataNoticia;
         Comment(comentario);
         dadosParaLinhaV[operador2] = pegaDados.dataNoticia;
        }

     }
   criarHorarioParaOrdem();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void resetandoAsVariaveis()
  {
   if(TimeToString(TimeCurrent(),TIME_SECONDS) == "00:01:00")
     {
      for(int i=0;i<ArraySize(dadosParaLinhaV);i++)
        {
         dadosParaLinhaV[i] = NULL;
        }
      LerDadosSalvos();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void acoesModoReal()
  {
   if(estaNoModoReal == true)
     {
      salvarDados();
     }
   resetandoAsVariaveis();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void acoesParaOhorarioEspecifico()
  {
   for(int i=0;i<ArraySize(dadosParaLinhaV);i++)
     {
      if(dadosParaLinhaV[i] != NULL)
        {
         desenhaLinhavertical("linha"+i,StringToTime(dadosParaLinhaV[i]));
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void criarHorarioParaOrdem()
  {
   MqlDateTime horariosReais;
   for(int i=0;i<ArraySize(dadosParaLinhaV);i++)
     {
      if(dadosParaLinhaV[i] != NULL)
        {
         TimeToStruct(StringToTime(dadosParaLinhaV[i]),horariosReais);
         if(horariosReais.min == "0")
           {
            horariosReais.hour -= 1;
            horariosReais.min = "59";
            horariosReais.sec = "50";
           }
         else
           {
            horariosReais.min -= 1;
            horariosReais.sec = "50";
           }

         datetime novoHorario = StructToTime(horariosReais);
         horarioDasordens[i] = novoHorario;
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void enviarOrdem()
  {
   MqlRates vela[];
   CopyRates(_Symbol,PERIOD_M5,0,5,vela);
   ArraySetAsSeries(vela,true);
   for(int i=0;i<ArraySize(dadosParaLinhaV);i++)
     {
      if(dadosParaLinhaV[i] != NULL)
        {
         if(TimeCurrent() == dadosParaLinhaV[i])
           {
            for(int i=PositionsTotal();i>=0;i--)
              {
               ordem.PositionClose(PositionGetTicket(i));
               ordem.OrderDelete(OrderGetTicket(i));
              }
            ordem.BuyStop(lotes,vela[1].high+(10*_Point),NULL,0,0,ORDER_TIME_DAY,0,"ORDEM PENDENTE DE COMPRA !");
            ordem.SellStop(lotes,vela[1].low-(10*_Point),NULL,0,0,ORDER_TIME_DAY,0,"ORDEM PENDENTE DE VENDA !");
           }
        }

     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void breakeven()
  {

   for(int i=PositionsTotal();i>=0;i--)
     {
      double operadorBuy,operadorSell;
      if(PositionGetSymbol(i) == _Symbol)
        {
         //+------------------------------------------------------------------+
         //|      breakeven de compra                                         |
         //+------------------------------------------------------------------+

         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            operadorBuy = PositionGetDouble(POSITION_PRICE_CURRENT) - PositionGetDouble(POSITION_SL);
            if(PositionGetDouble(POSITION_SL)> PositionGetDouble(POSITION_PRICE_OPEN))
              {
               if(NormalizeDouble(operadorBuy*100000,1) > prinmeiroBreak)
                 {
                  ordem.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_SL)+(breakEven*_Point),0);
                 }
              }
            else
              {
               if(PositionGetDouble(POSITION_PRICE_CURRENT) >= PositionGetDouble(POSITION_PRICE_OPEN)+(10*_Point))
                 {
                  ordem.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_PRICE_OPEN)+(5*_Point),0);
                 }
              }

           }
         //+------------------------------------------------------------------+
         //|      breakeven de venda                                          |
         //+------------------------------------------------------------------+

         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {
            operadorSell = PositionGetDouble(POSITION_SL)-PositionGetDouble(POSITION_PRICE_CURRENT);
            if(PositionGetDouble(POSITION_SL) < 1)
              {
               if(PositionGetDouble(POSITION_PRICE_CURRENT) <= PositionGetDouble(POSITION_PRICE_OPEN)-(10*_Point))
                 {
                  ordem.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_PRICE_OPEN)-(5*_Point),0);
                 }
              }
            else
              {
               if(PositionGetDouble(POSITION_SL) < PositionGetDouble(POSITION_PRICE_OPEN))
                 {
                  if(NormalizeDouble(operadorSell*100000,1) > prinmeiroBreak)
                    {

                     ordem.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_SL)-(breakEven*_Point),0);
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
   ENUM_TRADE_TRANSACTION_TYPE type = trans.type;

   if(type == TRADE_TRANSACTION_DEAL_ADD)
     {

      long     deal_reason       = -1;

      if(HistoryDealSelect(trans.deal))
        {
         deal_reason       = HistoryDealGetInteger(trans.deal, DEAL_REASON);
        }
      else
        {
         return;
        }
      if(deal_reason == DEAL_REASON_SL)
        {
         for(int i=OrdersTotal();i>=0;i--)
           {
            ordem.PositionClose(PositionGetTicket(i));
            ordem.OrderDelete(OrderGetTicket(i));
           }
        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void validaUsuario()
  {
   MqlDateTime dataValida,dataAtua;
   string text;
   string result[];
   ushort codigo;
   string usuario = AccountInfoInteger(ACCOUNT_LOGIN);
   int arquivo = FileOpen("licença.txt",FILE_COMMON|FILE_TXT|FILE_READ);
   text = FileReadString(arquivo);
   if(text == "")
     {
      Alert("ADICIONE A LICENÇA NO ENDEREÇO DA PASTA ABAIXO ! \n \n"+TerminalInfoString(TERMINAL_COMMONDATA_PATH)+"\Files");
      ExpertRemove();
     }
   else
     {
      codigo = StringGetCharacter("|",0);
      StringSplit(text,codigo,result);
      FileClose(arquivo);
      if(usuario != StringToInteger(result[3]))
        {
         Alert("O NUMERO QUE VOÇE PASSOU PARA O ADM ESTA DIFERENTE DA CONTA ATUAL, ENTRE EM CONTATO COM ADIMINISTRADOR DO ROBO !");
         ExpertRemove();
        }
      else
        {


         if(StringToTime(result[1]) < TimeCurrent())
           {
            Alert("SUA DATA DE VALIDADE EXPIROU ! ",result[1]);
            ExpertRemove();
           }

         Print("OLÁ ",result[5],", A DATA DE VALIDADE DESSE ROBO E ",result[1]);
        }
     }

  }

//SETOR GRAFICO
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void adicionaCorNoGrafico()
  {
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_OHLC,false);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,true);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrGreen);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrGreen);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrRed);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void desenhaLinhavertical(string nome, datetime time, color cor = clrYellow)
  {
   ObjectCreate(0,nome,OBJ_VLINE,0,time,0);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,cor);
  }
//+------------------------------------------------------------------+
