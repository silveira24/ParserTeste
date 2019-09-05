local m = require 'init'
local coder = require 'coder'
local util = require'util'

local s = [[
    s       <-  (Atrib / Exp)* (!.)^ErrEOF
    Exp     <-  Fator ((Mais / Mult) Fator^ErrFator)*
    Fator   <-  Float / Int / ExpPar / Var
    ExpPar  <-  '(' Exp^ErrExpParEsq ')'^ErrFaltaParDir
    Var     <-  Letra (Digito / Letra)*
    Letra   <-  [a-zA-Z] 
    Digito  <-  [0-9]
    Int     <-  Digito+ (!Letra)^ErrFator
    Float   <-  Digito+ '.' Digito+^ErrFloat (!Letra)^ErrFator 
    Mais    <-  '+' 
    Mult    <-  '*' 
    Igual   <-  '=' 
    Atrib   <-  Var Igual Exp
    ErrExpParEsq <- (!')' .)*
]] 

         
g, lab, pos = m.match(s)
print(g, lab, pos)
--gerar o parser
local p = coder.makeg(g, 'ast')

