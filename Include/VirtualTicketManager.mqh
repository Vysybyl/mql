//+------------------------------------------------------------------+
//|                                         VirtualTicketManager.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <VirtualTicketSmartList.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VirtualTicketManager
  {
private:
   VirtualTicketSmartList _ticketList;
   int               _magicNumber;
   string            _getCacheFileName();
   void              _initializeCache();
   void              _refreshCache();

public:
                     VirtualTicketManager(int magicNumber);
                    ~VirtualTicketManager();
   void              Send(
                          string   symbol,              // symbol
                          int      cmd,                 // operation
                          double   volume,              // volume
                          double   price,               // price
                          int      slippage,            // slippage
                          double   stoploss,            // stop loss
                          double   takeprofit           // take profit
                          );
   bool              Run();
   bool              CloseAllBuy();
   bool              CloseAllSend();
   string            ToString();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VirtualTicketManager::VirtualTicketManager(int magicNumber)
  {
   this._magicNumber=magicNumber;
   this._initializeCache();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

VirtualTicketManager::_refreshCache(void)
  {
  FileDelete(this._getCacheFileName());
   int handler=FileOpen(this._getCacheFileName(),FILE_READ|FILE_WRITE|FILE_TXT,0,CP_ACP);
   FileWriteString(handler,this._ticketList.ToFileString());
   FileClose(handler);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VirtualTicketManager::_initializeCache(void)
  {
   int handler =FileOpen(this._getCacheFileName(),FILE_READ|FILE_WRITE|FILE_TXT,0,CP_ACP);
   string line = FileReadString(handler);
   while(line != NULL && StringLen(line)>0)
     {
      VirtualTicket *VT=new VirtualTicket(line);
      this._ticketList.Add(VT);
      line=FileReadString(handler);
     }
   FileClose(handler);
   Print("Virtual Ticket Manager - "+IntegerToString(this._ticketList.Length)+" tickets were restored from cache.");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VirtualTicketManager::~VirtualTicketManager()
  {
   delete &(this._ticketList);
  }
//+------------------------------------------------------------------+
void VirtualTicketManager::Send(string symbol,int cmd,double volume,double price,int slippage,double stoploss,double takeprofit)
  {
   VirtualTicket *VT=new VirtualTicket(symbol,cmd,volume,price,slippage,stoploss,takeprofit);
   this._ticketList.Add(VT);
   this._refreshCache();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VirtualTicketManager::Run(void)
  {
   bool res=false;
   res = this._ticketList.CheckForOpen() || res;
   res = this._ticketList.CheckForClose() || res;
   if(res)
     {
      this._refreshCache();
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VirtualTicketManager::CloseAllBuy(void)
  {
   bool res=this._ticketList.CloseAllBuy();
   if(res)
     {
      this._refreshCache();
     }
   return res;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VirtualTicketManager::CloseAllSend(void)
  {
   bool res=this._ticketList.CloseAllSend();
   if(res)
     {
      this._refreshCache();
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string VirtualTicketManager::_getCacheFileName(void)
  {
   return "VirtualTicketManager/Cache_"+IntegerToString(this._magicNumber)+".txt";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string VirtualTicketManager::ToString(void)
  {
   return "MagicNumber: " + IntegerToString(this._magicNumber) + " | " + this._ticketList.ToString();
  }
//+------------------------------------------------------------------+
