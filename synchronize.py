from pythonutils.filemanager import manager as mgr

origindir = "C:\\Git\\mql"
destinationdir1 = "C:\\Users\\Kanthavel\\AppData\\Roaming\\MetaQuotes\\Terminal\\A6DFBB1B8DE9672D2328FF3445436DEC\\MQL4"
destinationdir2 = "C:\\Users\\Kanthavel\\AppData\\Roaming\\MetaQuotes\\Terminal\\50CA3DFB510CC5A8F28B48D1BF2A5702\\MQL4"

def main():
    mgr.sync(origindir,destinationdir1)
    mgr.sync(origindir,destinationdir2)

if __name__ == "__main__":
    main()
