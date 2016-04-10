//+------------------------------------------------------------------+
//|                                               RenkoConverter.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input int      OutputChartTimeframe=2;
input int      CandleHeight=50;
input bool ShowWicks = true;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int HstHandle = -1, LastFPos = 0, MT4InternalMsg = 0;
string SymbolName;
//+------------------------------------------------------------------+
int start() {

	static double BoxPoints, UpWick, DnWick;
	static double PrevLow, PrevHigh, PrevOpen, PrevClose, CurVolume, CurLow, CurHigh, CurOpen, CurClose;
	static datetime PrevTime;
   	
	//+------------------------------------------------------------------+
	// This is only executed ones, then the first tick arives.
	if(HstHandle < 0) {
		// Init

		// Error checking	
		if(!IsConnected()) {
			Print("Waiting for connection...");
			return(0);
		}							
		if(!IsDllsAllowed()) {
			Print("Error: Dll calls must be allowed!");
			return(-1);
		}		
		switch(OutputChartTimeframe) {
		case 1: case 5: case 15: case 30: case 60: case 240:
		case 1440: case 10080: case 43200: case 0:
			Print("Error: Invald time frame used for offline renko chart (OutputChartTimeframe)!");
			return(-1);
		}
		//
		
		int BoxSize = CandleHeight;
		int BoxOffset = 0;
		if(Digits == 5 || (Digits == 3 && StringFind(Symbol(), "JPY") != -1)) {
			BoxSize = BoxSize*10;
			BoxOffset = BoxOffset*10;
		}
		if(Digits == 6 || (Digits == 4 && StringFind(Symbol(), "JPY") != -1)) {
			BoxSize = BoxSize*100;		
			BoxOffset = BoxOffset*100;
		}
		
		SymbolName = Symbol();
		BoxPoints = NormalizeDouble(BoxSize*Point, Digits);
		PrevLow = NormalizeDouble(BoxOffset*Point + MathFloor(Close[Bars-1]/BoxPoints)*BoxPoints, Digits);
		DnWick = PrevLow;
		PrevHigh = PrevLow + BoxPoints;
		UpWick = PrevHigh;
		PrevOpen = PrevLow;
		PrevClose = PrevHigh;
		CurVolume = 1;
		PrevTime = Time[Bars-1];
	
		// create / open hst file		
		HstHandle = FileOpenHistory(SymbolName + OutputChartTimeframe + ".hst", FILE_BIN|FILE_WRITE);
		if(HstHandle < 0) {
			Print("Error: can\'t create / open history file: " + SymbolName + OutputChartTimeframe + ".hst");
			return(-1);
		}
		//
   	
		// write hst file header
		int HstUnused[13];
		FileWriteInteger(HstHandle, 400, LONG_VALUE); 			// Version
		FileWriteString(HstHandle, "", 64);					// Copyright
		FileWriteString(HstHandle, SymbolName, 12);			// Symbol
		FileWriteInteger(HstHandle, OutputChartTimeframe, LONG_VALUE);	// Period
		FileWriteInteger(HstHandle, Digits, LONG_VALUE);		// Digits
		FileWriteInteger(HstHandle, 0, LONG_VALUE);			// Time Sign
		FileWriteInteger(HstHandle, 0, LONG_VALUE);			// Last Sync
		FileWriteArray(HstHandle, HstUnused, 0, 13);			// Unused
		//
   	
 		// process historical data
  		int i = Bars-2;
		//Print(Symbol() + " " + High[i] + " " + Low[i] + " " + Open[i] + " " + Close[i]);
		//---------------------------------------------------------------------------
  		while(i >= 0) {
  		
			CurVolume = CurVolume + Volume[i];
		
			UpWick = MathMax(UpWick, High[i]);
			DnWick = MathMin(DnWick, Low[i]);

			// update low before high or the revers depending on is closest to prev. bar
			bool UpTrend = High[i]+Low[i] > High[i+1]+Low[i+1];
		
			while(UpTrend && (Low[i] < PrevLow-BoxPoints || CompareDoubles(Low[i], PrevLow-BoxPoints))) {
  				PrevHigh = PrevHigh - BoxPoints;
  				PrevLow = PrevLow - BoxPoints;
  				PrevOpen = PrevHigh;
  				PrevClose = PrevLow;

				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);

				if(ShowWicks && UpWick > PrevHigh) FileWriteDouble(HstHandle, UpWick, DOUBLE_VALUE);
				else FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				  				  			
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				UpWick = 0;
				DnWick = EMPTY_VALUE;
				CurVolume = 0;
				CurHigh = PrevLow;
				CurLow = PrevLow;  
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}
		
			while(High[i] > PrevHigh+BoxPoints || CompareDoubles(High[i], PrevHigh+BoxPoints)) {
  				PrevHigh = PrevHigh + BoxPoints;
  				PrevLow = PrevLow + BoxPoints;
  				PrevOpen = PrevLow;
  				PrevClose = PrevHigh;
  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);

            		if(ShowWicks && DnWick < PrevLow) FileWriteDouble(HstHandle, DnWick, DOUBLE_VALUE);
				else FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
  				  			
				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				UpWick = 0;
				DnWick = EMPTY_VALUE;
				CurVolume = 0;
				CurHigh = PrevHigh;
				CurLow = PrevHigh;  
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}
		
			while(!UpTrend && (Low[i] < PrevLow-BoxPoints || CompareDoubles(Low[i], PrevLow-BoxPoints))) {
  				PrevHigh = PrevHigh - BoxPoints;
  				PrevLow = PrevLow - BoxPoints;
  				PrevOpen = PrevHigh;
  				PrevClose = PrevLow;
  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				
				if(ShowWicks && UpWick > PrevHigh) FileWriteDouble(HstHandle, UpWick, DOUBLE_VALUE);
				else FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);

				UpWick = 0;
				DnWick = EMPTY_VALUE;
				CurVolume = 0;
				CurHigh = PrevLow;
				CurLow = PrevLow;  
								
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}		
			i--;
		} 
		LastFPos = FileTell(HstHandle);   // Remember Last pos in file
		//
			
		Comment("RenkoLiveChart(" + CandleHeight + "): Open Offline ", SymbolName, ",M", OutputChartTimeframe, " to view chart");
		
		if(Close[0] > MathMax(PrevClose, PrevOpen)) CurOpen = MathMax(PrevClose, PrevOpen);
		else if (Close[0] < MathMin(PrevClose, PrevOpen)) CurOpen = MathMin(PrevClose, PrevOpen);
		else CurOpen = Close[0];
		
		CurClose = Close[0];
				
		if(UpWick > PrevHigh) CurHigh = UpWick;
		if(DnWick < PrevLow) CurLow = DnWick;
      
		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);		// Time
		FileWriteDouble(HstHandle, CurOpen, DOUBLE_VALUE);         	// Open
		FileWriteDouble(HstHandle, CurLow, DOUBLE_VALUE);		// Low
		FileWriteDouble(HstHandle, CurHigh, DOUBLE_VALUE);		// High
		FileWriteDouble(HstHandle, CurClose, DOUBLE_VALUE);		// Close
		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);		// Volume				
		FileFlush(HstHandle);

 		// End historical data / Init		
	}
			
		return(0);
}

bool CompareDoubles(double a, double b) {
   return ((a - b) > Point);
}
//+------------------------------------------------------------------+
