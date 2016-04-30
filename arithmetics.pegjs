/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then computes their value.
 */
{
  var util = require('util');
  var symbolTable = {
    PI: Math.PI
  };

}

start
  = s1:statement (SEMICOL s2:statement)* { return symbolTable; }

statement
  = IF c:condition THEN ((&{ return c; } statement ELSE empty)/(empty ELSE statement))
  / assign

assign
  = id:ID ASSIGN a:condition {
         symbolTable[id] = a; return a;
      }
  / condition

condition 
  = a1:additive comp:COMP a2:additive { return eval(a1+comp+a2); }
  / additive

additive
  = left:multiplicative rest:(ADDOP multiplicative)* { 
      return rest.reduce((prod, [op, num])=>{ return eval(prod+op+num); },left);
       let sum = left;
       rest.forEach( (x) => {
         eval(`sum ${x[0]}= ${x[1]}`);
       });
       return sum;
    }
  / multiplicative

multiplicative
  = left:primary rest:(MULOP primary)* { 
      return rest.reduce((prod, [op, num])=>{ return eval(prod+op+num); },left);
    }
  / primary

primary
  = integer
  / id:ID  { return symbolTable[id]; }
  / LEFTPAR assign:assign RIGHTPAR { return assign; }

/* A rule can also contain human-readable name that is used in error messages (in our example, only the integer rule has a human-readable name). */
integer "integer"
  = NUMBER

_ "white spaces" = $[ \t\n\r]*

IF = _ "if" _
THEN = _ "then" _
ELSE = _ "else" _
COMP = _ comp:("=="/"!="/"<="/">="/"<"/">") _ { return comp; }
ADDOP = PLUS / MINUS
MULOP = MULT / DIV
PLUS = _"+"_  { return '+'; }
MINUS = _"-"_ { return '-'; }
MULT = _"*"_  { return '*'; }
DIV = _"/"_   { return '/'; }
LEFTPAR = _"("_
RIGHTPAR = _")"_
NUMBER = _ digits:$[0-9]+ _ { return parseInt(digits, 10); }
ID "identifier" = _ id:$([a-z_]i$([a-z0-9_]i*)) _ { return id; }
ASSIGN = _ '=' _
SEMICOL = _ ';' _

empty
  = IF c:emptycondition THEN empty (ELSE empty)? {}
  / emptyassign {}

emptyassign
  = id:ID ASSIGN a:emptycondition { }
  / emptycondition {}

emptycondition 
  = a1:emptyadditive comp:COMP a2:emptyadditive { }
  / emptyadditive {}

emptyadditive
  = left:emptymultiplicative rest:(ADDOP emptymultiplicative)* { }
  / emptymultiplicative {}

emptymultiplicative
  = left:emptyprimary rest:(MULOP emptyprimary)* { }
  / emptyprimary {}

emptyprimary
  = integer {}
  / id:ID  { }
  / LEFTPAR assign:emptyassign RIGHTPAR { }

