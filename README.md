# Benchmark for some statusline
   Many lua statuslines say they are fast. Is it true?

   It benchmark a redraw time. Every time you type a key or run vim.cmd the
   statusline need to draw again 5 or 6 time.

   Benchmark result is updated by github CI bot. It run 10.000 time



# Result

``` log
Update by bot:
Sun Oct 17 12:00:14 UTC 2021

Time airline: 6.052192768
Text:
 NORMAL  lua/benchmark.lua                                       1% ㏑:1/55☰℅:1 


Time lightline: 0.532830304
Text:
 NORMAL  benchmark.lua                       unix | utf-8 | no ft    1%    1:1  


Time galaxyline: 2.462681179
Text:
▊   1.4k  benchmark.lua  1 : 1   Top                               benchmark▊


Time windline: 0.465606156
Text:
 NORMAL  benchmark.lua 1.38k                             l/n   1:1    1% 


Time lualine: 0.610481914
Text:
 NORMAL  benchmark.lua                                utf-8 | unix  Top    1:1  


Time feline: 1.521700016
Text:
▊     benchmark.lua  1.38k    1:0                                   Top ▁▁


Time staline: 0.605599148
Text:
                       benchmark.lua                    [1/55] :1 並1%  


Time neoline: 0.990382572
Text:
NORMAL                                                    🧊   utf-8  1:1


Time mini: 0.377406743
Text:
 N WR  lua/benchmark.lua                                             1|55│ 1|40 


Time empty: 0.06287089
Text:
 ~/work/floatline.nvim/floatline.nvim/lua/benchmark.lua  utf-8       C:1 L:1 Top

```
