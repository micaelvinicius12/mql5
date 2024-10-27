
void OnTick()
  {
//---
   
  }
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
         // SE LEVOU UM STOP
        }
      if(deal_reason == DEAL_REASON_TP)
        {
        // SE LEVOU UM GAIN
        }

     }
  }
