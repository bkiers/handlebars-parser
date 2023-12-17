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

// https://handlebars-lang.github.io/spec/
parser grammar HandlebarsParser;

options {
  tokenVocab=HandlebarsLexer;
}

document
 : program EOF
 ;

program
 : statementList
 ;

statementList
 : statement+
 ;

statement
 : mustache
 | block
 | rawBlock
 | partial
 | partialBlock
 | Html
 | Comment
 ;

mustache
 : '{{' helperName paramList? hashPairList? '}}'
 | '{{~' helperName paramList? hashPairList? '~}}'
 | '{{{' helperName paramList? hashPairList? '}}}'
 | '{{~{' helperName paramList? hashPairList? '}~}}'
 | '{{&' helperName paramList? hashPairList? '}}'
 | '{{~&' helperName paramList? hashPairList? '~}}'
 ;

block
 : blockStart program inverseChain? blockEnd
 | invertedBlockStart program inverse? blockEnd
 ;

rawBlock
 : rawBlockStart RawAtom* RawCloseBrace
 ;

partial
 : '{{>' helperName paramList? hashPairList? '}}'
 | '{{~>' helperName paramList? hashPairList? '~}}'
 ;

partialBlock
 : partialBlockStart program blockEnd
 ;

blockStart
 : '{{#' helperName paramList? hashPairList? blockParams? '}}'
 | '{{~#' helperName paramList? hashPairList? blockParams? '~}}'
 ;

blockEnd
 : '{{/' helperName '}}'
 | '{{~/' helperName '}}'
 ;

rawBlockStart
 : '{{{{' helperName paramList? hashPairList? '}}}}'
 ;

invertedBlockStart
 : '{{^' helperName paramList? hashPairList? blockParams? '}}'
 | '{{~^' helperName paramList? hashPairList? blockParams? '~}}'
 ;

// {{ ~ opt # > PartialName ParamList opt HashPairList opt ~ opt }}
partialBlockStart
 : '{{#>' partialName paramList? hashPairList? '}}'
 | '{{~#>' partialName paramList? hashPairList? '~}}'
 ;

inverseChain
 : inverseChainStart program inverseChain?
 | inverse
 ;

inverseChainStart
 : '{{' Else helperName paramList? hashPairList? blockParams? '}}'
 | '{{~' Else helperName paramList? hashPairList? blockParams? '~}}'
 ;

inverse
 : inverseSeparator program
 ;

inverseSeparator
 : '{{' ( Else | '^' ) '}}'
 | '{{~' ( Else | '^' ) '~}}'
 ;

blockParams
 : As '|' blockParamList '|'
 ;

blockParamList
 : Identifier+
 ;

helperName
 : pathExpression
 | dataExpression
 | StringLiteral
 | NumericLiteral
 | BooleanLiteral
 | NullLiteral
 | UndefinedLiteral
 ;

partialName
 : helperName
 | subexpression
 ;

subexpression
 : '(' helperName paramList? hashPairList? ')'
 ;

paramList
 : param+
 ;

param
 : helperName
 | subexpression
 ;

hashPairList
 : hashPair+
 ;

hashPair
 : Identifier '=' param
 ;

pathExpression
 : pathSegments
 ;

dataExpression
 : '@' pathSegments
 ;

pathSegments
 : Identifier ( pathSeparator Identifier )*
 | pathSeparator
 ;

pathSeparator
 : '/'
 | '.'
 ;