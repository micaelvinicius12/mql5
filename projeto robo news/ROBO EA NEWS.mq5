//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade ordem;

MqlRates velas[];
MqlDateTime dta,dta2;
string horaAtual;
string dadosParaLinhaV[15];
string dadosParaLinhaV3[];
bool ativalog = false;
int prinmeiroBreak = 10, breakEven = 20;
input double lotes = 0.01; // QUANTIDADE DE LOTES
string noticiaDoDia;
string NameNotice[15],nameAtivo[15],hourNotice[15];;
string comentarioTela;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   modoRealouDemo();
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_OHLC,false);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,true);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrGreen);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrGreen);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrRed);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);


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
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   funcoesNecessarias();
   enviarOrdem();
   breakeven();

  }
//+------------------------------------------------------------------+
//|    OPERACAO AO VIVO                                              |
//+------------------------------------------------------------------+
void calendario()
  {
   double utilB,utilS;
   int operadorCalen = 0;
   MqlDateTime data,dataStruct;
   TimeToStruct(iTime(_Symbol,PERIOD_D1,0),data);
   MqlCalendarValue valores[];
   datetime dataInicial = iTime(_Symbol,PERIOD_D1,0);
   string dataFinal = (TimeToString(TimeCurrent(),TIME_DATE))+" 23:58:00";
   CalendarValueHistory(valores,dataInicial,dataFinal,NULL,NULL);
   for(int i=0;i<ArraySize(valores);i++)
     {
      MqlCalendarEvent evento;
      CalendarEventById(valores[i].event_id,evento);
      MqlCalendarCountry country;
      CalendarCountryById(evento.country_id,country);
      if(StringFind(_Symbol,country.currency) < 0)
         continue;
    //  calendarioAuxiliar();
      if(evento.importance == CALENDAR_IMPORTANCE_HIGH)
        {
         operadorCalen++;
         hourNotice[operadorCalen] = TimeToString(valores[i].time,TIME_MINUTES);
         NameNotice[operadorCalen] = evento.name;
         nameAtivo[operadorCalen] = country.currency;
         if(NameNotice[operadorCalen] != NULL)
           {
            comentarioTela = comentarioTela +nameAtivo[operadorCalen]+" | "+NameNotice[operadorCalen]+" | "+valores[i].time+"\n";
            desenhaLinhavertical(("linhaAtual"+i),valores[i].time);
            TimeToStruct(valores[i].time,dataStruct);
            if(dataStruct.min =="0")
              {
               dataStruct.min = "59";
               dataStruct.hour -=1;
               dataStruct.sec = "50";
              }
            else
              {
               dataStruct.min -=1;
               dataStruct.sec = "50";
              }

            if(StructToTime(dataStruct) == TimeCurrent())
              {
               for(int i=PositionsTotal();i>=0;i--)
                 {
                  ordem.PositionClose(PositionGetTicket(i));
                  ordem.OrderDelete(OrderGetTicket(i));
                 }

               utilS = velas[1].low-(5*_Point);
               utilB = velas[1].high+(5*_Point);
               if(velas[0].close > velas[1].high+(5*_Point))
                 {
                  utilB = velas[0].high+(5*_Point);
                 }
               if(velas[0].close < velas[1].low-(5*_Point))
                 {
                  utilS = velas[0].low-(5*_Point);
                 }
               ordem.BuyStop(lotes,utilB);
               ordem.SellStop(lotes,utilS);
              };
           }

        }
     }
   Comment(comentarioTela);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void funcoesNecessarias()
  {
   horaAtual = TimeToString(TimeCurrent(),TIME_MINUTES);
   CopyRates(_Symbol,PERIOD_M6,0,10,velas);
   ArraySetAsSeries(velas,true);
   if(TimeToString(TimeCurrent(),TIME_SECONDS) == "00:01:00")
     {
      Print("ATUALIZANDO DADOS");
      modoRealouDemo();
     }
   else
     {
      for(int i=0;i<ArraySize(dadosParaLinhaV3);i++)
        {
         desenhaLinhavertical(("noticia"+i),StringToTime(dadosParaLinhaV3[i]));
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void salvarDados()
  {
   string dados[1000];
   string importancia;
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
         if(textEvent[ind] == "(IPC)" || textEvent[ind] == "(IPP)" || textEvent[ind] == "(PMI)")
           {
            if(evento.importance == CALENDAR_IMPORTANCE_MODERATE)
              {
               importancia = "MEDIO";
               //Print(evento.name, " ",valores[i].time);
               operador++;
               dados[operador] = (country.currency+"|"+evento.name+"|"+valores[i].time+"|"+importancia);
              }

           }
        }
      if(evento.importance == CALENDAR_IMPORTANCE_HIGH)
        {
         importancia = "ALTA";
         operador++;
         dados[operador] = (country.currency+"|"+evento.name+"|"+valores[i].time+"|"+importancia);
        }
     }
   string dados2[];
   ArrayInsert(dados2,dados,0,0,operador);
   int arquivo = FileOpen("mt5.txt",FILE_COMMON|FILE_TXT|FILE_WRITE);
   FileWriteArray(arquivo,dados2,0,operador);
   FileClose(arquivo);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modoRealouDemo()
  {
   int mod = MQLInfoInteger(MQL_TESTER);
   if(mod == 1)//MODO BACKTEST
     {
      leituraDedados();
     }
   if(mod == 0)//MODO OPERACIONAL
     {
      validaUsuario();
      salvarDados();
      calendario();
     }


  }

//+------------------------------------------------------------------+
//|VERIFICAÇÃO DO MODO DE EXECUÇÃO                                   |
//+------------------------------------------------------------------+
void leituraDedados()
  {
   if(FileIsExist("mt5.txt",FILE_COMMON))
     {
      noticiasDoDiaBack();
     }
   else
     {
      Print("! ANTES DE FAZE TESTES DO ROBO NO MODO BACKTEST, ADICIONE O ROBO NO GRAFICO REAL PARA SALVAR AS NOTICIAS !");
      ExpertRemove();
     }

  }

//+------------------------------------------------------------------+
//|OPERA NO BACKTEST                                                 |
//+------------------------------------------------------------------+
void noticiasDoDiaBack()
  {
   string comentario;
   string dataAtu;
   int resulNegative = 0;
   int operador2 = 0;
   string dadosParaLinhaV2[];
   dataAtu = TimeToString(TimeCurrent(),TIME_DATE);
   string arayDados[];
   int arquivo = FileOpen("mt5.txt",FILE_COMMON|FILE_TXT|FILE_READ);
   FileReadArray(arquivo,arayDados);
   FileClose(arquivo);

   for(int i=0;i<ArraySize(arayDados);i++)
     {
      struct dadosRecebidos
        {
         string      noticia;
         string      ativo;
         string      dataNticia;
         string      impacto;
        };

      dadosRecebidos pegaDados;
      string replica;
      string text = arayDados[i];
      string result[4];
      ushort codigo;

      codigo = StringGetCharacter("|",0);
      StringSplit(text,codigo,result);

      pegaDados.noticia = result[1];
      pegaDados.dataNticia = result[2];
      pegaDados.ativo = result[0];
      pegaDados.impacto = result[3];
      replica = pegaDados.dataNticia;
      StringSetLength(replica,10);

      if(replica == dataAtu)
        {
         operador2++;
         if(StringFind(_Symbol,pegaDados.ativo)>0)
           {
            comentario = comentario+"\n"+pegaDados.ativo+"|"+pegaDados.noticia+"|"+pegaDados.dataNticia+"|"+"IMPACTO: "+pegaDados.impacto;
            Comment(comentario);
            //  Print(pegaDados.ativo,"|",pegaDados.noticia,"|",pegaDados.dataNticia);
            dadosParaLinhaV[operador2] = pegaDados.dataNticia;
           }
         if(StringFind(_Symbol,pegaDados.ativo)<0)
           {
            resulNegative++;
           }
        }

     }
   if(resulNegative == operador2)
     {
      comentario = "NÃO HAVERÁ NOTÍCIAS IMPORTANTES HOJE !";
      Comment(comentario);
     }
   ArrayInsert(dadosParaLinhaV2,dadosParaLinhaV,0,1,operador2);
   ArrayCopy(dadosParaLinhaV3,dadosParaLinhaV2,0,0);
  }


//+------------------------------------------------------------------+
//|DESENHA LINHA VESTICAL                                            |
//+------------------------------------------------------------------+
void desenhaLinhavertical(string nome, datetime time, color cor = clrYellow)
  {
   ObjectCreate(0,nome,OBJ_VLINE,0,time,0);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,cor);
  }

//+------------------------------------------------------------------+
//|ENVIAR ORDEM NO BACKTEST                                          |
//+------------------------------------------------------------------+
void enviarOrdem()
  {
   double utilS,utilB;
   string dateteste,dateteste2;
   for(int i=0;i<ArraySize(dadosParaLinhaV3);i++)
     {
      TimeToStruct(TimeCurrent(),dta);
      TimeToStruct(StringToTime(dadosParaLinhaV3[i]),dta2);

      if(dta2.min == "0")
        {
         dta2.min = "59";
         dta2.hour = dta2.hour-1;
         dta2.sec = "50";
        }
      else
        {
         dta2.min = dta2.min -1;
         dta2.sec = "50";
        }
      datetime time = StructToTime(dta2);
      dateteste2 = TimeToString(time,TIME_DATE);

      if(dateteste2 != "1970.01.01")
        {
         if(TimeCurrent() == time)
           {
            for(int i=PositionsTotal();i>=0;i--)
              {
               ordem.PositionClose(PositionGetTicket(i));
               ordem.OrderDelete(OrderGetTicket(i));
              }
            utilS = velas[1].low-(5*_Point);
            utilB = velas[1].high+(5*_Point);
            if(velas[0].close > velas[1].high+(5*_Point))
              {
               utilB = velas[0].high+(10*_Point);
              }
            if(velas[0].close < velas[1].low-(5*_Point))
              {
               utilS = velas[0].low-(10*_Point);
              }
            ordem.BuyStop(lotes,utilB);
            ordem.SellStop(lotes,utilS);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|STOP MOVEL                                                        |
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void calendarioAuxiliar()
  {
   string result[15];
   ulong codigo;
   double utilB,utilS;
   int operadorCalen = 0;
   MqlDateTime data,dataStruct;
   TimeToStruct(iTime(_Symbol,PERIOD_D1,0),data);
   MqlCalendarValue valores[];
   datetime dataInicial = iTime(_Symbol,PERIOD_D1,0);
   string dataFinal = (TimeToString(TimeCurrent(),TIME_DATE))+" 23:58:00";
   CalendarValueHistory(valores,dataInicial,dataFinal,NULL,NULL);
   for(int i=0;i<ArraySize(valores);i++)
     {
      MqlCalendarEvent evento;
      CalendarEventById(valores[i].event_id,evento);
      MqlCalendarCountry country;
      CalendarCountryById(evento.country_id,country);
      if(StringFind(_Symbol,country.currency) < 0)
         continue;
      codigo = StringGetCharacter(" ",0);
      StringSplit(evento.name,codigo,result);

      for(int ind=0;ind<ArraySize(hourNotice);ind++)
        {
         if(result[ind] == "(IPP)" || result[ind] == "(IPC)" || result[ind] == "(IMP)")
           {
            if(evento.importance == CALENDAR_IMPORTANCE_MODERATE)
              {
               operadorCalen++;
               hourNotice[operadorCalen] = TimeToString(valores[i].time,TIME_MINUTES);
               NameNotice[operadorCalen] = evento.name;
               nameAtivo[operadorCalen] = country.currency;
               if(NameNotice[operadorCalen] != NULL)
                 {
                  comentarioTela = comentarioTela +nameAtivo[operadorCalen]+" | "+NameNotice[operadorCalen]+" | "+valores[i].time+"\n";
                  desenhaLinhavertical(("linhaAtual"+i),valores[i].time);
                  TimeToStruct(valores[i].time,dataStruct);
                  if(dataStruct.min =="0")
                    {
                     dataStruct.min = "59";
                     dataStruct.hour -=1;
                     dataStruct.sec = "50";
                    }
                  else
                    {
                     dataStruct.min -=1;
                     dataStruct.sec = "50";
                    }

                  if(StructToTime(dataStruct) == TimeCurrent())
                    {
                     for(int i=PositionsTotal();i>=0;i--)
                       {
                        ordem.PositionClose(PositionGetTicket(i));
                        ordem.OrderDelete(OrderGetTicket(i));
                       }

                     utilS = velas[1].low-(5*_Point);
                     utilB = velas[1].high+(5*_Point);
                     if(velas[0].close > velas[1].high+(5*_Point))
                       {
                        utilB = velas[0].high+(5*_Point);
                       }
                     if(velas[0].close < velas[1].low-(5*_Point))
                       {
                        utilS = velas[0].low-(5*_Point);
                       }
                     ordem.BuyStop(lotes,utilB);
                     ordem.SellStop(lotes,utilS);
                    };
                 }
              }
           }
        }


     }



  }

//+------------------------------------------------------------------+
