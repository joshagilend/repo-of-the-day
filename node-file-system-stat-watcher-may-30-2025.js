Taken from: https://nodejs.org/docs/latest/api/fs.html#class-fsstatwatcher

fs is Node File System

Class: fs.StatWatcher#
Added in: v14.3.0, v12.20.0
Extends <EventEmitter>
A successful call to fs.watchFile() method will return a new <fs.StatWatcher> object.

watcher.ref()#
Added in: v14.3.0, v12.20.0
Returns: <fs.StatWatcher>
When called, requests that the Node.js event loop not exit so long as the <fs.StatWatcher> is active. Calling watcher.ref() multiple times will have no effect.

By default, all <fs.StatWatcher> objects are "ref'ed", making it normally unnecessary to call watcher.ref() unless watcher.unref() had been called previously.

watcher.unref()#
Added in: v14.3.0, v12.20.0
Returns: <fs.StatWatcher>
When called, the active <fs.StatWatcher> object will not require the Node.js event loop to remain active. If there is no other activity keeping the event loop running, the process may exit before the <fs.StatWatcher> object's callback is invoked. Calling watcher.unref() multiple times will have no effect.
