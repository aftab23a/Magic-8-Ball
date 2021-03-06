﻿/**
* This file holds the Magic 8 Ball Screen and will update the textbox
**/
package{
	import flash.display.*;
	import flash.utils.Timer;
	import ihart.event.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.*;
	import flash.text.engine.TextBaseline;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class UpdateMagic8 extends MovieClip {
		//Timer
		private var cvTimer: Timer; 
		private var timerTicks: int; 
		//Sounds
		private var played: Boolean;  
		private var glassSound:Sound;
		// iHart
		private var sayings : Array; 
		private var saying: String; 
		private var output: TextField;
		private var format: TextFormat;

		private var cvManager: CVManager; 
		private var port:uint = 5204; 
		private var hostName:String = "localhost"; 
		
		// Screensaver to be displayed when no movement is detected
		//private var screensaver:Screensaver;

	//intializes variables; calls functions that initialize variables
	public function UpdateMagic8() : void 
	{
		//initialize textfield
		output = new TextField();
		format = new TextFormat(); 
		addChild(output); 
		setUpText();
		
		//initialize sound
		glassSound = new Sound(new URLRequest("glass.mp3"));
		played = false;

		//initialize var needed for iHart
		cvManager = new CVManager(hostName, port); 
		cvManager.addEventListener(CVEvent.SHELL, getData); 

		//initialize variables needed for the timer
		timerTicks = 0; 
		setupTimer();
		
		// Initialize the screensaver
		//screensaver = new Screensaver();
		//addChild(screensaver);

	}
	//sets up textfield (position; size; color; opacity)
	private function setUpText():void 
	{
		//initialize format 
		format.size = 25; 
		format.bold = true; 
		format.align = TextFormatAlign.CENTER;
		
		//set position of the textfield
		output.defaultTextFormat = format; 
		output.x = 200; 
		output.y = 170; 
	    //dynamic textfield
		output.wordWrap = true; 
		output.selectable= false; 
		//set's size of text field
		output.width = 120; 
		output.height = 90;
		//set color and opacity of textfield
		output.textColor = 0xFFFF00; 
		output.alpha = .4; 
		
		//initial text
		this.output.text = "Ask!"; //initial placeholder text
		
	}
	
	//sets up timer
	private function setupTimer(): void
	{
		cvTimer = new Timer(1000, 1); 
		cvTimer.addEventListener(TimerEvent.TIMER, allowCVEvents); 
		cvTimer.start(); //start timer
		saying = ballSpeaks(); //stores a random saying 
	}
	
	//called with the cvTimer
	private function allowCVEvents(e: Event) : void 
	{
		timerTicks++; //increment number of ticks by 1
	}
	
	//called when motion detected 
	public function getData(e: CVEvent):void{
		
		//use this to add an instruction screen
		var numBlobs : int = e.getNumBlobs();

		if(numBlobs > 0)
		{
			//removeChild(screensaver);
		}
		cvTimer.start();
		if(timerTicks > 1 && timerTicks < 3)
		{
			//set text to 'ball is thinking'
			this.output.text = "Ball is thinking..."; 
		}
		else if(timerTicks >= 3 && timerTicks < 5)
		{
			//set text to 'shake harder'
			this.output.text = "Shake Harder!";
		}
		//(this is where the magic happens)
		else if(timerTicks >= 5 && timerTicks < 8)
		{
			//set output text: random saying from the array
			this.output.text = saying; 
			//change the text color to blue
			output.textColor = 0x00FFFF;
			//this ensures the sound only plays once
			if(timerTicks == 5 && !played)
			{	
				played = true 
				//plays sound
				glassSound.play();
			}
		}
		//if timer ticks > 8, reset everything
		else if(timerTicks >= 8)
		{
			output.text = "Ask!"; //set text back to 'Ask!'
			output.textColor = 0xFF0000; //reset text color back to red
			resetTimer(); //reset timer 
		}
	}
	
	//mouse clicked
	public function mouseClicked ( e : MouseEvent) :void 
	{
		timerTicks++; //similar to the allow cv events fn.
	}
	
	
	// returns random phrase from an array containing all possible answers
	public function ballSpeaks(): String
	{
		sayings = new Array ("It is certain", "In Your Dreams", "Without a doubt", "Yes, definitely", "You may rely on it", "You Wish", "Most likely", "Outlook good", "Yes", "Signs point to yes", "Reply hazy, try again", "Ask again later", "Better not tell you now", "Cannot predict now", "Concentrate and ask again", "Don't count on it", "Not a chance", "My sources say no", "Outlook not so good", "Very doubtful");		
		var r: int = Math.floor(Math.random() * sayings.length);
		return sayings[r];
	}
	

	//Stops timer, sets up new timer Resets timer clicks; 
	public function resetTimer():void
	{
		cvTimer.stop();
		timerTicks = 0;
		setupTimer(); 
		//set sound played to fase
		played = false; 

	}
	

}
}
