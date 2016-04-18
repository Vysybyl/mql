//+------------------------------------------------------------------+
//|                                                         TEST.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <DoubleStatisticsList.mqh>
#include <RenkoTrends.mqh>
#include <MarketStats.mqh>
#include <VirtualTicketManager.mqh>
input int MagicNumber = 103;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
  /*
  string name ="TestFile12.txt";
  int handlr = FileOpen(name, FILE_READ | FILE_WRITE | FILE_TXT, 0, CP_ACP);
  FileWriteString(handlr,"ProvaLeggi");
  FileClose(handlr);
  
  handlr = FileOpen(name, FILE_READ | FILE_WRITE | FILE_TXT, 0, CP_ACP);
  FileWriteString(handlr,"ProvaLeggi12345");
  FileClose(handlr);
  
  handlr = FileOpen(name, FILE_READ | FILE_WRITE | FILE_TXT, 0, CP_ACP);
  FileWriteString(handlr," ");
  FileClose(handlr);
  */
  
  
//---
VirtualTicketManager VTM(MagicNumber);
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_BUY,0.01,Ask,5,Ask+20*Point,Ask+50*Point);
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_BUY,0.01,Ask,5,Ask+20*Point,0);
/*
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_BUY,0.01,Ask,5,0,Ask-50*Point);
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_BUY,0.01,Ask,5,Ask-20*Point,Ask-50*Point);
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_SELL,0.01,Bid,5,Bid-20*Point,Bid-50*Point);
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_SELL,0.01,Bid,5,Bid+20*Point,Bid+50*Point);
*/
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_SELL,0.01,Bid,5,Bid-20*Point,0);
Print(VTM.ToString());
VTM.Send(Symbol(),ORDER_TYPE_SELL,0.01,Bid,5,0,Bid+50*Point);
Print(VTM.ToString());
VTM.Run();
Print(VTM.ToString());
/*
RenkoTrendsCustomIndicator RT();
//MarketStatsCustomIndicator MS();

IntStatisticsList ISL();
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));
ISL.Add(-1);
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));
ISL.Add(3);
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));
ISL.Add(2);
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));
ISL.Add(100);
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));
ISL.Add(-4);
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));
ISL.Add(5);
Print("ISL "+ ISL.ToString());
Print("Median "+ ISL.Quantile(0.5) + "   1/4 " + ISL.Quantile(0.25));

DoubleStatisticsList DSL();
Print(DSL.ToString());
DSL.Add(1.2);
Print(DSL.ToString());

DSL.Add(2.3);
Print(DSL.ToString());

DSL.Add(-12.3);
Print(DSL.ToString());

DSL.Add(5.55);
Print(DSL.ToString());

*/

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
/*
   Print("TEST PRINT");
   Comment("TEST COMMENT");
   Alert("TEST ALERT");
*/
  }
//+------------------------------------------------------------------+
