class ThreadManager {
	public static function createThread(job:Void->Void) {
		#if THREADING
		sys.thread.Thread.create(job);
		#else
		job();
		#end
	}
}