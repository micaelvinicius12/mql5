//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <Telegram.mqh>
string tokem = "5858607287:AAFYSf3q2VfjY5HK9AUwv1EOltxcpxfrzZw";
string nome = "ROBO_F-22_2_0";

CCustomBot bot;
CTrade ordem;
MqlRates vela[];
MqlDateTime data;

//globais
string letras_win[7] = {"WING23","WINJ23","WINM23","WINQ23","WINV23","WINZ23","WINZ22"};
string ativo = _Symbol,ativo1;
double max,min,max_atual,min_atual;
double margem = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
bool jaFoiEnviadoUmaOrdem = false;
double preco_venda,preco_compra;
string tipoOrdem = "Aguardando....";
string usuario = AccountInfoString(ACCOUNT_NAME);
string status;
string tipo_c;
int dt;
int cont = 0,cont2;
string onOff;
string dataInteira, data_inter;

//verifica se tem saldo
bool tem_saldo;


//tipos de ordens
int o_venda = 0;
int o_compra = 0;


//total de ordens do mes
int t_ordens;

//saldo e lucro
double saldo_Inicial;
double saldo_final;
double lucro_diario;
double lucro_mensal;
double lucro_semanal;

//funcoes(horarias)
string hora_atual;
string hora_abertura;
string hora_fechamento;
string hora_op;
string hora_da_negociacao = "Aguardando....";

//dados de entrada
input int tp = 100; //TAKEPROFIT
input int sl = 700; //STOPLOSS
input int lote = 1; //CONTRATOS

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
    Print("ROBO F-22 INICIADO !");
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrDeepSkyBlue);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrBlack);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_OHLC,false);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,true);
   ChartSetInteger(0,CHART_SHIFT,true);
   ChartSetInteger(0,CHART_SCALE,4);

   onLine();
   EventSetTimer(5);
   bot.Token(tokem);
   bot.GetMe();
   verificacao_periodo();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   CopyRates("WDOF23",PERIOD_M15,0,5,vela);
   ArraySetAsSeries(vela,true);
   hora_atual = TimeToString(TimeCurrent(),TIME_SECONDS);
   hora_op = TimeToString(TimeCurrent(),TIME_MINUTES);
   preco_compra = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   preco_venda = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   dataInteira = "Nota__"+data.day+"."+data.mon+"."+data.year;
   dt = TimeCurrent(data);

//chamada de funcoes
   abertura_mercado();
   envio_de_ordens();
   lucro_dia();
   total_de_ordens();
   backup();
   saldoNegativo();
   onLine();
   lucro_mensal = lucroMensal();
   lucro_semanal = lucroSemanal();
  
   
  }
///////////////////////////////////////////////////////////////////////////
void abertura_mercado()
  {
   if(hora_op <  "09:30")
     {
      max = vela[1].high;
      min = vela[1].low;
      jaFoiEnviadoUmaOrdem = false;
     }
   max_atual = vela[1].high;
   min_atual = vela[1].low;
  }

///////////////////////////////////////////////////////////////////////////
void backup()
  {
   if(hora_atual == "17:30:00")
     {
      salvando_dados();
     }
  }
///////////////////////////////////////////////////////////////////////////
void total_de_ordens()
  {
   HistorySelect(iTime(_Symbol,PERIOD_MN1,0),TimeCurrent());
   t_ordens = HistoryOrdersTotal()/2;
  }
///////////////////////////////////////////////////////////////////////////
void lucro_dia()
  {
   if(hora_atual == "09:05:00")
     {
      saldo_Inicial = AccountInfoDouble(ACCOUNT_BALANCE);
      tipoOrdem = "Aguardando....";
      hora_da_negociacao = "Aguardando....";


     }
   saldo_final = AccountInfoDouble(ACCOUNT_BALANCE);

   lucro_diario = saldo_final - saldo_Inicial;

  }
///////////////////////////////////////////////////////////////////////////
void envio_de_ordens()
  {
   if(hora_op > "09:30" && jaFoiEnviadoUmaOrdem == false && tem_saldo == true)
     {
      //OREDEM DE VENDA
      if(max_atual > max)
        {
         o_venda++;
         jaFoiEnviadoUmaOrdem = true;
         ordem.Sell(lote,_Symbol,0,preco_venda+sl,preco_venda-tp,"ordem de venda");
         tipoOrdem = "ORDEM DE VENDA !";
         hora_da_negociacao = hora_atual;
         status = "ORDEM DE VENDA ABERTA !";


        }
      //ORDEM DE COMPRA
      if(min_atual < min)
        {
         o_compra++;
         ordem.Buy(lote,_Symbol,0,preco_compra-sl,preco_compra+tp,"ordem de compra");
         jaFoiEnviadoUmaOrdem = true;
         tipoOrdem = "ORDEM DE COMPRA !";
         hora_da_negociacao = hora_atual;
         status = "ORDEM DE COMPRA ABERTA !";
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("ROBO F-22 ENCERRADO !");
  }

///////////////////////////////////////////////////////////////////////////
void verificacao_periodo()
  {
   if(_Period == PERIOD_M15)
     {
      painel();
     }
   else
     {
      Alert("ESTE ROBO SO FUNCIONA NO PERIODO DE M15 E NO INDICE !");
      ExpertRemove();
     }
  }
  
///////////////////////////////////////////////////////////////////////////
void painel()
  {
   Comment("Usuario = ",usuario,"\n",
           "Lucro diario = R$",lucro_diario,"\n",
           "Lucro semanal = R$",lucro_semanal,"\n",
           "Lucro mensal = R$",lucro_mensal,"\n",
           "Saldo total = R$",saldo_final,"\n",
           "Horario do envio = ",hora_da_negociacao,"\n",
           "Total de ordens = ",t_ordens,"\n",
           "Sinal = ",tipoOrdem);
  }
///////////////////////////////////////////////////////////////////////////
void salvando_dados()
  {
   int arquivo = FileOpen(dataInteira+".txt",FILE_COMMON|FILE_TXT|FILE_WRITE); //criando o arquivo
   FileWrite(arquivo,"USUARIO = "+usuario);
   FileWrite(arquivo,"DATA = "+data.day+"/"+data.mon+"/"+data.year);
   FileWrite(arquivo,"LUCRO DO DIA = R$"+lucro_diario);
   FileWrite(arquivo,"LUCRO SEMANAL = R$"+lucro_semanal);
   FileWrite(arquivo,"LUCRO MENSAL = R$"+lucro_mensal);
   FileWrite(arquivo,"SALDO TOTAL = "+saldo_final);
   FileWrite(arquivo,"HORARIO DE ENVIO = "+hora_da_negociacao);
   FileWrite(arquivo,"TOTAL DE ORDENS DO MES = "+t_ordens);
   FileWrite(arquivo,"TIPO DE ORDEM = "+tipoOrdem);
   FileClose(arquivo);
   Print("BACKUP COMPLETO !");
  }

///////////////////////////////////////////////////////////////////////////
void OnTimer()
  {
   bot.GetUpdates();

   for(int i=0; i<bot.ChatsTotal(); i++)
     {
      CCustomChat *chat=bot.m_chats.GetNodeAtIndex(i);
      if(!chat.m_new_one.done)
        {
         chat.m_new_one.done=true;
         string text =chat.m_new_one.message_text;

         if(text == "/1")
           {
            Print("COMUNICÃO COM TELEGRAM");
            if(hora_atual >= "09:00:00" && hora_atual <= "09:29:00")
              {
               status = "30 MINUTOS PARA COMEÇAR !";
              }
            if(hora_atual == "09:30:00")
              {
               status = "AGUARDANDO AS ORDENS !";
              }
            if(onOff == "OFFLINE")
              {
               status = "ROBO F-22 ESTA FORA DO HORARIO COMECIAL !";
              }
            bot.SendMessage(chat.m_id,status);
           }

         if(text == "/2")
           {
            tipoConta();
            Print("COMUNICÃO COM TELEGRAM");
            bot.SendMessage(chat.m_id,"ROBO F-22  °"+onOff+"\n"+"\n"+
                            "DATA = "+data.day+"/"+data.mon+"/"+data.year+"\n"+
                            "TIPO DE CONTA = "+tipo_c+"\n"+
                            "SALDO INICIAL = R$"+margem+"\n"+
                            "LUCRO DO DIA = R$"+lucro_diario+"\n"+
                            "LUCRO SEMANAL = R$"+lucro_semanal+"\n"+
                            "LUCRO MENSAL = R$"+(lucro_mensal)+"\n"+
                            "SALDO TOTAL = R$"+saldo_final+"\n"+
                            "HORARIO DA ORDEM = "+hora_da_negociacao+"\n"+
                            "TOTAL DE ORDENS DO MES = "+t_ordens+"\n"+
                            "SINAL = "+tipoOrdem);
           }
        }
     }
  }


///////////////////////////////////////////////////////////////////////////
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
         status = "SUA OPERAÇÃO LEVOU LOSS !";
        }
      if(deal_reason == DEAL_REASON_TP)
        {
         status = "SUA META FOI ALCANÇADA $$$";
        }

     }
  }
///////////////////////////////////////////////////////////////////////////
void onLine()
  {
   if(hora_atual > "09:00:00" && hora_atual < "18:00:00")
     {
      onOff = "ONLINE";
     }
   else
     {
      o_compra = 0;
      o_venda = 0;
      cont = 1;
      onOff = "OFFLINE";
     }
  }

///////////////////////////////////////////////////////////////////////////
double lucroSemanal()
  {
   datetime time_start = iTime(_Symbol, PERIOD_W1, 0);
   double   result = 0.0;
   double   result1;
   ulong    ticket;
   int      cnt;

   if(HistorySelect(time_start, TimeCurrent()))
     {
      for(cnt = HistoryDealsTotal() - 1; cnt >= 0; cnt--)
        {
         ticket = HistoryDealGetTicket(cnt);
         if(ticket != 0)
           {
               result += HistoryDealGetDouble(ticket, DEAL_PROFIT);
               result1 = result - saldo_Inicial;
              }
        }
     }
   return(result1);
  }
///////////////////////////////////////////////////////////////////////////
double lucroMensal()
  {
   datetime time_start = iTime(_Symbol, PERIOD_MN1, 0);
   double   result = 0.0;
   double result1;
   ulong    ticket;
   int      cnt;

   if(HistorySelect(time_start, TimeCurrent()))
     {
      for(cnt = HistoryDealsTotal() - 1; cnt >= 0; cnt--)
        {
         ticket = HistoryDealGetTicket(cnt);
         if(ticket != 0)
           {
               result += HistoryDealGetDouble(ticket, DEAL_PROFIT);
               result1 = result - saldo_Inicial;
              }
        }
     }
   return(result1);
  }
///////////////////////////////////////////////////////////////////////////
void saldoNegativo()
  {
   if(saldo_final <= 0)
     {
      tem_saldo = false;
      status = "VOCE NAO TEM SALDO PARA OPERAR !!";
      Print("VOCE NAO TEM SALDO PARA OPERAR !!");
     }
     else
       {
         tem_saldo = true;
       }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void tipoConta()
  {
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL)
     {
      tipo_c = "CONTA REAL";
     }
   else
     {
      tipo_c = "CONTA DEMO";
     }
  }









