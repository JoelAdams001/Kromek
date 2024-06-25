#include "SpectrometerDriver.h"
#include "stdio.h"
#include <thread>
#include <chrono>


void stdcall errorCallback(void *pCallbackObject, unsigned int deviceID, int errorCode, const char *pMessage)
{
	if (errorCode != ERROR_ACQUISITION_COMPLETE)
		printf("%s", pMessage);
}

int main()
{
	unsigned int detectorID = 0;

    // Initialise the library with no error callback (not recommended)
	kr_Initialise(errorCallback, NULL);

	for (int i = 0; i < 10; ++i)
	{
		// Start measurement on all detectors
		while ((detectorID = kr_GetNextDetector(detectorID)))
		{
            kr_BeginDataAcquisition(detectorID, 1000, 0);
		}

        std::this_thread::sleep_for(std::chrono::milliseconds(1000));

		// Start measurement on all detectors
		while ((detectorID = kr_GetNextDetector(detectorID)))
		{
			kr_StopDataAcquisition(detectorID);
			kr_ClearAcquiredData(detectorID);
		}


		
	}
	
    // Cleanup the library
	kr_Destruct();
	return 0;
}
