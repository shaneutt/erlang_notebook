%taken from ricecake, thanks ricecake!

%Types
Integer    = 54.
Float      = 3.141592653589.
Number     = Integer + Float.
Atom       = atom.
ThreeTuple = {atom, [], {}}.
List       = [Atom, ThreeTuple, #{}].
Map        = #{ atom => List, ThreeTuple => Atom, Number => Float}.
Binary     = <<"I'm a little teapot">>.

%splitting and matching on binaries
<<Nibble:4/bits, OtherNibble:4/bits,  _/bits>> = Binary.
<<"I">> = <<Nibble:4/bits, OtherNibble:4/bits>>.

%Anonymous function
Fun = fun This(3) -> cat; This(X) when X > 3 -> This(X-1) end.
cat = Fun(34).

Pid = self().

% Unique reference -- unique per cluster lifetime
Ref = erlang:make_ref().

%binding
FullTuple = {This, Will, Match} = {3, Atom, "to be or not to be"}.
Match     = "to be or not to be".
This      = 3.
Will      = atom.

% comparison tests
true  = 1 ==  1.
true  = 2 ==  2.0.
true  = 3 /=  4.
true  = 4 =<  5.
true  = 5 <   6.
true  = 6 >=  5.
true  = 7 >   6.
true  = 8 =:= 8.
false = 8 =:= 8.0.
true  = 8 =/= 8.0.
false = 8 =/= 8.

% arithmetic operators
1 = +1.
-1 = -1.
2 = 1+1.
0 = 1-1.
4 = 2*2.
2.5 = 5/2.
-9 = bnot 8.
2 = 5 div 2.
1 = 5 rem 2.
10 = 170 band 15.
175 = 170 bor 15.
165 = 170 bxor 15
65536 = 1 bsl 16.
1 = 65536 bsr 16.

%boolean expressions
true = not false.
true = true and true.
true = true or false.
true = false xor true.

% comparison precedence
%number < atom < reference < fun < port < pid < tuple < map < nil < list < bit string

%list comprehension
%This list of...   <expression> ... where ... <variable match> ... comes from ... <list> ... <filter condition>
[6,12,18,24,30] = [ Number * 3 || Number <- [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], Number rem 2 == 0 ].

% binary comprehensions
[ {Red, Green, Blue, Alpha} || <<Red/unsigned-integer, Green/unsigned-integer, Blue/unsigned-integer, Alpha/unsigned-integer>> <= <<1,2,3,4,5,6,7,8>>].
<< <<X:8>> || <<X:8>> <= <<1,2,3,4,5>>, X rem 2 == 0 >>.
<< <<X:8>> || X <- lists:seq(0,10), X rem 2 == 0 >>.


% case statement
ok = case Integer of
	34 -> io:format("it's thirty four!");
	N when N > 7 -> io:format("bigger than 7!");
	N -> io:format("It's ~p!")
end.

% if statements
RandomNumber = random:uniform(10).
ok = if
	RandomNumber >  5 -> io:format("More than 5!");
	RandomNumber =< 5 -> io:format("less than or equal to 5!")
end.

% send/receive statments
self() ! {message, random:uniform(10)}.
ok = receive
	{message, N} when N < 5 -> io:format("less than 5!");
	{message, N} when N > 5 -> io:format("more than 5!");
	{message, N}            -> io:format("neither more nor less than 5!");
	WTF                     -> io:format("got unexpected: ~p", [WTF])
after
	1000 -> io:format("Timeout!")
end.
