//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
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
class BaseNode
  {
public:
   BaseNode         *Previous;
   BaseNode         *Next;
                     BaseNode(void)
     {
      Previous=NULL;
      Next=NULL;
     }
                    ~BaseNode(void){  };
   virtual string ToString(){return "";}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BaseList
  {
private:
   BaseNode         *_getAuxNode(int index)
     {
      int cnt=index;
      BaseNode *auxValue=this._first;
      while(cnt!=0)
        {
         auxValue=auxValue.Next;
         cnt--;
        }
      return auxValue;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
protected:
   BaseNode         *_first;
   BaseNode         *_last;
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              _add(BaseNode *&node)
     {
      if(this._first==NULL)
        {
         this._first=node;
        }
      else
        {
         BaseNode *auxValue=this._first;
         while(auxValue.Next!=NULL)
           {
            auxValue=auxValue.Next;
           }
         node.Previous=auxValue;
         auxValue.Next=node;
        }
      this._last=node;
      this.Length++;
     };
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   BaseNode *_get(int index)
     {
      if(index>=this.Length || index<0)
        {
         return NULL;
        }
      return _getAuxNode(index);
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _removeAndPatch(BaseNode *&auxValue)
     {
      if(auxValue.Next!=NULL)
        {
         auxValue.Next.Previous=auxValue.Previous;
        }
      else
        {
         this._last=auxValue.Previous;
        }
      if(auxValue.Previous!=NULL)
        {
         auxValue.Previous.Next=auxValue.Next;
        }
      else
        {
         this._first=auxValue.Next;
        }
      this.Length--;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string _toString()
     {
      int i=0;
      string ret="[";
      BaseNode *auxNode=this._first;
      while(auxNode!=NULL)
        {
         ret+=" NODE "+IntegerToString(i)+": "+auxNode.ToString()+" |";
         i++;
         auxNode = auxNode.Next;
        }
      return StringSubstr(ret,0,StringLen(ret)-1) + "]";
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void _deleteValue(BaseNode *&node){}
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
public:
                     BaseList(void)
     {
      Length=0;
      _first= NULL;
      _last = NULL;
     }
                    ~BaseList(void){};
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   int               Length;
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool Remove(int index)
     {
      if(index>=this.Length || index<0)
        {
         return false;
        }
      BaseNode *auxValue=_getAuxNode(index);
      this._removeAndPatch(auxValue);
      _deleteValue(auxValue);
      return true;
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   virtual string ToString(void)
     {
      return this._toString();
     }
  };
//+------------------------------------------------------------------+
