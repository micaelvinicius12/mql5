//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include <Trade/Trade.mqh>
#include <Telegram.mqh>
MqlRates vela[];
MqlRates velas_dola[];
CTrade trade;


enum templete
  {
   claro, //CLARO
   escuro //ESCURO
  };


sinput string nome = "ROBO MAKI51       V2.0"; //NOME:
input templete mod = escuro; // COR DO GRAFICO
input int lotes = 1; //NUMERO DE CONTRATOS


//GLOBAIS
string hora_2, hora_3, fora_hora, data_i, data_f;
int tk = 150, sl = 600;
bool comprado = false, vendido = false;
double open, close, open1, close2;
bool sinal_compra = false, sinal_venda = false;
bool sinal_compra1 = false, sinal_venda1 = false;
int contador_vendas, contador_compras;
CCustomBot bot;
string token = "5259323111:AAHOf43PGdFaqo4ZOQWEsdeTmYYE1k84awg";
datetime hist;
double verific_date;
string datas_dola ;
color cor_1, cor_2;

//DADOS GRFICOS

double saldo_incial, saldo_final, saldo_c;   
double lucro_dia = 0;
int lucro_mes = 0;               
int total_o;                                 
int loss, gain;                             
int total_dt;                               
string tipo_c;
int login;
datetime trinta;
long period;
bool ldm = false;
double risco;

//START
int OnInit()
  {
//VARIAVEIS INCIAIS

   fora_hora = TimeToString(TimeCurrent(), TIME_MINUTES);

   if(fora_hora < "09:00" || fora_hora > "18:00")
     {
      Alert("VOCE ESTA FORA DO HORARIO DE MERCADO !!");
     }
   else
     {
      Alert("Para melhorar o modo visual, Aperte as teclas de atalho Ctrl + y e ponha em H1");
     }

   if(mod == escuro)
     {
      cor_1 = clrLime;
      cor_2 = clrRed;
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrYellow);
      ChartSetInteger(0, CHART_SCALE, 3);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_IS_MAXIMIZED, true);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrBlack);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrLime);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, clrLime);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrDeepPink);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrBlack);
      ChartSetInteger(0, CHART_COLOR_BID, clrAqua);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrBlue);
     }
   if(mod == claro)
     {

      cor_1 = clrGreen;
      cor_2 = clrMaroon;
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrYellow);
      ChartSetInteger(0, CHART_SCALE, 3);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_IS_MAXIMIZED, true);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrTan);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrLime);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrRed);
      ChartSetInteger(0, CHART_COLOR_BID, clrGray);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrBlue);
     }

   EventSetTimer(2);
   data_i = TimeToString(TimeCurrent(), TIME_DATE);
   saldo_incial = AccountInfoDouble(ACCOUNT_BALANCE);
   login = AccountInfoInteger(ACCOUNT_LOGIN);
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL)
     {
      tipo_c = "CONTA REAL";
     }
   else
     {
      tipo_c = "CONTA DEMO";
     }


   bot.Token(token);
   bot.GetMe();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0, "painel");
   ObjectDelete(0, "nome");
   ObjectDelete(0, "data");
   ObjectDelete(0, "hora");
   ObjectDelete(0, "ativo");
   ObjectDelete(0, "contratos");
   ObjectDelete(0, "saldo");
   ObjectDelete(0, "lucro");
   ObjectDelete(0, "risco");
   ObjectDelete(0, "T_O");
   ObjectDelete(0, "DIAS_T");
   ObjectDelete(0, "gain");
   ObjectDelete(0, "loss");
   ObjectDelete(0, "tipo_conta");
   ObjectDelete(0, "n_conta");
   ObjectDelete(0, "buy");
   ObjectDelete(0, "sell");
   ObjectDelete(0, "base");

   ObjectDelete(0, "data_v");
   ObjectDelete(0, "hora_v");
   ObjectDelete(0, "ativo_v");
   ObjectDelete(0, "contratos_v");
   ObjectDelete(0, "saldo_v");
   ObjectDelete(0, "lucro_v");
   ObjectDelete(0, "risco_v");
   ObjectDelete(0, "T_O_v");
   ObjectDelete(0, "DIAS_Tv");
   ObjectDelete(0, "gain_v");
   ObjectDelete(0, "loss_v");
   ObjectDelete(0, "tipomoeda_v");
   ObjectDelete(0, "tipo_conta_v");
   ObjectDelete(0, "n_conta_v");
   ObjectDelete(0, "buy_v");
   ObjectDelete(0, "sell_v");
   ObjectDelete(0, "tos");
   ObjectDelete(0, "tob");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//SUB GLOBAIS
   CopyRates(_Symbol, PERIOD_M30, 0, 5, vela);
   CopyRates(datas_dola, PERIOD_H1, 0, 5, velas_dola);
   ArraySetAsSeries(vela, true);
   ArraySetAsSeries(velas_dola, true);

   hora_2 = TimeToString(TimeCurrent(), TIME_MINUTES);
   hora_3 = TimeToString(TimeCurrent(), TIME_SECONDS);
   data_f = TimeToString(TimeCurrent(), TIME_DATE);

   verific_date = StringToDouble(data_f);
   risco = (sl / 5) * lotes;
   trinta = iTime(_Symbol, PERIOD_MN1, 1);
   lucro();


//VERIFICAO DOLA
   if(verific_date == 2022.01)
     {
      datas_dola = "WDOG22";
     }
   if(verific_date == 2022.02)
     {
      datas_dola = "WDOH22";
     }
   if(verific_date == 2022.03)
     {
      datas_dola = "WDOJ22";
     }
   if(verific_date == 2022.04)
     {
      datas_dola = "WDOK22";
     }
   if(verific_date == 2022.05)
     {
      datas_dola = "WDOM22";
     }
   if(verific_date == 2022.06)
     {
      datas_dola = "WDON22";
     }
   if(verific_date == 2022.07)
     {
      datas_dola = "WDOQ22";
     }
   if(verific_date == 2022.08)
     {
      datas_dola = "WDOU22";
     }
   if(verific_date == 2022.09)
     {
      datas_dola = "WDOV22";
     }
   if(verific_date == 2022.10)
     {
      datas_dola = "WDOX22";
     }
   if(verific_date == 2022.11)
     {
      datas_dola = "WDOZ22";
     }
   if(verific_date == 2022.12)
     {
      datas_dola = "WDOF22";
     }



//DADOS GRAFICOS
   painel("painel", CORNER_LEFT_UPPER, 20, 20, 290, 290, clrBlack);
   text("nome", CORNER_LEFT_UPPER, ANCHOR_LEFT, 140, 35, clrAqua, "MAKI51", "impact", 12);
   text("data", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 60, clrGray, "DATA", "arial", 8);
   text("hora", CORNER_LEFT_UPPER, ANCHOR_LEFT, 150, 60, clrGray, "HORA", "arial", 8);
   text("ativo", CORNER_LEFT_UPPER, ANCHOR_LEFT, 260, 60, clrGray, "ATIVO", "arial", 8);
   text("contratos", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 100, clrGray, "CONTRATOS", "arial", 8);
   text("saldo", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 115, clrGray, "SALDO EM CONTA", "arial", 8);
   text("lucro", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 130, clrGray, "LUCRO DO DIA", "arial", 8);
   text("risco", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 145, clrGray, "RISCO DE PERDA", "arial", 8);
   text("T_O", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 160, clrGray, "TOTAL DE ORDENS", "arial", 8);
   text("DIAS_T", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 175, clrGray, "DIAS TRABALHADO", "arial", 8);
   text("gain", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 195, clrGray, "GAINS", "arial", 8);
   text("loss", CORNER_LEFT_UPPER, ANCHOR_LEFT, 150, 195, clrGray, "LOSS", "arial", 8);
   text("n_conta", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 220, clrGray, "NUMERO DA CONTA", "arial", 8);
   text("tipo_conta", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 235, clrGray, "TIPO DE CONTA", "arial", 8);
   text("buy", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 255, clrLimeGreen, "ORDENS BUY", "arial", 8);
   text("sell", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 270, clrRed, "ORDENS SELL", "arial", 8);
   text("base", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 293, clrOrange, "BASEADO EM DOLAR                        V.2.0", "arial", 10);

   text("data_v", CORNER_LEFT_UPPER, ANCHOR_LEFT, 30, 77, clrWhite, data_f, "arial", 9);
   text("hora_v", CORNER_LEFT_UPPER, ANCHOR_LEFT, 150, 77, clrWhite, hora_3, "arial", 9);
   text("ativo_v", CORNER_LEFT_UPPER, ANCHOR_LEFT, 250, 77, clrWhite, _Symbol, "arial", 9);
   text("contratos_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 100, clrLime, lotes, "arial", 9);
   text("saldo_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 115, clrLime, "R$ " + saldo_incial, "arial", 9);
   text("lucro_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 130, clrLime, "R$ " + lucro_dia, "arial", 9);
   text("risco_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 145, clrLime, "R$ " + risco, "arial", 9);
   text("T_O_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 160, clrLime, total_o, "arial", 9);
   text("DIAS_Tv", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 175, clrLime, total_dt, "arial", 9);
   text("gain_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 120, 195, clrWhite, gain, "arial", 9);
   text("loss_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 220, 195, clrWhite, loss, "arial", 9);
   text("tipomoeda_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 195, clrWhite, "BRL", "arial", 9);
   text("tipo_conta_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 235, clrLime, tipo_c, "arial", 9);
   text("n_conta_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 220, clrLime, login, "arial", 8);
   text("buy_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 255, clrWhite, contador_compras, "arial", 9);
   text("sell_v", CORNER_LEFT_UPPER, ANCHOR_RIGHT, 290, 270, clrWhite, contador_vendas, "arial", 9);

//VERIFICACAO
   if(hora_2 >= "11:00")
     {
      open = velas_dola[1].open;
      close = velas_dola[1].close;
      open1 = velas_dola[0].open;
      close2 = velas_dola[0].close;
     }
   if(hora_3 == "09:00:00")
     {
      total_dt += 1;
      ObjectDelete(0, "tos");
      ObjectDelete(0, "tob");
     }

//CONDICAO 1
   if(open  > close && open1  > close2)
     {
      sinal_compra = true;
     }
   if(open < close && open1 < close2)
     {
      sinal_venda = true;
     }

//RESET
   if(hora_2 == "11:00")
     {
      sinal_compra = false;
      sinal_venda = false;
      comprado = false;
      vendido = false;
     }


//ENVIO DE ORDENS
   if(comprado == false && sinal_compra && PositionsTotal() == 0)
     {
      comprado = true;
      vendido = true;
      ordem_compra();
      total_o += 1;
      contador_compras += 1;
      Alert("ORDEM DE COMPRA REALIZADA !");
      text("tob", CORNER_LEFT_UPPER, ANCHOR_LEFT, 550, 40, cor_1, "ORDEM DE COMPRA", "impact", 16);
     }

   if(vendido == false && sinal_venda && PositionsTotal() == 0)
     {
      vendido = true;
      comprado = true;
      ordem_venda();
      total_o += 1;
      contador_vendas += 1;
      Alert("ORDEM DE VENDA REALIZADA !");
      text("tos", CORNER_LEFT_UPPER, ANCHOR_LEFT, 550, 40, cor_2, "ORDEM DE VENDA", "impact", 16);
     }

  }


//ORDEN DE COMPRA
void ordem_compra()
  {
   trade.Buy(lotes, _Symbol, 0, SymbolInfoDouble(_Symbol, SYMBOL_ASK) - sl, SymbolInfoDouble(_Symbol, SYMBOL_ASK) + tk);
  }

//ORDEM DE VENDA
void ordem_venda()
  {
   trade.Sell(lotes, _Symbol, 0, SymbolInfoDouble(_Symbol, SYMBOL_BID) + sl, SymbolInfoDouble(_Symbol, SYMBOL_BID) - tk);
  }

//CIRANDO LINHA HORIZONTAL
void CriarLinhaH(string nome, double preco, color cor)
  {
   ObjectCreate(0, nome, OBJ_HLINE, 0, 0, preco);
   ObjectSetDouble(0, nome, OBJPROP_PRICE, preco);
   ObjectSetInteger(0, nome, OBJPROP_COLOR, cor);
   ObjectSetInteger(0, nome, OBJPROP_WIDTH, 2);
  }


//STOP, GAIN
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
         loss += 1;
         ldm = true;
        }
      if(deal_reason == DEAL_REASON_TP)
        {
         gain += 1;
         ldm = true;
        }

     }
  }

//LUCRO DIA/MES
void lucro()
  {
   double lucro_acum = 0;
   double lucro;
   HistorySelect(trinta, TimeCurrent());
   ulong ordens = HistoryDealsTotal();
   for(int i = 0; i < ordens; i++)
     {
      ulong tick_n = HistoryDealGetTicket(i);
      lucro = HistoryDealGetDouble(tick_n, DEAL_PROFIT);
      lucro_acum += lucro;
     }
   if(ldm)
     {
      lucro_dia = lucro;
     }
   lucro_mes = lucro_acum - saldo_incial;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer(void)
  {

// robo telegram

   bot.GetUpdates();
   for(int i = 0; i < bot.ChatsTotal(); i++)
     {
      CCustomChat *chat = bot.m_chats.GetNodeAtIndex(i);
      if(!chat.m_new_one.done)
        {
         chat.m_new_one.done = true;
         string text = chat.m_new_one.message_text;
         if(text == "Trade")
           {
            bot.SendMessage(chat.m_id, "1 - informações" + "\n" + "2 - historico de ordens" + "\n" + "3 - encerrar robo");
           }
         if(text == "1")
           {
            bot.SendMessage(chat.m_id, "ROBO MAKI 51 --------v 1.0" + "\n" + "\n" +
                            "DATA  " + data_i + "\n" +
                            "SALDO  R$ " + saldo_incial + "\n" +
                            "LUCRO DO DIA  R$ " + lucro_dia + "\n" +
                            "LUCRO DO MÊS  R$ " + lucro_mes + "\n" +
                            "TOTAL DE ORDENS  " + total_o + "\n" +
                            "GAIN  " + gain + "     LOSS  " + loss + "\n" +
                            "DIAS TRABALHADO  " + total_dt);

           }
         if(text == "2")
           {
            bot.SendMessage(chat.m_id, "ROBO MAKI 51" + "\n" + "\n" +
                            "TOTAL DE VENDAS  " + contador_vendas + "\n" +
                            "TOTAL DE COMPRAS  " + contador_compras);
           }
         if(text == "3")
           {
            Alert("ROBO ENCERRADO !!");
            bot.SendMessage(chat.m_id, "Robo encerrado !");
            ExpertRemove();
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void painel(string rotulo, ENUM_BASE_CORNER corner,
            int distancia_x, int distancia_y, int largura,
            int altura, color cor)
  {
   ObjectCreate(0, rotulo, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, rotulo, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, rotulo, OBJPROP_XDISTANCE, distancia_x);
   ObjectSetInteger(0, rotulo, OBJPROP_YDISTANCE, distancia_y);
   ObjectSetInteger(0, rotulo, OBJPROP_XSIZE, largura);
   ObjectSetInteger(0, rotulo, OBJPROP_YSIZE, altura);
   ObjectSetInteger(0, rotulo, OBJPROP_BGCOLOR, cor);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void text(string rotulo, ENUM_BASE_CORNER corner, ENUM_ANCHOR_POINT anglo,
          int distancia_x, int distancia_y, color cor, string texto, string font,
          int tamanho)
  {
   ObjectCreate(0, rotulo, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, rotulo, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, rotulo, OBJPROP_ANCHOR, anglo);
   ObjectSetInteger(0, rotulo, OBJPROP_XDISTANCE, distancia_x);
   ObjectSetInteger(0, rotulo, OBJPROP_YDISTANCE, distancia_y);
   ObjectSetInteger(0, rotulo, OBJPROP_COLOR, cor);
   ObjectSetString(0, rotulo, OBJPROP_TEXT, texto);
   ObjectSetString(0, rotulo, OBJPROP_FONT, font);
   ObjectSetInteger(0, rotulo, OBJPROP_FONTSIZE, tamanho);
  }
//+------------------------------------------------------------------+
