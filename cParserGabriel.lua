local m = require 'init'
local coder = require 'coder'
local util = require'util'

local s = [[
    s       <-  (Atrib / Exp)* (!.)^ErrEOF
    --Exp     <-  Fator ((Mais / Mult)^s^ErrSinal Fator)*
    Exp     <-  Fator ((Mais / Mult) Fator^ErrFator)*
    Fator   <-  Float / Int / ExpPar / Var
    ExpPar  <-  '(' Exp^ErrExpParEsq ')'^ErrFaltaParDir
    Var     <-  Letra (Digito / Letra)*
    --Var     <-  Id (Int Id?)*
    Letra   <-  [a-zA-Z] 
    Digito  <-  [0-9]
    Int     <-  Digito+ (!Letra)^ErrFator
    Float   <-  Digito+ '.' Digito+^ErrFloat (!Letra)^ErrFator 
    Mais    <-  '+' 
    Mult    <-  '*' 
    Igual   <-  '=' 
    Atrib   <-  Var Igual Exp
    ErrExpParEsq <- (!')' .)*
    --ErrFaltaParDir <- ''
]] 

         
g, lab, pos = m.match(s)
print(g, lab, pos)
--gerar o parser
local p = coder.makeg(g, 'ast')

--rodar os testes 'yes'
local dir = lfs.currentdir() .. '/test/c89/test/yes/'
util.testYes(dir, 'c', p)

--rodar os testes 'no'
local dir = lfs.currentdir() .. '/test/c89/test/no/'
util.testNo(dir, 'c', p)

