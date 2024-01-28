package cv.bespin {
	
	import cv.bespin.MenuIcon;
	import cv.bespin.AboutWindow;
	import cv.bespin.UpdateWindow;
	import com.google.analytics.API;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import cv.managers.UpdateManager;
	import flash.desktop.SystemTrayIcon;
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Bespin extends Sprite {
		
		private var icon:MenuIcon = new MenuIcon();
		private var VERSION:String;
		private var updateWin:UpdateWindow;
		private var aboutWin:AboutWindow;
		private var um:UpdateManager;
		private var app:NativeApplication = NativeApplication.nativeApplication;
		private var nw:NativeWindow;
		private var txtError:TextField = new TextField();
		private var html:HTMLLoader;
		
		public function Bespin() {
			init();
		}
		
		private function init() {
			txtError.setTextFormat(new TextFormat(null, null, 0xFFFFFF));
			addChild(txtError);
			
			var tracker:AnalyticsTracker = new GATracker(this, "UA-349755-1");
			tracker.trackPageview( "/tracking/projects/bespin" );
			
			try {
				html = new HTMLLoader();
				var urlReq:URLRequest = new URLRequest("https://bespin.mozilla.com/editor.html");
				html.useCache = false;
				html.cacheResponse = false;
				html.width = stage.stageWidth;
				html.height = stage.stageHeight;
				html.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				html.load(urlReq);
				addChild(html);
			} catch (error:IOError) {
				txtError.text = "Can't open editor.";
			}
			
			nw = this.stage.nativeWindow;
			nw.title = "Bespin";
			nw.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onWindowDisplay);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			icon.addEventListener(Event.COMPLETE,function():void{
				app.icon.bitmaps = icon.bitmaps;
			});
			icon.loadImages();
			
			// Init Updater
			um = UpdateManager.instance;
			//um.updateURL = "http://www.coursevector.com/projects/airadio/update.xml";
			//um.addEventListener(UpdateManager.AVAILABLE, updateHandler);
			//um.checkNow();
			
			VERSION = um.currentVersion;
			
			// Win
			if (NativeApplication.supportsSystemTrayIcon) {
				SystemTrayIcon(app.icon).tooltip = "Bespin in AIR";
				SystemTrayIcon(app.icon).menu = createRootMenu();
				app.icon.addEventListener(MouseEvent.CLICK, onClickTray);
			}
		}
		
		private function onStageResize(e:Event):void {
			if(html) {
				html.width = stage.stageWidth;
				html.height = stage.stageHeight;
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			txtError.text = "ioErrorHandler: " + event.text;
        }
		
		private function updateHandler(e:Event):void {
			updateWin = new UpdateWindow();
			updateWin.activate();
		}
		
		private function onClickTray(event:MouseEvent):void {
			nw.visible = true;
			nw.activate();
		}
		
		private function onWindowDisplay(e:NativeWindowDisplayStateEvent):void {
			switch(e.afterDisplayState) {
				case NativeWindowDisplayState.MAXIMIZED :
					nw.visible = true;
					nw.orderToFront();
					break;
				case NativeWindowDisplayState.MINIMIZED :
					nw.visible = false;
					break;
				case NativeWindowDisplayState.NORMAL :
					nw.activate();
					break;
			}
		}
		
		private function createRootMenu():NativeMenu {
			var nm:NativeMenu = new NativeMenu();
			var versionMenuItem:NativeMenuItem = nm.addItem(new NativeMenuItem("Bespin in AIR - v" + VERSION));
				versionMenuItem.addEventListener(Event.SELECT, onVersion);
			var exitMenuItem:NativeMenuItem = nm.addItem(new NativeMenuItem("Exit"));
				exitMenuItem.addEventListener(Event.SELECT, onExit);
			return nm;
		}
		
		private function onExit(e:Event):void {
			app.exit();
		}
		
		private function onVersion(e:Event):void {
			aboutWin = new AboutWindow();
			aboutWin.activate();
		}
	}
}