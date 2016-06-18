//+------------------------------------------------------------------+
//|                                           RenkoPatternPacman.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <RenkoCustomIndicator.mqh>
#include <VirtualTicketManager.mqh>
//--- input parameters
input int      OpenAfterBricks=1;
input int      CloseAfterBricks=2;
input double   LotSize=0.01;
input int      OfflineChartTimeframe=6;
input int      TakeProfitBricks=2;
input int MagicNumber=999;
input bool UseMartingale=true;

int candleHeight;
RenkoCustomIndicator renko(OpenAfterBricks,OfflineChartTimeframe);
VirtualTicketManager VTM(MagicNumber,UseMartingale);
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   MathSrand(GetTickCount());
   candleHeight=(int)NormalizeDouble(MathAbs(iOpen(Symbol(),OfflineChartTimeframe,1)-iClose(Symbol(),OfflineChartTimeframe,1))/Point,0);
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
//---
   renko.OnTickStart();
   if(renko.OpenBuyPosition())
     {
      VTM.CloseAllSend();
      VTM.Send(Symbol(),ORDER_TYPE_BUY,LotSize,Ask,3,Ask -(CloseAfterBricks*candleHeight*Point),Ask +(TakeProfitBricks*candleHeight*Point));
     }
   else if(renko.OpenSellPosition())
     {
      VTM.CloseAllBuy();
      VTM.Send(Symbol(),ORDER_TYPE_SELL,LotSize,Bid,3,Bid+(CloseAfterBricks*candleHeight*Point),Bid-(TakeProfitBricks*candleHeight*Point));
     }
   Comment(renko.PrintStatus());
   VTM.Run();
   renko.OnTickEnd();
  }
//+------------------------------------------------------------------+
