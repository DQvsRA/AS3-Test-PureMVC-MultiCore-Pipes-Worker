package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
	/** 
	 * Splitting Pipe Tee.
	 * <P>
	 * Writes input messages to multiple output pipe fittings.</P>
	 */
	public class TeeSplit implements IPipeFitting
	{
		private var 
			_outputs	: Array = new Array()
		,	_channelID	: uint = Pipe.newChannelID()
		,	_pipeName	: String
		;
		/**
		 * Constructor.
		 * <P>
		 * Create the TeeSplit.
		 * This is the most common configuration, though you can connect
		 * as many outputs as necessary by calling <code>connect</code>.</P>
		 */
		public function TeeSplit() 
		{
			
		}
		
		/** 
		 * Connect the output IPipeFitting.
		 * <P>
		 * NOTE: You can connect as many outputs as you want
		 * by calling this method repeatedly.</P>
		 * 
		 * @param output the IPipeFitting to connect for output.
		 */
		public function connect( output:IPipeFitting ):Boolean
		{
			output.pipeName = this.pipeName;
			_outputs.push(output);
			return true;
		}
		
		/** 
		 * Disconnect the most recently connected output fitting. (LIFO)
		 * <P>
		 * To disconnect all outputs, you must call this 
		 * method repeatedly untill it returns null.</P>
		 * 
		 * @param output the IPipeFitting to connect for output.
		 */
		public function disconnect( ):IPipeFitting 
		{
			return _outputs.pop() as IPipeFitting;
		}
		
		/** 
		 * Disconnect a given output fitting. 
		 * <P>
		 * If the fitting passed in is connected
		 * as an output of this <code>TeeSplit</code>, then
		 * it is disconnected and the reference returned.</P>
		 * <P>
		 * If the fitting passed in is not connected as an 
		 * output of this <code>TeeSplit</code>, then <code>null</code>
		 * is returned.</P>
		 * 
		 * @param output the IPipeFitting to connect for output.
		 */
		public function disconnectFitting( target:IPipeFitting ):IPipeFitting 
		{
			var removed	: IPipeFitting;
			var output	: IPipeFitting;
			var length	: uint = _outputs.length;
			trace(">\t\t : TeeSplit.disconnectFitting, target.id =", target.channelID);
			trace(">\t\t : TeeSplit.disconnectFitting, target.pipe =", target.pipeName);
			trace(">\t\t : TeeSplit.disconnectFitting, length =", length);
			while(length--) {
				output = _outputs[length];
				trace(">\t\t\t output :", output.channelID, output.pipeName);
				if (output.channelID === target.channelID) {
					removed = _outputs.removeAt(length - 1);
					break;
				}
			}
			trace(">\t\t : TeeSplit.disconnectFitting, removed =", removed);
			return removed;
		}
		
		public function outputsCount():uint
		{
			return _outputs.length;
		}

		/**
		 * Write the message to all connected outputs.
		 * <P>
		 * Returns false if any output returns false, 
		 * but all outputs are written to regardless.</P>
		 * @param message the message to write
		 * @return Boolean whether any connected outputs failed
		 */
		public function write( message:IPipeMessage ):Boolean
		{
			var success	: Boolean = true;
			var output	: IPipeFitting;
			var counter	: uint = _outputs.length;
			const pid	: uint = message.getPipeID();
			const isIndividual:Boolean = pid > 0;
			
			trace("\t\t : TeeSplit.write: isIndividual =", isIndividual, pid);
			
			while (counter--) {
				output = _outputs[counter];
				if( !output ) {
					delete _outputs[counter];
					output = null;
					counter++;
				}
				trace("\t\t\t : output =", output.pipeName);
				if(isIndividual) {
					success = output && (_channelID == pid || output.channelID == pid) && !output.write( message );
					break;
				} else {
					success = output && !output.write( message );
				}
			}
			return success;	
		}

		public function get pipeName():String { return _pipeName; }
		public function set pipeName(value:String):void { _pipeName = value; }

		public function get channelID():uint { return _channelID; }
		public function set channelID(value:uint):void { _channelID = value; }

	}
}