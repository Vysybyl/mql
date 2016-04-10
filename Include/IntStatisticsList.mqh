//+------------------------------------------------------------------+
//|                                            IntStatisticsList.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <IntOrderedList.mqh>
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
class IntStatisticsList : public IntOrderedList
  {
protected:
   void _updateAverage(int val)
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
                     IntStatisticsList(void){};
                    ~IntStatisticsList(void){};
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void Add(int val)
     {
      this._updateAverage(val);
      this._intOrderedAdd(val);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double            Average;
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   int            Quantile(double frac)
     {
      if(frac<0 || frac>1.0 || this.Length<1)
        {
         return -123456;
        }
      IntComparableNode *node=this._get((int) NormalizeDouble(MathFloor(frac*(this.Length-1)),0));
      return node.Value;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string ToString()
     {
      return " Average: " + DoubleToString(this.Average)+ " |" + this._intOrderedToString();
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string ToDisplay()
     {
      return " Average: " + DoubleToString(this.Average)+ " |" + this._intOrderedToDisplay();
     }
  };


//+------------------------------------------------------------------+
