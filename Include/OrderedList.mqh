//+------------------------------------------------------------------+
//|                                                   SortedList.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <BaseList.mqh>
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
class ComparableNode : public BaseNode
  {
public:
                     ComparableNode(void){};
                    ~ComparableNode(void){};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderedList : public BaseList
  {

protected:
   bool _addIfEmpty(ComparableNode *&node)
     {
      if(this.Length==0)
        {
         this._first= node;
         this._last = node;
         return true;
        }
      return false;
     }
   void _addBefore(ComparableNode*&node,ComparableNode* &auxNode)
     {
      if(auxNode!=NULL) // It is not the last position
        {
         if(auxNode.Previous!=NULL) // It is not the first position
           {
            auxNode.Previous.Next=node;
            node.Previous=auxNode.Previous;
           }
         else // It is the first position
           {
            this._first=node;
           }
         auxNode.Previous=node;
         node.Next=auxNode;
        }
      else // It is the last position
        {
         this._last.Next=node;
         node.Previous=this._last;
         this._last=node;
        }
     }
public:
                     OrderedList(void){};
                    ~OrderedList(void){};

  };
//+------------------------------------------------------------------+
