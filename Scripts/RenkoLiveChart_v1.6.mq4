//+------------------------------------------------------------------+
//|   RenkoLiveChart_v1.6.mq4
//|          Inspired from Renco script by "e4" (renko_live_scr.mq4) |
//|                                         Copyleft 2009 LastViking |
//+------------------------------------------------------------------+
#property copyright "" 
#property show_inputs
//+------------------------------------------------------------------+
#include <WinUser32.mqh>
//+------------------------------------------------------------------+
extern int BoxSize = 100;
extern int RenkoTimeFrame = 2;      // What time frame to use for the offline renko chart
extern bool VolumeInHistory = true;
extern int RefreshRate = 0;		// Minimum nr of seconds between chart updates
//+------------------------------------------------------------------+
int start() {
   	int i, LastFPos = 0, HstHandle = -1;
   	string SymbolName = StringSubstr(Symbol(), 0, 6);
      double CurHigh,CurLow;
		double CurOpen, CurClose;				
   	
  	//---- History header
   	int HstVersion = 400;
   	string HstCopyright = "";
   	string HstSymbol = SymbolName;
   	int HstPeriod = RenkoTimeFrame; 
   	int HstDigits = Digits;
   	int HstUnused[13];
	
   	HstHandle = FileOpenHistory(HstSymbol + HstPeriod + ".hst", FILE_BIN|FILE_WRITE);
   	if(HstHandle < 0) return(-1);
   	
	//---- write history file header
   	FileWriteInteger(HstHandle, HstVersion, LONG_VALUE);
   	FileWriteString(HstHandle, HstCopyright, 64);
   	FileWriteString(HstHandle, HstSymbol, 12);
   	FileWriteInteger(HstHandle, HstPeriod, LONG_VALUE);
   	FileWriteInteger(HstHandle, HstDigits, LONG_VALUE);
   	FileWriteInteger(HstHandle, 0, LONG_VALUE);
   	FileWriteInteger(HstHandle, 0, LONG_VALUE);
   	FileWriteArray(HstHandle, HstUnused, 0, 13);
   	
   	Comment("RenkoLiveChart: Open Offline ", HstSymbol, "M", HstPeriod, " to view chart");
   	
	//---- write history file   	
   	double BoxPoints = NormalizeDouble(BoxSize*Point, Digits);
   	double PrevLow = NormalizeDouble(MathFloor(Close[Bars-1]/BoxPoints)*BoxPoints, Digits);
   	double PrevHigh = PrevLow + BoxPoints;
   	double PrevOpen = PrevLow;
   	double PrevClose = PrevHigh;
      double CurVolume = 1;
      datetime PrevTime = Time[Bars-1];  	

 	//---- begin historical data  
  	i = Bars-2;
  	while(i >= 0) {
  		//get price based on High / Low of bar
		PrevTime = Time[i]; 
		CurVolume = CurVolume + Volume[i];
		
		if(LastFPos != 0 && VolumeInHistory) {
			FileSeek(HstHandle, LastFPos, SEEK_SET);
			FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);	
		}
		
		bool UpTrend = High[i]+Low[i] > PrevHigh+PrevLow;
		// update low before high or the revers depending on is closest to prev. renko bar
		
		while(UpTrend && Low[i] <= PrevLow-BoxPoints) {
  			PrevHigh = PrevHigh - BoxPoints;
  			PrevLow = PrevLow - BoxPoints;
  			PrevOpen = PrevHigh;
  			PrevClose = PrevLow;
  			CurVolume = 1;
  			
			FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
			FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  			LastFPos = FileTell(HstHandle);   // Remeber Last pos in file			
			FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
			PrevTime++;
		}
		
		while(High[i] >= PrevHigh+BoxPoints) {
  			PrevHigh = PrevHigh + BoxPoints;
  			PrevLow = PrevLow + BoxPoints;
  			PrevOpen = PrevLow;
  			PrevClose = PrevHigh;
  			CurVolume = 1;
  			
			FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
			FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  			LastFPos = FileTell(HstHandle);   // Remeber Last pos in file			
			FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
			PrevTime++;
		}
		
  		while(!UpTrend && Low[i] <= PrevLow-BoxPoints) {
  			PrevHigh = PrevHigh - BoxPoints;
  			PrevLow = PrevLow - BoxPoints;
  			PrevOpen = PrevHigh;
  			PrevClose = PrevLow;
  			CurVolume = 1;
  			
			FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
			FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
			FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  			LastFPos = FileTell(HstHandle);   // Remeber Last pos in file			
			FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
			PrevTime++;
		}		
		i--;
	} 
	FileFlush(HstHandle);	
 	//----- end historical data
 	
 	//------ begin live data feed
	int hwnd = 0; 
	
   RefreshRates();
   CurHigh = PrevHigh; 
   CurLow = PrevLow;
   CurOpen = Bid;
   CurClose = Bid;

	datetime CurOpenTime = 0;
		
   	CurVolume = 0;
   	datetime LastUpdate = TimeLocal()-RefreshRate;
   	while(!IsStopped()) {
   	
   		if(RefreshRates()) {
   		
			if(hwnd == 0) { 
				hwnd = WindowHandle(SymbolName, HstPeriod); 
				if(hwnd != 0) Print("Chart window detected");
			}
   			
   			if(Bid >= PrevHigh+BoxPoints) {
   			
				CurVolume++;   			
				FileSeek(HstHandle, LastFPos, SEEK_SET);
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);   			
   			
     	  			PrevHigh = PrevHigh + BoxPoints;
	  			PrevLow = PrevLow + BoxPoints;
  				PrevOpen = PrevLow;
  				PrevClose = PrevHigh;
  				PrevTime = TimeCurrent();            		  				
  				  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  			  	LastFPos = FileTell(HstHandle);   // Remeber Last pos in file				  							
				FileWriteDouble(HstHandle, 1, DOUBLE_VALUE);
            		FileFlush(HstHandle);
            		
            CurOpenTime = 0;
  				CurVolume = 0;
				CurHigh = Bid;
				CurLow = Bid;  				            		
  				
            if(hwnd != 0) if(PostMessageA(hwnd, WM_COMMAND, 0x822c, 0) == 0) hwnd = 0;
//				if(hwnd != 0) PostMessageA(hwnd, WM_COMMAND, 0x822c, 0);											
			}
			else if(Bid <= PrevLow-BoxPoints) {
			
				CurVolume++;			
				FileSeek(HstHandle, LastFPos, SEEK_SET);
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);			
			
  				PrevHigh = PrevHigh - BoxPoints;
  				PrevLow = PrevLow - BoxPoints;
  				PrevOpen = PrevHigh;
  				PrevClose = PrevLow;
  				PrevTime = TimeCurrent();            		  				
  				  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  			  	LastFPos = FileTell(HstHandle);   // Remeber Last pos in file				  							
				FileWriteDouble(HstHandle, 1, DOUBLE_VALUE);
            		FileFlush(HstHandle);
            		
            		CurOpenTime = 0;
  				CurVolume = 0;
				CurHigh = Bid;
				CurLow = Bid;  				
            		  				
            if(hwnd != 0) if(PostMessageA(hwnd, WM_COMMAND, 0x822c, 0) == 0) hwnd = 0;
//				if(hwnd != 0) PostMessageA(hwnd, WM_COMMAND, 0x822c, 0);
			} 
			else {
				
				if(CurHigh < Bid) CurHigh = Bid;
				if(CurLow > Bid) CurLow = Bid;
				CurVolume++;
				
				if((TimeLocal()-LastUpdate) >= RefreshRate) {
				
					LastUpdate = TimeLocal();
				
					FileSeek(HstHandle, LastFPos, SEEK_SET); 
					FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
								
					if(PrevHigh <= Bid) CurOpen = PrevHigh;
					else if(PrevLow >= Bid) CurOpen = PrevLow;
					else CurOpen = Bid;
					CurClose = Bid;
					
					if(CurOpenTime == 0) CurOpenTime = TimeCurrent();
				
					FileWriteInteger(HstHandle, CurOpenTime, LONG_VALUE);		// Time
					FileWriteDouble(HstHandle, CurOpen, DOUBLE_VALUE);         	// Open
					FileWriteDouble(HstHandle, CurLow, DOUBLE_VALUE);		// Low
					FileWriteDouble(HstHandle, CurHigh, DOUBLE_VALUE);		// High
					FileWriteDouble(HstHandle, CurClose, DOUBLE_VALUE);		// Close
					FileWriteDouble(HstHandle, 1, DOUBLE_VALUE);			// Volume				
            			FileFlush(HstHandle);
            			
                     if(hwnd != 0) if(PostMessageA(hwnd, WM_COMMAND, 0x822c, 0) == 0) hwnd = 0;
//            			if(hwnd != 0) PostMessageA(hwnd, WM_COMMAND, 0x822c, 0);
            		}
			}
		}
		else {
			Sleep(50); 
		}
	}
	
	FileClose(HstHandle);
   	Comment(""); // remove comment from main chart
	return(0);
}
//+------------------------------------------------------------------+
   