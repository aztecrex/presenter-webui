'use strict';

const marked = require('marked')

exports.go = function(text) {
    const options = {};
    const tokens = marked.lexer(text, options);
    console.log(marked.parser(tokens));
}

exports.go2 = function(text) {
    const options = {};
    const lexer = new marked.Lexer(options);
    const tokens = lexer.lex(text);
    console.log(tokens);
    // console.log(lexer.rules);
}
