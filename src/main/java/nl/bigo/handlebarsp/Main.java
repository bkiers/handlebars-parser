package nl.bigo.handlebarsp;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.*;

public class Main {

    private static final DescriptiveBailErrorListener ERROR_LISTENER = new DescriptiveBailErrorListener();

    private static void dump(String source) {
        HandlebarsLexer lexer = new HandlebarsLexer(CharStreams.fromString(source));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        tokenStream.fill();

        for (Token t : tokenStream.getTokens()) {
            System.out.printf("%-30s '%s'%n",
                    HandlebarsLexer.VOCABULARY.getSymbolicName(t.getType()),
                    t.getText().replace("\n", "\\n"));
        }
    }

    private static String stringTree(String source) {
        HandlebarsLexer lexer = new HandlebarsLexer(CharStreams.fromString(source));
        lexer.removeErrorListeners();
        lexer.addErrorListener(ERROR_LISTENER);

        HandlebarsParser parser = new HandlebarsParser(new CommonTokenStream(lexer));
        parser.removeErrorListeners();
        parser.addErrorListener(ERROR_LISTENER);

        ParseTree tree = parser.document();
        StringBuilder builder = new StringBuilder();

        walk(tree, builder);

        return builder.toString();
    }

    private static void walk(ParseTree tree, StringBuilder builder) {

        List<ParseTree> firstStack = new ArrayList<>();
        firstStack.add(tree);

        List<List<ParseTree>> childListStack = new ArrayList<>();
        childListStack.add(firstStack);

        while (!childListStack.isEmpty()) {

            List<ParseTree> childStack = childListStack.get(childListStack.size() - 1);

            if (childStack.isEmpty()) {
                childListStack.remove(childListStack.size() - 1);
            }
            else {
                tree = childStack.remove(0);

                String node = tree.getClass().getSimpleName().replace("Context", "");
                node = Character.toLowerCase(node.charAt(0)) + node.substring(1);
                StringBuilder indent = new StringBuilder();

                for (int i = 0; i < childListStack.size() - 1; i++) {
                    indent.append((childListStack.get(i).size() > 0) ? "|  " : "   ");
                }

                String tokenName = "";
                int tokenType = node.startsWith("terminal") ? ((CommonToken)tree.getPayload()).getType() : 0;

                if (tokenType > -1) {
                    tokenName = " (" + HandlebarsLexer.VOCABULARY.getSymbolicName(tokenType) + ")";
                }

                builder.append(indent)
                        .append(childStack.isEmpty() ? "'- " : "|- ")
                        .append(node.startsWith("terminal") ? tree.getText().replace("\n", "\\n") + tokenName : node)
                        .append("\n");

                if (tree.getChildCount() > 0) {
                    List<ParseTree> children = new ArrayList<>();
                    for (int i = 0; i < tree.getChildCount(); i++) {
                        children.add(tree.getChild(i));
                    }
                    childListStack.add(children);
                }
            }
        }
    }

    public static void main(String[] args) {

        String source = "{{link \"See Website\" url}}";

        Lexer lexer = new HandlebarsLexer(CharStreams.fromString(source));
        HandlebarsParser parser = new HandlebarsParser(new CommonTokenStream(lexer));

        ParseTree root = parser.document();

        //        System.out.println(root.toStringTree(parser));
        System.out.println(stringTree(source));
    }
}
