# com.reliance.tobi.test.imageloader
A Flutter project that demonstrates the use of Dart isolates to download mutiple images in parallel and then show them on the screen. The intention behind using Dart isolates in favour of regular async-await syntax is to prevent the UI thread from blocking while the network is fetching the image in question.

# Theory
The Dart runtime uses an event-oriented and single-threaded model to acheive concurrency. This means that the default way the runtime acheives concurrency in Dart is by:

1) Executinng the app until it encounters a blocking function.
2) When this blocking function blocks, the runtime executes the rest of the code in the context of execution surrounding the blocking method call, and juggles this with the blocking method itself. That way it is doing them at the same time.
3) When one of the executing parts of the program (it might be the blockin function call or the code around it), is done running, the program would move forward.

In Dart, these blocking function calls are `Future`s. A Future is similar to a JavaScript promise in the sense that it is an event-driven model of a concurrent process. Much like a JavaScript promise, a `Future` in Flutter has methods to wait for events while executing. One such function is the `Future<T>.then(T value)` function that executes right after the concurrent process is finished.