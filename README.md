# IOS-AutoCompleteSearch

<b>It is simple example How to use MVVMC in Swift3</b>

use libs: RxSwift, RxCocoa, RxAlamofire, Alamofire

In this project I use Drive instance of Binding: 

<b>Complate Binding vs Driver in RxSwift</b>

I will try to improve it with an example:

Imagine you have this code:

<i>let intObservable = sequenceOf(1, 2, 3, 4, 5, 6)<br>
     .observeOn(MainScheduler.sharedInstance)<br>
     .catchErrorJustReturn(1)<br>
     .map { $0 + 1 }<br>
     .filter { $0 < 5 }<br>
     .shareReplay(1)</i>
     
 Driver You can read more in detail what the Driver is all about from the documentation. 
 In summary, it simply allows you to rely on these properties: 
 - Can't error out<br> 
 - Observe on main scheduler<br> 
 - Sharing side effects<br>
 
 if you use Driver, you won't have to specify observeOn, shareReplay nor catchErrorJustReturn.<br>
 
 In summary, the code above is similar to this one using Driver:<br>
 
 <i>let intDriver = sequenceOf(1, 2, 3, 4, 5, 6)<br>
     .asDriver(onErrorJustReturn: 1)<br>
     .map { $0 + 1 }<br>
     .filter { $0 < 5 }</i>
