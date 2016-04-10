//+------------------------------------------------------------------+
//|                                         DoubleStatisticsList.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <DoubleOrderedList.mqh>
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
class DoubleStatisticsList : public DoubleOrderedList
  {
protected:
   void _updateAverage(double val)
     {
      if(this.Length==0)
        {
         this.Average=val;
        }
      else
        {
         this.Average=((this.Average*this.Length)+val)/(this.Length+1);
        }
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
public:
                     DoubleStatisticsList(void){};
                    ~DoubleStatisticsList(void){};
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void Add(double val)
     {
      this._updateAverage(val);
      this._doubleOrderedAdd(val);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double            Average;
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double            Quantile(double frac)
     {
      if(frac<0 || frac>1.0)
        {
         return -123456;
        }
      DoubleComparableNode *node=this._get((int)NormalizeDouble( MathFloor(frac*(this.Length-1)),0));
      return node.Value;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string ToString()
     {
      return " Average: " + DoubleToString(this.Average)+ " |" + this._doubleOrderedToString();
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string ToDisplay()
     {
      return " Average: " + DoubleToString(this.Average/Point)+ " |" + this._doubleOrderedToDisplay();
     }
  };


//+------------------------------------------------------------------+
