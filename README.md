# ofxEasyRetina


Simple OpenFrameworks addon allows you to enable retina graphics on iOS without modifying the original appearance of the app. In OpenFrameworks, when you enable retina on your device, the canvas size is doubled, ofGetWidth() and ofGetHeight() are doubled too, everything ends up looking tiny.

![image](http://farm9.staticflickr.com/8325/8402125653_7088e1a391_c.jpg)

With ofxEasyRetina, everything is upscaled as expected, just with twice the resolution. Your touch input will also behave as expected, and so will ofGetWidth() and ofGetHeight();

![image](http://farm9.staticflickr.com/8081/8403215406_73bfb81fdb_c.jpg)

PD: This is quite an ugly hack, but it makes it very easy to make retina compatible an exising non-retina project.


### How to use

		//enable retina before you create the window, in main.m
		
		int main(){

			ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow();
			iOSWindow->enableRetinaSupport(); //enable retina!
			ofSetupOpenGL(iOSWindow, 480, 320, OF_FULLSCREEN);
			ofRunApp(new testApp);
		}

		//include these two files in testApp.h
		
		#include "ofxEasyRetina.h"
		#include "ofxiOSEAGLView+retinaPatch.h"

		class testApp : public ofxiPhoneApp{
    		public:
        		void setup();
				void update();
		        void draw();
		
				ofxEasyRetina retina; //declare an ofxEasyRetina instance
		};
		
		//Setup the screen before drawing in testApp.mm
		
		void testApp::draw(){
			retina.setupScreenOrtho(); //make ofxEasyRetina setup your screen
			
			//done! draw your stuff!!
		}



### To Do

- tested on OF0073, and not much!