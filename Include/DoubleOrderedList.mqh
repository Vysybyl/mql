//+------------------------------------------------------------------+
//|                                            DoubleOrderedList.mqh |
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
class DoubleComparableNode : public ComparableNode
  {

public:
   double            Value;
                     DoubleComparableNode(double val)
     {
      this.Value=val;
     }
                    ~DoubleComparableNode(void);
   bool LessThan(DoubleComparableNode *&node)
     {
      return this.Value<node.Value;
     }
   string ToString(void)
     {
      return DoubleToString(this.Value);
     }
  };
//+------------------------------------------------------------------+
class DoubleOrderedList : public OrderedList
  {
protected:
   DoubleComparableNode *_getAuxNode(DoubleComparableNode *&node)
     {
      DoubleComparableNode *auxNode=this._first;
      while(auxNode!=NULL && auxNode.LessThan(node))
        {
         auxNode=auxNode.Next;
        }
      return auxNode;
     }
   void  _updateMaxAndMin(double val)
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
   string _doubleOrderedToDisplay(void)
     {
 return " Max: "+ DoubleToString(this.Max/Point) + " | Min: " + DoubleToString(this.Min/Point) + " ";
     }
   string _doubleOrderedToString(void)
     {
      return " Max: "+ DoubleToString(this.Max) + " | Min: " + DoubleToString(this.Min) + " " + this._toString();
     }
   void _doubleOrderedAdd(double val)
     {
      this._updateMaxAndMin(val);
      DoubleComparableNode *node=new DoubleComparableNode(val);
      if(!this._addIfEmpty(node))
        {
         DoubleComparableNode*auxNode=this._getAuxNode(node);
         this._addBefore(node,auxNode);
        }
      this.Length++;
     }
public:
                     DoubleOrderedList(void){};
                    ~DoubleOrderedList(void){};
   virtual void Add(double val)
     {
      this._doubleOrderedAdd(val);
     }
   double            Max;
   double            Min;
   string ToString(void)
     {
      return this._doubleOrderedToString();
     }
  };
//+------------------------------------------------------------------+
