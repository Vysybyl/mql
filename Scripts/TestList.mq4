//+------------------------------------------------------------------+
//|                                                     TestList.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs

#include <VirtualTicket.mqh>
//--- input parameters
input int      NumberOfElements=3;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   VirtualTicket *VT=new VirtualTicket(Symbol(),ORDER_TYPE_BUY_STOP,1.0,Ask-(Point*50),5,Ask-(Point*500),Ask+(Point*500));
   VT.CheckForOpen();
   VT.CloseTicket();
   Print(VT.ToString());
  }
//+------------------------------------------------------------------+
