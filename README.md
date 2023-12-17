# Elixir parser

An ANTLR 4 grammar and parser for Handlebars.

To generate the parser classes, do a `mvn clean install` and then do something
like this:

```java
String source = "{{link \"See Website\" url}}";

Lexer lexer = new HandlebarsLexer(CharStreams.fromString(source));
HandlebarsParser parser = new HandlebarsParser(new CommonTokenStream(lexer));

ParseTree root = parser.document();

System.out.println(root.toStringTree(parser));
```

Or use the `stringTree(...)` method in the Main class:

```java
System.out.println(stringTree(source));
```

resulting in a nice ASCII tree of the input:

```
'- document
   |- program
   |  '- statementList
   |     '- statement
   |        '- mustache
   |           |- {{ (OBrace2)
   |           |- helperName
   |           |  '- pathExpression
   |           |     '- pathSegments
   |           |        '- link (Identifier)
   |           |- paramList
   |           |  |- param
   |           |  |  '- helperName
   |           |  |     '- "See Website" (StringLiteral)
   |           |  '- param
   |           |     '- helperName
   |           |        '- pathExpression
   |           |           '- pathSegments
   |           |              '- url (Identifier)
   |           '- }} (CBrace2)
   '- <EOF>
```