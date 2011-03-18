package {
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]

	public class FlexUnitRunner extends Sprite {
		
		
		private var core : FlexUnitCore;

		public function FlexUnitRunner() {
			//Instantiate the core.
			core = new FlexUnitCore();
			
			//Add any listeners. In this case, the TraceListener has been added to display results.
			core.addListener(new TraceListener());
			
			STAGE = stage;
			
			core.run( [
			] );
		}
	}
}
