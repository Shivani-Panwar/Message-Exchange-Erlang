-module(exchange).
-export([master/0,msgpass/1]).


master() ->
	{ok,tuples}=file:consult("calls.txt"),
	callsToMake = maps:from_list(tuples),
	io:format("~n***Calls to be made***~n",[]),
	
	maps:fold(
			fun(key,value,ok)->
					io:format("~p: ~p~n", [caller,friends]),
					personProcess=spawn(calling,receiver,[caller,friends,self(),0]),
				register(caller,personProcess)
			end, ok, callsToMake),
	
	msgpass(0).
	
msgpass(id)->
	timer:sleep(100),
	receive
		{introductionMessage,caller, friends,timestamp}->
			io:fwrite("~p received intro message from ~p [~p]~n", [caller,friends,timestamp]),
			msgpass(id+1);
		{replyMessage,caller,friends,timestamp}->
			io:fwrite("~p received reply message from ~p [~p]~n", [caller,friends,timestamp]),
			msgpass(id+1)
		
	after
		10000->
			io:format("Master received no replies for 10 seconds, ending...~n")
	end.
		