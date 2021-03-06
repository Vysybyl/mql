//+------------------------------------------------------------------+
//|                                                VirtualTicket.mqh |
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
class VirtualTicket
  {
private:
   string            _symbol;
   int               _cmd;
   double            _volume;
   double            _price;
   int               _slippage;
   double            _stoploss;
   double            _takeprofit;
   int               _number;
   int               _magicNumber;
   string            _randomName;
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool _close(double price)
     {
      if(OrderClose(this._number,this._volume,price,this._slippage, clrCrimson))
        {
         this._number=0;
         this._delLine(True);
         this._delLine(False);
         return True;
        }
      else
        {
         if(OrderClose(this._number,this._volume,price,this._slippage, clrCrimson))
           {
            this._delLine(True);
            this._delLine(False);
            this._number=0;
            return True;
           }
         else
           {
            Print("Error "+IntegerToString(GetLastError())+". Failed to close "+this.ToString()+" at Price: "+DoubleToString(price));
            //TODO remove
            //    this._number=0;
            //    return True;
           }
        }
      return False;
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _drawLine(bool cmd,double price)
     {
      if(cmd)
        {
         string objname=_randomName+"_STOP_LOSS";
         if(ObjectCreate(0,objname,OBJ_HLINE,0,0,price))
           {
            ObjectSetInteger(0,objname,OBJPROP_COLOR,clrCoral);
            ObjectSetInteger(0,objname,OBJPROP_STYLE,STYLE_DASHDOT);
           }
        }
      else
        {
         string objname=_randomName+"_TAKE_PROFIT";
         if(ObjectCreate(0,objname,OBJ_HLINE,0,0,price))
           {
            ObjectSetInteger(0,objname,OBJPROP_COLOR,clrAquamarine);
            ObjectSetInteger(0,objname,OBJPROP_STYLE,STYLE_DOT);
           }
        }
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _drawStopLine(double price)
     {
      _drawLine(true,price);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _drawTakeLine(double price)
     {
      _drawLine(false,price);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _delLine(bool cmd)
     {
      string objname=_randomName+"_STOP_LOSS";
      if(!cmd)
        {
         objname=_randomName+"_TAKE_PROFIT";
        }
      ObjectDelete(0,objname);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _parseLine(string line,string &pieces[],string delimiter)
     {
      int fromIx=0;
      int toIx = 0;
      for(int i=0;i<ArraySize(pieces);i++)
        {
         toIx=StringFind(line,delimiter,fromIx);
         pieces[i]=StringSubstr(line,fromIx,toIx-fromIx);
         fromIx=toIx+1;
        }
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+   
public:
                     VirtualTicket(string symbol,int cmd,double volume,double price,int slippage,double stoploss,double takeprofit, int magicNumber)
     {
      if(cmd==ORDER_TYPE_BUY || cmd==ORDER_TYPE_SELL)
        {
         this._number=OrderSend(symbol,cmd,volume,price,slippage,0,0,NULL,magicNumber,0,clrAqua);
        }
      else
        {
         this._number=0;
        }
      if(this._number>0)
        {
         this._randomName=IntegerToString(this._number);
        }
      else
        {
         this._randomName=IntegerToString(MathRand());
        }
      this._symbol=symbol;
      this._cmd=cmd;
      this._volume= volume;
      this._price = price;
      this._slippage = slippage;
      this._stoploss = stoploss;
      if(this._stoploss!=0)
        {
         this._drawStopLine(this._stoploss);
        }
      this._takeprofit=takeprofit;
      if(this._takeprofit!=0)
        {
         this._drawTakeLine(this._takeprofit);
        }
        Print("Created "+this.ToString());
     }
                    ~VirtualTicket(void)
     {
      if(this._number>0)
        {
         this.CloseTicket();
        }
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
                     VirtualTicket(string line,string delimiter=",")
     {
      string pieces[10];
      this._parseLine(line, pieces,delimiter);
      this._number = StrToInteger( pieces[0]);
      this._symbol = pieces[1];
      this._cmd=StrToInteger(pieces[2]);
      this._volume=StrToDouble(pieces[3]);
      this._price=StrToDouble(pieces[4]);
      this._slippage = StrToInteger( pieces[5]);
      this._stoploss =StrToDouble(  pieces[6]);
      this._takeprofit=StrToDouble(pieces[7]);
      this._randomName=pieces[8];
      this._magicNumber=StrToInteger(pieces[9]);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CheckForOpen(void)
     {
      if(this._number==0)
        {
         if((this._cmd==ORDER_TYPE_BUY_STOP && Ask>=this._price) ||
            (this._cmd==ORDER_TYPE_BUY_LIMIT && Ask<=this._price))
           {
            this._number=OrderSend(this._symbol,
                                   ORDER_TYPE_BUY,
                                   this._volume,
                                   this._price,
                                   this._slippage,
                                   0,
                                   0,NULL,
                                   this._magicNumber,
                                   0,clrAliceBlue);
            //TODO
            //   this._number=1234567;

            if(this._number>0)
              {
               this._cmd=ORDER_TYPE_BUY;
               Print("Created "+this.ToString());
               return True;
              }
            else
              {
               Print("Error "+IntegerToString(GetLastError())+". Failed to create "+this.ToString());
              }

           }
         if((this._cmd==ORDER_TYPE_SELL_LIMIT && Bid<=this._price) ||
            (this._cmd==ORDER_TYPE_SELL_STOP && Bid>=this._price))
           {
            this._number=OrderSend(this._symbol,
                                   ORDER_TYPE_SELL,
                                   this._volume,
                                   this._price,
                                   this._slippage,
                                   0,
                                   0,NULL,
                                   this._magicNumber,
                                   0,clrCoral);

            if(this._number>0)
              {
               this._cmd=ORDER_TYPE_SELL;
               Print("Created "+this.ToString());
               return True;
              }
            else
              {
               Print("Error "+IntegerToString(GetLastError())+". Failed to create "+this.ToString());
              }
           }
        }
      return False;
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CheckForClose(void)
     {
      if(this._cmd==ORDER_TYPE_BUY)
        {
         if((this._takeprofit!=0 && Bid>=this._takeprofit) || 
            (this._stoploss!=0 && Bid<=this._stoploss))
           {
            if(this._close(Bid))
              {
               return True;
              }
           }
        }
      if(this._cmd==ORDER_TYPE_SELL)
        {
         if((this._takeprofit!=0 && Ask<=this._takeprofit) || 
            (this._stoploss!=0 && Ask>=this._stoploss))
           {
            if(this._close(Ask))
              {
               return True;
              }
           }
        }
      return False;
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool CloseTicket()
     {
      if(this._number>0)
        {
         if(this._cmd==ORDER_TYPE_BUY)
           {
            if(this._close(Bid))
              {
               return True;
              }
           }
         if(this._cmd==ORDER_TYPE_SELL)
           {
            if(this._close(Ask))
              {
               return True;
              }
           }
        }
      return False;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   int GetType(void)
     {
      return this._cmd;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string ToString(void)
     {
      return StringConcatenate("-- VirtualTicket -- ",
                               " Number: "+IntegerToString(this._number),
                               " Symbol: "+this._symbol,
                               "| OrderType: "+IntegerToString(this._cmd),
                               "| Volume: "+DoubleToString(this._volume),
                               "| Price: "+DoubleToString(this._price),
                               "| Slippage: "+IntegerToString(this._slippage),
                               "| StopLoss: "+DoubleToString(this._stoploss),
                               "| TakeProfit: "+DoubleToString(this._takeprofit),
                               "| MagicNumber: "+IntegerToString(this._magicNumber),
                               " -- "
                               );
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string ToFileLine(string delimiter=",")
     {
      return StringConcatenate(IntegerToString(this._number),delimiter,
                               this._symbol,delimiter,
                               IntegerToString(this._cmd),delimiter,
                               DoubleToString(this._volume),delimiter,
                               DoubleToString(this._price),delimiter,
                               IntegerToString(this._slippage),delimiter,
                               DoubleToString(this._stoploss),delimiter,
                               DoubleToString(this._takeprofit),delimiter,
                               this._randomName,delimiter,
                               IntegerToString(this._magicNumber));
     }
  };
//+------------------------------------------------------------------+
