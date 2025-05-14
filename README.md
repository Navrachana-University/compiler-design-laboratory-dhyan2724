# Urdu Language Compiler/Interpreter

This project is a simple compiler and interpreter for a custom programming language based on Urdu syntax. It is built using **Flex** and **Bison**, providing lexical analysis and parsing capabilities for Urdu-language source files.

## 🧠 Features

- Lexical analysis with `urdu.l` (Flex)
- Syntax parsing with `urdu.y` (Bison)
- Intermediate C code generation
- Compiled executable for Urdu code interpretation
- Example Urdu source code files

## 📂 Project Structure

```
final/
├── code.urdu              # Sample Urdu code
├── code.urdu.txt          # Same as above (possibly with different encoding or formatting)
├── lex.yy.c               # Generated C code from Flex
├── output.urdu            # Output of compilation/interpreter
├── urdu.l                 # Flex file (lexer)
├── urdu.tab.c             # Generated C parser from Bison
├── urdu.tab.h             # Header file from Bison
├── urdu.y                 # Bison file (parser)
├── urdu_interpreter.exe   # Compiled executable for interpreting Urdu code
```

## ⚙️ How to Build

### Requirements

- `flex`
- `bison`
- `gcc`

### Steps

1. **Generate the lexer and parser:**
   ```bash
   flex urdu.l
   bison -d urdu.y
   ```

2. **Compile:**
   ```bash
   gcc lex.yy.c urdu.tab.c -o urdu_interpreter
   ```

3. **Run the interpreter:**
   ```bash
   ./urdu_interpreter < code.urdu
   ```

## 📌 Notes

- Make sure your terminal supports UTF-8 to properly read and display Urdu characters.
- You may use any `.urdu` file as input. The sample `code.urdu` demonstrates the syntax and structure.

## 📄 License

This project is open source and free to use for educational and research purposes.

## ✍️ Author

- Developed by Dhyan Patel
