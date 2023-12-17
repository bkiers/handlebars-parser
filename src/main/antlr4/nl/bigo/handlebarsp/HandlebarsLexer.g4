/*
The MIT License (MIT)

Copyright (C) 2023 bkiers, https://github.com/bkiers

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Project      : An ANTLR 4 grammar for Handlebars.
Developed by : Bart Kiers, bart@big-o.nl
*/

lexer grammar HandlebarsLexer;

Comment
 : '{{!--' .*? '--}}'
 | '{{!' .*? '}}'
 ;

OBrace2Tilde : '{{~' -> pushMode(Handlebars);
OBrace2 : '{{' -> pushMode(Handlebars);
OBrace3Tilde : '{{~{' -> pushMode(Handlebars);
OBrace4 : '{{{{' -> pushMode(Handlebars);
OBrace3 : '{{{' -> pushMode(Handlebars);
OBrace2TildeAmp : '{{~&' -> pushMode(Handlebars);
OBrace2Amp : '{{&' -> pushMode(Handlebars);
OBrace2Hash : '{{#' -> pushMode(Handlebars);
OBrace2TildeHash : '{{~#' -> pushMode(Handlebars);
OBrace4FSlash : '{{{{/' -> pushMode(Handlebars);
OBrace2FSlash : '{{/' -> pushMode(Handlebars);
OBrace2TildeFSlash : '{{~/' -> pushMode(Handlebars);
OBrace2Caret : '{{^' -> pushMode(Handlebars);
OBrace2TildeCaret : '{{~^' -> pushMode(Handlebars);
OBrace2Gt : '{{>' -> pushMode(Handlebars);
OBrace2TildeGt : '{{~>' -> pushMode(Handlebars);
OBrace2HashGt : '{{#>' -> pushMode(Handlebars);
OBrace2TildeHashGt : '{{~#>' -> pushMode(Handlebars);

Html
 : ( ~[{]+ | '{' ~'{' | '{' EOF )+
 ;

mode Raw;

RawCloseBrace : '{{{{/' S? Identifier S? '}}}}' -> popMode, popMode;
RawAtom : .;

mode Handlebars;

CBrace3Tilde : '}~}}' -> popMode;
CBrace4 : '}}}}' -> pushMode(Raw);
CBrace3 : '}}}' -> popMode;
CBrace2Tilde : '~}}' -> popMode;
CBrace2 : '}}' -> popMode;
Tilde : '~';
At : '@';
FSlash :  '/';
Dot : '.';
OPar : '(';
CPar : ')';
Eq : '=';
Amp : '&';
Pipe : '|';
Caret : '^';

NullLiteral : 'null';
UndefinedLiteral : 'undefined';
As : 'as';
Else : 'else';

BooleanLiteral
 : 'true'
 | 'false'
 ;

Identifier
 : [a-zA-Z_] [a-zA-Z_0-9-]*
 ;

StringLiteral
 : '\'' SingleQuotedStringCharacter* '\''
 | '"' DoubleQuotedStringCharacter* '"'
 ;

NumericLiteral
 : '-'? [0-9]+ ( '.' [0-9]+ )?
 ;

Spaces
 : [ \t\r\n]+ -> skip
 ;

fragment SingleQuotedStringCharacter
 : ~['\\]
 | '\\' .
 ;

fragment DoubleQuotedStringCharacter
 : ~["\\]
 | '\\' .
 ;

fragment S
 : [ \t\r\n]+
 ;