package nl.bigo.handlebarsp;

import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.junit.Test;
import java.io.File;
import java.util.Objects;
import java.util.Scanner;

import static org.junit.Assert.*;

public class ParserTests extends BaseTest {

    private final HandlebarsLexer lexer;
    private final HandlebarsParser parser;

    public ParserTests() {
        this.lexer = new HandlebarsLexer(CharStreams.fromString(""));
        this.parser = new HandlebarsParser(new CommonTokenStream(lexer));

        this.lexer.removeErrorListeners();
        this.parser.removeErrorListeners();

        this.parser.setErrorHandler(new BailErrorStrategy());
    }

    @Test
    public void testAllFiles() throws Exception {
        var files = new File("./handlebars").listFiles((dir, name) -> name.endsWith(".hb"));

        for (var file : Objects.requireNonNull(files)) {
            testFile(file);
        }
    }

    private void testFile(File file) throws Exception {
        var fileName = file.getName();
        var parserRule = fileName.contains("_") ? fileName.split("_")[0] : fileName.split("\\.")[0];
        var alternative = fileName.contains("_") ? fileName.split("[_.]")[1] : null;
        var scanner = new Scanner(file).useDelimiter("\\Z");
        var input = scanner.hasNext() ? scanner.next() : "";
        var sources = input.split("([ \t]*\r?\n){2,}");

        for (var source : sources) {

            if (source.isEmpty() || source.trim().startsWith("#")) {
                continue;
            }

            try {
                lexer.setInputStream(CharStreams.fromString(source));
                parser.setTokenStream(new CommonTokenStream(lexer));

                var method = parser.getClass().getMethod(parserRule);
                var root = method.invoke(parser);

                if (alternative != null) {
                    assertEquals("Failed for: '%s'".formatted(source), super.alternativeClassName(alternative), root.getClass().getSimpleName());
                }

                assertEquals("'%s' not completely parsed".formatted(source), Lexer.EOF, parser.getCurrentToken().getType());
            }
            catch (Exception e) {
                fail("ERROR: " + file + ", " + e.getMessage() + ", input:\n" + source);
            }
        }

        System.out.printf("OK: %s (%d)%n", file, sources.length);
    }
}
