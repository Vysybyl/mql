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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class IntNode : public BaseNode
  {
public:
                     IntNode(void){};
                    ~IntNode(void){};
   int               Value;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class IntList : public BaseList
  {
public:
                     IntList(void){};
                    ~IntList(void){};
   void Add(int i)
     {
      IntNode *node=new IntNode();
      node.Value=i;
      this._add(node);
     }
   int Get(int index)
     {
      IntNode *node=this._get(index);
      if(node==NULL)
        {
         return -111111111;
        }
      return node.Value;
     }
   int Last(void)
     {
      IntNode *node=this._last;
      return node.Value;
     }
   int First(void)
     {
      IntNode *node=this._first;
      return node.Value;
     }
  };
//+------------------------------------------------------------------+
