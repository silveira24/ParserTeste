local m = require 'init'
local coder = require 'coder'
local util = require'util'

local s = [[
    s       <-  (Atrib / Exp)* (!.)^ErrEOF
    Exp     <-  Fator ((Mais / Mult) Fator^ErrFator)*
    Fator   <-  Float / Int / ExpPar / Var
    ExpPar  <-  '(' Exp')'^ErrFaltaParDir
    Var     <-  Letra (Digito / Letra)* 
    Letra   <-  [a-zA-Z] 
    Digito  <-  [0-9]
    Int     <-  Digito+ (!Letra)^ErrFator  
    Float   <-  Digito+ '.' Digito+^ErrFloat (!Letra)^ErrFator 
    Mais    <-  '+' 
    Mult    <-  '*' 
    Igual   <-  '=' 
    Atrib   <-  Var Igual Exp
    --ErrExpParEsq <- (!')' .)*
]] 

         
g, lab, pos = m.match(s)
print(g, lab, pos)
--gerar o parser
local p = coder.makeg(g, 'ast')

local pos, lab, errpos = p:match"(3 * 4  x = 2"
assert(pos == nil and lab == "ErrFaltaParDir", "Era pra ser 'ErrFaltaParDir' mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"1 + (4 + 5.)"
assert(pos == nil and lab == "ErrFloat", "Era pra ser 'ErrFloat' mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"3 - 2"
assert(pos == nil and lab == "ErrEOF", "Era pra ser 'ErrEOF' mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"3 + 2"
assert(pos == 6 and lab == nil, "Era pra ser uma entrada válida mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"3 + 5 = 7"
assert(pos == nil and lab == "ErrEOF", "Era pra ser 'ErrEOF' mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"42141412hbsa"
assert(pos == nil and lab == "ErrFator", "Era pra ser 'ErrFator' mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"3 * 4)  x = 2"
assert(pos == nil and lab == "ErrEOF", "Era pra ser 'ErrEOF' mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"@#@$$$%@%"
assert(pos == nil and lab == "ErrEOF", "Era pra ser 'ErrEOF'  mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"2 + 2 + 3 + (x * 4)"
assert(lab == nil, "Era pra ser entrada valida mas foi " .. tostring(lab))
local pos, lab, errpos = p:match"5 + ("
assert(pos == nil and lab == "ErrFaltaParDir", "Era pra ser 'ErrFaltaParDIR' mas foi " .. tostring(lab))

