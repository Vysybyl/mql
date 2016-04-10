//+------------------------------------------------------------------+
//|                                                  EAFramework.mqh |
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
// #importc
//+------------------------------------------------------------------+
class CustomIndicator
         {
       public:
                            CustomIndicator(void){};
                           ~CustomIndicator(void){};
                           virtual void OnTickStart(){};
                            virtual bool OpenBuyPosition(void){
                            return false;
                            }
                            virtual bool CloseBuyPosition(){
                            return true;
                            }
                            virtual bool OpenSellPosition(void){
                            return false;
                            }
                            virtual bool CloseSellPosition(){
                            return true;
                            }
                            virtual void OnTickEnd(){};
                            virtual string PrintStatus(void){return "";};
         };