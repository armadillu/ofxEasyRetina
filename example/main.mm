#include "ofMain.h"
#include "testApp.h"

int main(){

	ofAppiOSWindow * iOSWindow = new ofAppiOSWindow();

	iOSWindow->enableHardwareOrientation();
    iOSWindow->enableOrientationAnimation();

	iOSWindow->enableRetina(); //enable retina!

	ofSetupOpenGL(iOSWindow, 1024, 768, OF_FULLSCREEN);
	ofRunApp(new testApp);
}
