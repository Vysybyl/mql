//+------------------------------------------------------------------+
//|                                          CustomIndicatorList.mqh |
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
#include "BaseList.mqh"
#include "CustomIndicator.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CustomIndicatorNode : public BaseNode
  {
public:
                     CustomIndicatorNode(void);
                    ~CustomIndicatorNode(void);
   CustomIndicator   *indicator;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CustomIndicatorList : public BaseList
  {
public:
                     CustomIndicatorList(void);
                    ~CustomIndicatorList(void);
   void    Add(CustomIndicator *customIndicator)
     {
      CustomIndicatorNode *newNode = new CustomIndicatorNode();
      newNode.indicator = customIndicator;
      if(this.first==NULL)
        {
         this.first=newNode;
        }
      CustomIndicatorNode *auxValue = this.first;
      while(auxValue.next!=NULL)
        {
         auxValue=auxValue.next;
        }
      auxValue.next=newNode;
      newNode.previous=auxValue;
      this.last=newNode;
      this.length++;
     }
   CustomIndicator   First()  {
   return this.first.indicator;
  }
   CustomIndicator   Last()  {
   return this.last.indicator;
  }
   CustomIndicator   ToArray(){
     
     CustomIndicator* indicatorArray[7];
     return indicatorArray;
   }
  };
