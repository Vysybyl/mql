//+------------------------------------------------------------------+
//|                                               IntOrderedList.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <OrderedList.mqh>
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
class IntComparableNode : public ComparableNode
  {

public:
   int               Value;
                     IntComparableNode(int val)
     {
      this.Value=val;
     }
                    ~IntComparableNode(void);
   bool LessThan(IntComparableNode *&node)
     {
      return this.Value<node.Value;
     }
   string ToString(void)
     {
      return IntegerToString(this.Value);
     }
  };
//+------------------------------------------------------------------+
class IntOrderedList : public OrderedList
  {
protected:
   IntComparableNode *_getAuxNode(IntComparableNode *&node)
     {
      IntComparableNode *auxNode=this._first;
      while(auxNode!=NULL && auxNode.LessThan(node))
        {
         auxNode=auxNode.Next;
        }
      return auxNode;
     }
   void  _updateMaxAndMin(int val)
     {
      if(this.Length==0)
        {
         this.Min=val;
         this.Max=val;
        }

      if(this.Max<val)
        {
         this.Max=val;
        }
      if(this.Min>val)
        {
         this.Min=val;
        }
     }
   string _intOrderedToDisplay(void)
     {
      return " Max: "+ IntegerToString(this.Max) + " | Min: " + IntegerToString(this.Min) + " ";
     }
   string _intOrderedToString(void)
     {
      return " Max: "+ IntegerToString(this.Max) + " | Min: " + IntegerToString(this.Min) + " " + this._toString();
     }
   void _intOrderedAdd(int val)
     {
      this._updateMaxAndMin(val);
      IntComparableNode *node=new IntComparableNode(val);
      if(!this._addIfEmpty(node))
        {
         IntComparableNode*auxNode=this._getAuxNode(node);
         this._addBefore(node,auxNode);
        }
      this.Length++;
     }
public:
                     IntOrderedList(void){};
                    ~IntOrderedList(void){};
   virtual void Add(int val)
     {
      this._intOrderedAdd(val);
     }
   int               Max;
   int               Min;
   string ToString(void)
     {
      return this._intOrderedToString();
     }
  };
//+------------------------------------------------------------------+
