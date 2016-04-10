//+------------------------------------------------------------------+
//|                                       VirtualTicketSmartList.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <VirtualTicketList.mqh>
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
class VirtualTicketSmartList : public VirtualTicketList
  {
private:
   bool _closeByType(int type)
     {
      bool resp=false;
      if(this.Length>0)
        {
         VirtualTicketNode *nodeToCheck=this._first;
         VirtualTicketNode *auxValue=nodeToCheck.Next;
         if(nodeToCheck.Value.GetType()==type && nodeToCheck.Value.CloseTicket())
           {
            this._removeAndPatch(nodeToCheck);
            this._deleteValue(nodeToCheck);
            delete nodeToCheck;
            resp=true;
           }
         while(auxValue!=NULL)
           {
            nodeToCheck=auxValue;
            auxValue=auxValue.Next;
            if(nodeToCheck.Value.GetType()==type && nodeToCheck.Value.CloseTicket())
              {
               this._removeAndPatch(nodeToCheck);
               this._deleteValue(nodeToCheck);
               delete nodeToCheck;
               resp=true;
              }
           }
        }
      return resp;
     }

public:
                     VirtualTicketSmartList(void){};
                    ~VirtualTicketSmartList(void){};

   bool CheckForOpen()
     {
      bool resp=false;
      if(this.Length>0)
        {
         VirtualTicketNode *auxValue=this._first;
         resp=auxValue.Value.CheckForOpen();
         while(auxValue.Next!=NULL)
           {
            auxValue=auxValue.Next;
            resp=auxValue.Value.CheckForOpen() || resp;
           }
        }
      return resp;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CheckForClose()
     {
      bool resp=false;
      if(this.Length>0)
        {
         VirtualTicketNode *nodeToCheck=this._first;
         VirtualTicketNode *auxValue=nodeToCheck.Next;
         if(nodeToCheck.Value.CheckForClose())
           {
            this._removeAndPatch(nodeToCheck);
            this._deleteValue(nodeToCheck);
            delete nodeToCheck;
            resp=true;
           }
         while(auxValue!=NULL)
           {
            nodeToCheck=auxValue;
            auxValue=auxValue.Next;
            if(nodeToCheck.Value.CheckForClose())
              {
               this._removeAndPatch(nodeToCheck);
               this._deleteValue(nodeToCheck);
               delete nodeToCheck;
               resp=true;
              }
           }
        }
      return resp;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CloseAll()
     {
      bool resp=false;
      if(this.Length>0)
        {
         VirtualTicketNode *nodeToCheck=this._first;
         VirtualTicketNode *auxValue=nodeToCheck.Next;
         if(nodeToCheck.Value.CloseTicket())
           {
            this._removeAndPatch(nodeToCheck);
            this._deleteValue(nodeToCheck);
            delete nodeToCheck;
            resp=true;
           }
         while(auxValue!=NULL)
           {
            nodeToCheck=auxValue;
            auxValue=auxValue.Next;
            if(nodeToCheck.Value.CloseTicket())
              {
               this._removeAndPatch(nodeToCheck);
               this._deleteValue(nodeToCheck);
               delete nodeToCheck;
               resp=true;
              }
           }
        }
      return resp;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CloseAllBuy()
     {
      return this._closeByType(ORDER_TYPE_BUY);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CloseAllSend()
     {
      return this._closeByType(ORDER_TYPE_SELL);
     }
  };
//+------------------------------------------------------------------+
