package framework.project1;

import generated.SplLexer.SplLexer;

import java.io.InputStream;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.Vocabulary;

public class Grader {

    private final InputStream sourceStream;

    public Grader(InputStream sourceStream) {
        this.sourceStream = sourceStream;
    }

    public void run() throws Exception {
        CharStream input = CharStreams.fromStream(sourceStream);

        SplLexer lexer = new SplLexer(input);

        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tokens.fill();

        Vocabulary vocabulary = lexer.getVocabulary();

        for (Token token : tokens.getTokens()) {
            String tokenName;
            String raw;

            if (token.getType() == Token.EOF) {
                tokenName = "EOF";
                raw = "";
            } else {
                tokenName = vocabulary.getSymbolicName(token.getType());
                raw = token.getText();
            }

            System.out.printf(
                "Token: %s, Raw: %s%n",
                tokenName,
                raw
            );
        }
    }
}
