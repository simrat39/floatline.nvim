# Benchmark for some statusline
   Many lua statuslines say they are fast. Is it true?

   It benchmark a redraw time.
   Every time you type a key or run vim.cmd the statusline need to draw again a few time.
   On insert mode with lsp server it redraw statusline a lot more than 20 time with 1 keystroke.

   Benchmark result is updated by github CI bot. It run 10.000 time

##Result

``` log
Update by bot:
Fri Oct 22 09:38:14 UTC 2021

Time airline: 6.109339798
Text:
 NORMAL  lua/benchmark.lua                                       1% ㏑:1/55☰℅:1 


Time lightline: 0.531383366
Text:
 NORMAL  benchmark.lua                       unix | utf-8 | no ft    1%    1:1  


Time galaxyline: 2.512254318
Text:
▊   1.4k  benchmark.lua  1 : 1   Top                               benchmark▊


Time windline: 0.453795648
Text:
 NORMAL  benchmark.lua 1.38k                             l/n   1:1    1% 


Time lualine: 0.609165322
Text:
 NORMAL  benchmark.lua                               utf-8 | unix    1%    1:1  


Time feline: 1.517078479
Text:
▊     benchmark.lua  1.38k    1:0                                   Top ▁▁


Time staline: 0.602431735
Text:
                       benchmark.lua                    [1/55] :1 並1%  


Time neoline: 0.969327847
Text:
NORMAL                                                    🧊   utf-8  1:1


Time mini: 0.34808037
Text:
 N  lua/benchmark.lua                                                1|55│ 1|40 


Time empty: 0.061663292
Text:
 ~/work/floatline.nvim/floatline.nvim/lua/benchmark.lua  utf-8       C:1 L:1 Top

```
