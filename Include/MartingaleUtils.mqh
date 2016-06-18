//+------------------------------------------------------------------+
//|                                              MartingaleUtils.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
double GetVolume(string symbol,double volume,double price,double takeprofit,int magicNumber)
  {
   double lossToRecover=0;
   datetime time=D'2015.01.01 00:00';
   for(int pos=0; pos<OrdersHistoryTotal(); pos++)
     {
      if(OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderMagicNumber()==magicNumber && OrderCloseTime()>time)
           {
            time=OrderCloseTime();
            lossToRecover=OrderProfit();
           }
        }
     }
     if(lossToRecover>=0)
       {
        return volume;
       }
       else
         {
             double expectedProfit=MathAbs(price-takeprofit)*MarketInfo(symbol,MODE_TICKVALUE)*volume;
             return NormalizeDouble((expectedProfit + MathAbs(lossToRecover))/(MathAbs(price-takeprofit)*MarketInfo(symbol,MODE_TICKVALUE)),(int)MarketInfo(symbol,MODE_DIGITS));
         }
  }
//+------------------------------------------------------------------+
