package org.puremvc.as3.multicore.utilities.pipes.messages
{
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;

	/**
	 * Pipe Message.
	 * <P>
	 * Messages travelling through a Pipeline can
	 * be filtered, and queued. In a queue, they may
	 * be sorted by priority. Based on type, they 
	 * may used as control messages to modify the
	 * behavior of filter or queue fittings connected
	 * to the pipleline into which they are written.</P>
	 */ 
	
	public class Message implements IPipeMessage
	{

		// High priority Messages can be sorted to the front of the queue 
		public static const PRIORITY_HIGH:int = 1;
		// Medium priority Messages are the default
		public static const PRIORITY_MED:int = 5;
		// Low priority Messages can be sorted to the back of the queue 
		public static const PRIORITY_LOW:int = 10;
		
		static private const timeUUID:uint = new Date().getTime();
		
		/**
		 * Normal Message type.
		 */
		protected static const BASE:String = 'messages/';
		public static const NORMAL:String = BASE+'normal/';
		
		// TBD: Messages in a queue can be sorted by priority.
		public var priority:int;

		// Messages can be handled differently according to type
		public var type:String;
		
		// Header properties describe any meta data about the message for the recipient
		public var header:Object;

		// Body of the message is the precious cargo
		public var body:Object;
		
		// This is from where this messege is comming from
		public var pipeID:uint = 0;

		public var uid:String;

		// Constructor
		public function Message( type:String, header:Object=null, body:Object=null, priority:int=5 )
		{
			const currentTime:uint = timeUUID + getTimer();
			setType( type );
			setHeader( header );
			setBody( body );
			setPriority( priority );
			
			uid = currentTime.toString(16);
		}
		
		// Get the type of this message
		public function getType():String
		{
			return this.type;
		}
		
		// Set the type of this message
		public function setType( type:String ):void
		{
			this.type = type;
		}
		
		// Get the priority of this message
		public function getPriority():int
		{
			return priority;
		}

		// Set the priority of this message
		public function setPriority( priority:int ):void
		{
			this.priority = priority;
		}
		
		// Get the header of this message
		public function getHeader():Object
		{
			return header;
		}

		// Set the header of this message
		public function setHeader( header:Object ):void
		{
			this.header = header;
		}
		
		// Get the body of this message
		public function getBody():Object
		{
			return body;
		}

		// Set the body of this message
		public function setBody( body:Object ):void
		{
			this.body = body;
		}

		public function getPipeID():uint 
		{ 
			return pipeID;
		}
		
		public function setPipeID(value:uint):void 
		{ 
			pipeID = value;
		}
		
		public function getUID():String 
		{ 
			return uid;
		}
	}
}