local m = require 'init'
local coder = require 'coder'
local util = require'util'

local s = [[
    s       <-  (atrib / exp)* (!.)^ErrEOF
    exp     <-  termo (Mais termo^ErrFator)*
    termo   <-  fator (Mult fator^ErrFator)*
    fator   <-  Float / Int / expPar / Var
    expPar  <-  '(' exp^ErrExpParEsq ')'^ErrFaltaParDir
    Var     <-  Letra (Digito / Letra)* 
    Letra   <-  [a-zA-Z] 
    Digito  <-  [0-9]
    Int     <-  Digito+ (!Letra)^ErrFatorInv  
    Float   <-  Digito+ '.' Digito+^ErrFloat (!Letra)^ErrFatorInv
    Mais    <-  '+' 
    Mult    <-  '*' 
    Igual   <-  '=' 
    atrib   <-  Var Igual exp^ErrExpAtrib

]] 

         
g, lab, pos = m.match(s)
--print(g, lab, pos)
--gerar o parser
local p = coder.makeg(g)

local dir = lfs.currentdir() .. '/yes/'
util.testYes(dir, 'calc', p)

dir = lfs.currentdir() .. '/no/'
util.testNo(dir, 'calc', p, 'strict')


