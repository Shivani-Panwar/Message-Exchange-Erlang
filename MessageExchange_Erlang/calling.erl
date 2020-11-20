-module(calling).
-export([makeCall/4]).

makeCall(caller,friends,personProcess,id)->
	if
		id==0->
			lists:foreach(
				fun(data)->whereis(data)!{caller,intoductionMessage,element(3,now())}
					end,friends),
			
			makeCall(caller,friends,personProcess,id+1);
	
		id>0->
			receive
				{currentPerson,intorductionMessage,timestamp}->
					personProcess!{introductionMessage,caller,currentPerson,timestamp},
					whereis(currentPerson)!{caller,replyMessage,timestamp},
					makeCall(caller,friends,personProcess,id+1);
					
					
				{currentPerson,replyMessage,timestamp}->
					personProcess!{replyMessage,caller,currentPerson,timestamp},
					makeCall(caller,friends,processPerson,id+1)
					
			after
				5000->
					io:fwrite("Process ~p has received no calls for 5 seconds, ending...~n",[caller])
			end
	end.