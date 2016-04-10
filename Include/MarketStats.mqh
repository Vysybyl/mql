//+------------------------------------------------------------------+
//|                                                  MarketStats.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <CustomIndicator.mqh>
#include <DoubleStatisticsList.mqh>
input int MarketStatsCandles=1000;
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MarketStatsCustomIndicator : public CustomIndicator
  {
private:
   DoubleStatisticsList *_CandleBodyStatistics;
   DoubleStatisticsList *_CandleHeightStatistics;
   datetime          _lastCandleTime;
public:
                     MarketStatsCustomIndicator(void)
     {
      this._CandleBodyStatistics=new DoubleStatisticsList();
      this._CandleHeightStatistics=new DoubleStatisticsList();
      this._lastCandleTime=Time[1];
      int i=1;
      while(i<Bars-1 && i<=MarketStatsCandles)
        {
         this._CandleBodyStatistics.Add(MathAbs(Open[i]-Close[i]));
         this._CandleHeightStatistics.Add(MathAbs(High[i]-Low[i]));
         i++;
        }
      this.Display();
     }
                    ~MarketStatsCustomIndicator(void)
     {
      delete this._CandleBodyStatistics;
      delete this._CandleHeightStatistics;
     }
   void OnTickStart(void)
     {
     }
   void Display()
     {
      Comment(" == MarketStats == \n"+
              "Considering "+IntegerToString(this._CandleBodyStatistics.Length)+" Candles\n"+
              "BODY "+this._CandleBodyStatistics.ToDisplay()+"\n"+
              "HEIGHT "+this._CandleHeightStatistics.ToDisplay());
     }
  };
//+------------------------------------------------------------------+
