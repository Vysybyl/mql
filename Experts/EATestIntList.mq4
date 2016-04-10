//+------------------------------------------------------------------+
//|                                                EATestIntList.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <IntList.mqh>
#include <VirtualTicketSmartList.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   IntList *list=new IntList();

for(int i=0;i<10;i++)
  {
   list.Add(i);
  }

   int cnt=list.Length;
   for(int i=cnt-1;i>=2;i--)
     {
      Print("Last Number "+IntegerToString(list.Last()));
      Print("Number at 2:   " + IntegerToString(list.Get(2)));
      Print("First Number "+IntegerToString(list.First()));
      Print("Removing number at 0 ");
      list.Remove(0);
     }
     
     VirtualTicketSmartList * VTList = new VirtualTicketSmartList();
     VirtualTicket* VT1 = new VirtualTicket(Symbol(),ORDER_TYPE_BUY_STOP,0.1,Ask-(10 * Point),3,Ask + (500 * Point), Ask - 2.8*(500 * Point));
     VTList.Add(VT1);
     VirtualTicket* VT2 = new VirtualTicket(Symbol(),ORDER_TYPE_BUY_STOP,0.1,Ask-(10 * Point),3,Ask + (500 * Point), Ask - 2.8*(500 * Point));
     VTList.Add(VT2);
     VirtualTicket* VT3 = new VirtualTicket(Symbol(),ORDER_TYPE_BUY_STOP,0.1,Ask-(10 * Point),3,Ask + (500 * Point), Ask - 2.8*(500 * Point));
     VTList.Add(VT3);
     VTList.CheckForOpen();
     VTList.CheckForClose();
     
     delete VTList;
     delete VT1;
     
/*
Print("Number " + IntegerToString(list.Get(2)));
Print("Number " + IntegerToString(list.Get(-2)));
Print("Number " + IntegerToString(list.Get(0)));
Print("Number " + IntegerToString(list.Get(3)));
*/
//Alert("Number " + IntegerToString(list.Get(1)));
//Comment("Number " + IntegerToString(list.Get(1)));
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
   IntList *list=new IntList();

   list.Add(4);
/*
list.Add(5);
list.Add(6);
*/
//Print("Number " + IntegerToString(list.Get(1)));
//Alert("Number " + IntegerToString(list.Get(1)));
//Comment("Number " + IntegerToString(list.Get(1)));
  }
//+------------------------------------------------------------------+
