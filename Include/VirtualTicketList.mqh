//+------------------------------------------------------------------+
//|                                                      IntList.mqh |
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
#include <BaseList.mqh>
#include <VirtualTicket.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VirtualTicketNode : public BaseNode
  {
public:
                     VirtualTicketNode(void){};
                    ~VirtualTicketNode(void)
     {
      delete this.Value;
     };
   VirtualTicket    *Value;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VirtualTicketList : public BaseList
  {
protected:
   void _deleteValue(VirtualTicketNode *&node)
     {
      delete node.Value;
     }

public:
                     VirtualTicketList(void){};
                    ~VirtualTicketList(void)
     {
      while(this.Length>0)
        {
        VirtualTicketNode * node = this._first;
         this._deleteValue(node);
         this.Remove(0);
        }
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void Add(VirtualTicket *&i)
     {
      VirtualTicketNode *node=new VirtualTicketNode();
      node.Value=i;
      this._add(node);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   VirtualTicket  *Get(int index)
     {
      VirtualTicketNode *node=this._get(index);
      return node.Value;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   VirtualTicket  *Last(void)
     {
      VirtualTicketNode *node=this._last;
      return node.Value;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   VirtualTicket  *First(void)
     {
      VirtualTicketNode *node=this._first;
      return node.Value;
     }
     //+------------------------------------------------------------------+
     //|                                                                  |
     //+------------------------------------------------------------------+
     string ToCSVString(short delimiter=",")
     {
     string out = "";
     VirtualTicketNode* auxnode = this._first;
     while(auxnode != NULL)
       {
        out += auxnode.Value.ToCSVLine(delimiter);
        auxnode = auxnode.Next;
       }
       return out;
     }
  };
//+------------------------------------------------------------------+
