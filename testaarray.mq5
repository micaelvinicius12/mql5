//+------------------------------------------------------------------+
//|                                                   testaarray.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

long volumes[];
int contador;
int maior;

int ind;

int OnInit()
  {
//---
   ind = iVolumes(_Symbol,_Period,VOLUME_TICK);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    contador = Bars(_Symbol,PERIOD_M15,iTime(_Symbol,PERIOD_D1,0),TimeCurrent());
    
    if(contador > 1)
      {
       contador -=1;
       CopyTickVolume(_Symbol,PERIOD_CURRENT,iTime(_Symbol,PERIOD_M15,1),contador,volumes);
       maior = ArrayMaximum(volumes,0);
       Comment("Numero da barra = ",maior,"\n","maior volume = ",volumes[maior],"\n","contador = ",contador-1);
      }
    ArrayPrint(volumes,7,"--",0);
    
   
  }
//+------------------------------------------------------------------+
