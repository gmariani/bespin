package cv.bespin {
	
	import fl.controls.Button;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindow;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	//import gs.easing.Linear;
	//import gs.TweenMax;
	
	import cv.managers.UpdateManager;
	
	public class AboutWindow extends NativeWindow {
		
		private var sprMain:MovieClip = new AboutScreen();
		private var txtMessage:TextField;
		private var btnOk:Button;
		private var mcEmblem:MovieClip;
		private var um:UpdateManager;
		
		public function AboutWindow():void {
			// Init Window
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.maximizable = false;
			winArgs.minimizable = true;
			winArgs.resizable = false;
			winArgs.type = NativeWindowType.NORMAL;
			super(winArgs);
			title = "About Course Vector Bespin in AIR";
			this.width = 325;
			this.height = 200;
			
			// Init
			um = UpdateManager.instance;
			txtMessage = sprMain.getChildByName("txtMessage") as TextField;
			txtMessage.embedFonts = true;
			txtMessage.autoSize = TextFieldAutoSize.CENTER;
			txtMessage.htmlText = "Version : <b>" + um.currentVersion + "</b><br><br>© 2009 Gabriel Mariani<br><br><a href='http://blog.coursevector.com/'><u>http://blog.coursevector.com</u></a>";
			
			btnOk = sprMain.getChildByName("btnOk") as Button;
			btnOk.addEventListener(MouseEvent.CLICK, onClickOk);
			
			mcEmblem = sprMain.getChildByName("mcEmblem") as MovieClip;
			mcEmblem.rotationX = 0;
			//TweenMax.to(mcEmblem, 5, { rotationY:360, loop:true, ease:Linear.easeNone } );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addChild(sprMain);
			stage.root.transform.perspectiveProjection.projectionCenter = new Point(mcEmblem.x, mcEmblem.y);
		}
		
		private function onClickOk(event:MouseEvent):void {
			close();
		}
	}
}