package nl.bigo.handlebarsp;

import org.junit.Test;

import static nl.bigo.handlebarsp.HandlebarsLexer.*;

public class LexerTests extends BaseTest {

    @Test
    public void htmlTest() {
        String[] tests = {
                "{ { bla",
                "{"
        };

        super.testTokens(tests, Html);
    }

    @Test
    public void commentTest() {
        String[] tests = {
                "{{! ... }}",
                "{{!-- {{! ... }} --}}"
        };

        super.testTokens(tests, Comment);
    }

    @Test
    public void nullTest() {
        super.testToken(3, "{{null}}", 1, NullLiteral);
        super.testToken(3, "{{ null }}", 1, NullLiteral);
    }
}