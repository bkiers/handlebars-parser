package nl.bigo.handlebarsp;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;
import java.util.List;
import static org.junit.Assert.*;

public abstract class BaseTest {

    protected void testTokens(String[] inputs, int expectedTokenType) {
        for (var input : inputs) {
            this.testSingleToken(input, expectedTokenType);
        }
    }

    protected void testSingleToken(String input, int expectedTokenType) {
        var token = this.token(1, input, 0);
        assertEquals(expectedTokenType, token.getType());
    }

    protected void testToken(int expectedTokens, String input, int index, int expectedTokenType) {
        var token = this.token(expectedTokens, input, index);
        assertEquals(expectedTokenType, token.getType());
    }

    protected List<Token> createTokens(String input) {
        var charStream = CharStreams.fromString(input);
        var tokenStream = new CommonTokenStream(new HandlebarsLexer(charStream));

        tokenStream.fill();

        var tokens = tokenStream.getTokens();

        return tokens.subList(0, tokens.size() - 1);
    }

    protected Token token(int expectedTokens, String input, int index) {
        var tokens = createTokens(input);

        if (tokens.size() != expectedTokens) {
            throw new RuntimeException(String.format("'%s' produced %d token(s), expected %d",
                    input, tokens.size(), expectedTokens));
        }

        return tokens.get(index);
    }

    protected String alternativeClassName(String alternative) {
        return "%s%sContext".formatted(
                Character.toUpperCase(alternative.charAt(0)),
                alternative.substring(1));
    }
}
