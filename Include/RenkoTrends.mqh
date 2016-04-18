//+------------------------------------------------------------------+
//|                                                  RenkoTrends.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <IntStatisticsList.mqh>
#include <CustomIndicator.mqh>
input int RenkoTrendsCandles=1000;

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
class RenkoTrendsCustomIndicator : public CustomIndicator
  {
private:
   IntStatisticsList *_SignedCandleBodyStatistics;
   IntStatisticsList *_UnsignedCandleBodyStatistics;
   datetime          _lastCandleTime;
   int               _totals[20];
   int               _outlayers;
   int _candleDirection(int i)
     {
      if(Open[i]<Close[i])
        {
         return 1;
        }
      return -1;
     }

public:
                     RenkoTrendsCustomIndicator(void)
     {
      this._SignedCandleBodyStatistics=new IntStatisticsList();
      this._UnsignedCandleBodyStatistics=new IntStatisticsList();
      this._lastCandleTime=Time[1];
      for(int i=0;i<ArraySize(this._totals);i++)
        {
         this._totals[i]=0;
        }
      this._outlayers=0;
      int i=2;
      int cnt=this._candleDirection(1);
      int nu=cnt;
      while(i<Bars-1 && i<=RenkoTrendsCandles)
        {
         nu=this._candleDirection(i);
         if(cnt*nu>0)
           {
            cnt=cnt+nu;
           }
         else
           {
            this._SignedCandleBodyStatistics.Add(cnt);
            this._UnsignedCandleBodyStatistics.Add(MathAbs(cnt));
            int val=MathAbs(cnt)-1; // Between 0 and Maxvalue
            if(val<ArraySize(this._totals))
              {
               this._totals[val]++;
              }
            else
              {
               this._outlayers++;
              }
            cnt=nu;
           }
         i++;
        }
      this.Display();
     }
                    ~RenkoTrendsCustomIndicator(void)
     {
      delete this._SignedCandleBodyStatistics;
      delete this._UnsignedCandleBodyStatistics;
     }
   void OnTickStart(void)
     {
     }
   void Display()
     {
      string freq="";
      for(int i=0;i<ArraySize(this._totals);i++)
        {
         if(this._totals[i]>0)
           {
            freq=freq+IntegerToString(i+1)+" : "+IntegerToString(this._totals[i])+ "("+DoubleToString(this._totals[i]*1.0 / this._SignedCandleBodyStatistics.Length)+    "%)"   +" | ";
           }

        }
      freq=freq+" >"+IntegerToString(ArraySize(this._totals))+" : "+IntegerToString(this._outlayers);

      Comment(" == RenkoTrends == \n"+
              "Considering "+IntegerToString(this._SignedCandleBodyStatistics.Length)+" Segments"+
              " on a total of "+IntegerToString(Bars)+" Candles\n"+
              "SIGNED "+
              "25%: "+IntegerToString(this._SignedCandleBodyStatistics.Quantile(0.25))+
              " | 33%: "+ IntegerToString(this._SignedCandleBodyStatistics.Quantile(1.0/3))+
              " | 50%: "+ IntegerToString(this._SignedCandleBodyStatistics.Quantile(0.5))+
              " | 66%: "+ IntegerToString(this._SignedCandleBodyStatistics.Quantile(2.0/3))+
              " | 75%: "+ IntegerToString(this._SignedCandleBodyStatistics.Quantile(0.75))+
              " | "+this._SignedCandleBodyStatistics.ToDisplay()+"\n"+
              "UNSIGNED "+
              "25%: "+IntegerToString(this._UnsignedCandleBodyStatistics.Quantile(0.25))+
              " | 33%: "+ IntegerToString(this._UnsignedCandleBodyStatistics.Quantile(1.0/3))+
              " | 50%: "+ IntegerToString(this._UnsignedCandleBodyStatistics.Quantile(0.5))+
              " | 66%: "+ IntegerToString(this._UnsignedCandleBodyStatistics.Quantile(2.0/3))+
              " | 75%: "+ IntegerToString(this._UnsignedCandleBodyStatistics.Quantile(0.75))+
              " | "+this._UnsignedCandleBodyStatistics.ToDisplay()+"\n"+
              "FREQUENCIES "+freq+"\n"

              );

     }
  };
//+------------------------------------------------------------------+
