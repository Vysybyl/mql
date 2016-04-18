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
   int               _cacheFileHandler;
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
   this._cacheFileHandler=FileOpen(this._getCacheFileName(),FILE_READ|FILE_WRITE|FILE_TXT,0,CP_ACP);
   FileWriteString(this._cacheFileHandler,this._ticketList.ToFileString());
   FileClose(this._cacheFileHandler);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VirtualTicketManager::_initializeCache(void)
  {
   this._cacheFileHandler=FileOpen(this._getCacheFileName(),FILE_READ|FILE_WRITE|FILE_TXT,0,CP_ACP);
   string line = FileReadString(this._cacheFileHandler);
   while(line != NULL && StringLen(line)>0)
     {
      VirtualTicket *VT=new VirtualTicket(line);
      this._ticketList.Add(VT);
      line=FileReadString(this._cacheFileHandler);
     }
   FileClose(this._cacheFileHandler);
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
  bool res = this._ticketList.CloseAllBuy();
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
   bool res = this._ticketList.CloseAllSend();
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
