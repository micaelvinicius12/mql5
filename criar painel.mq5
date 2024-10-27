//+------------------------------------------------------------------+
//|                                                 criar painel.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {/*
//+------------------------------------------------------------------+
//|                       CRIANDO PAINEL                             |
//+------------------------------------------------------------------+ 
if(tipo_op == manu)
     {
     
//-----MOSTRANDO O CRIADOR NO GRAFICO-----
ObjectCreate(0,"criador",OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,"criador",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,"criador",OBJPROP_FONTSIZE,9);
    ObjectSetString(0,"criador",OBJPROP_TEXT,"CRIADOR :   MICAEL VINICIUS");
    ObjectSetInteger(0,"criador",OBJPROP_COLOR,clrAqua);
    ObjectSetInteger(0,"criador",OBJPROP_XDISTANCE,180);
    ObjectSetInteger(0,"criador",OBJPROP_YDISTANCE,50);

//-----NOME DO ROBO NO GRFICO-----    
ObjectCreate(0,"NOMEROBO",OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,"NOMEROBO",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
    ObjectSetInteger(0,"NOMEROBO",OBJPROP_FONTSIZE,12);
    ObjectSetString(0,"NOMEROBO",OBJPROP_FONT,FONT_UNDERLINE);
    ObjectSetString(0,"NOMEROBO",OBJPROP_TEXT,"ROBO: "+nome);
    ObjectSetInteger(0,"NOMEROBO",OBJPROP_COLOR,clrRed);
    ObjectSetInteger(0,"NOMEROBO",OBJPROP_XDISTANCE,200);
    ObjectSetInteger(0,"NOMEROBO",OBJPROP_YDISTANCE,40);    
    
//-----PAINEL-----    
ObjectCreate(0,"painel",OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,"painel",OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,"painel",OBJPROP_XDISTANCE,delta_x);
   ObjectSetInteger(0,"painel",OBJPROP_YDISTANCE,delta_y + y_size);
   ObjectSetInteger(0,"painel",OBJPROP_XSIZE,x_size);
   ObjectSetInteger(0,"painel",OBJPROP_YSIZE,y_size);

   ObjectSetInteger(0,"painel",OBJPROP_BGCOLOR,clrBlack);
   ObjectSetInteger(0,"painel",OBJPROP_BORDER_TYPE,BORDER_RAISED);
   ObjectSetInteger(0,"painel",OBJPROP_BORDER_COLOR,clrWhite);
   for(int i=0; i<ArraySize(infos); i++)
     {
      ObjectCreate(0,infos[i],OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,infos[i],OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0,infos[i],OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,infos[i],OBJPROP_XDISTANCE,delta_x+5);
      ObjectSetInteger(0,infos[i],OBJPROP_YDISTANCE,delta_y -5 +y_size -i *line_size);
      ObjectSetInteger(0,infos[i],OBJPROP_COLOR,clrAqua);
      ObjectSetInteger(0,infos[i],OBJPROP_FONTSIZE,8);
      ObjectSetString(0,infos[i],OBJPROP_TEXT,infos[i]);

      string name =infos[i]+ "valor";
      ObjectCreate(0,name,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,delta_x + x_size -5);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,delta_y -5 +y_size -i *line_size);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);
      ObjectSetString(0,name,OBJPROP_TEXT,"inativo");
     }
 }*/
   
  }
//+------------------------------------------------------------------+
