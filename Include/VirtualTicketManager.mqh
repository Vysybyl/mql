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
   void              _initializeCache();
public:
                     VirtualTicketManager();
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
   this._initializeFromFile();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VirtualTicketManager::_initializeCache(void)
  {
   if(FileIsExist(this._getCacheFileName()))
     {
      this._cacheFileHandler = FileOpen(this._getCacheFileName(),FILE_READ|FILE_WRITE|FILE_TXT,0,CP_ACP);
      
     }
     else
       {
        
       }
       this._cacheFileHandler = FileOpen(this._getCacheFileName(),FILE_READ|FILE_WRITE|FILE_CSV,";",CP_ACP);
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VirtualTicketManager::Run(void)
  {
   bool res=false;
   res = this._ticketList.CheckForOpen() || res;
   res = this._ticketList.CheckForClose() || res;
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VirtualTicketManager::CloseAllBuy(void)
  {
   return this._ticketList.CloseAllBuy();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VirtualTicketManager::CloseAllSend(void)
  {
   return this._ticketList.CloseAllSend();
  }
//+------------------------------------------------------------------+
