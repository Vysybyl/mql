//+------------------------------------------------------------------+
//|                                         RenkoCustomIndicator.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <CustomIndicator.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RenkoCustomIndicator : public CustomIndicator
  {
private:
   int               _trend;
   int               _openAfter;
   datetime          _currentCandle;
   int               _offlineChartTimeframe;
   bool              _isNewCandle;
public:
                     RenkoCustomIndicator(void){};
                     RenkoCustomIndicator(int openAfter = 1, int offlineChartTimeframe=3)
     {
      _openAfter = openAfter;
      _offlineChartTimeframe = offlineChartTimeframe;
      _isNewCandle = False;
      _currentCandle = iTime(Symbol(),_offlineChartTimeframe,1);
     }
                    ~RenkoCustomIndicator(void){};
   void OnTickStart()
     {
      if(_currentCandle<iTime(Symbol(),_offlineChartTimeframe,1))
        {
         _isNewCandle=True;

         if(iClose(Symbol(),_offlineChartTimeframe,2)<iClose(Symbol(),_offlineChartTimeframe,1))
           {
            if(_trend>0)
              {
               _trend++;
              }
            else
              {
               _trend=1;
              }
           }
         else if(iClose(Symbol(),_offlineChartTimeframe,2)>iClose(Symbol(),_offlineChartTimeframe,1))
           {
            if(_trend<0)
              {
               _trend--;
              }
            else
              {
               _trend=-1;
              }
           }
        }
     }
   bool OpenBuyPosition(void)
     {
      return _trend == _openAfter && _isNewCandle;
     }
   bool OpenSellPosition(void)
     {
      return _trend == -_openAfter && _isNewCandle;
     }
   string PrintStatus(void)
     {
      return StringConcatenate( " -- RenkoCustomIndicator -- ",
                               " Trend: ",IntegerToString(_trend),
                               " | OpenAfter: "+IntegerToString(_openAfter),
                               " | CurrentCandle: "+TimeToString(_currentCandle),
                               " | IsNewCandle: "+IntegerToString(_isNewCandle),
                               " | OpenBuy: "+IntegerToString(this.OpenBuyPosition()),
                               " | OpenSell: "+IntegerToString(this.OpenSellPosition()),
                               " -- "
                               );
     }
   void OnTickEnd()
     {
      if(_isNewCandle)
        {
         _currentCandle=iTime(Symbol(),_offlineChartTimeframe,1);
         _isNewCandle=false;
        }
     }
  };
//+------------------------------------------------------------------+
