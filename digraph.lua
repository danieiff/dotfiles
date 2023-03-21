-- :dig ga <C-v>
vim.cmd [[
" カッコ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』
digraphs j< 12304  " 【
digraphs j> 12305  " 】

" 句読点
digraphs j, 65292  " ，
digraphs j. 65294  " ．
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：

" 数字
digraphs j0 65296  " ０
digraphs j1 65297  " １
digraphs j2 65298  " ２
digraphs j3 65299  " ３
digraphs j4 65300  " ４
digraphs j5 65301  " ５
digraphs j6 65302  " ６
digraphs j7 65303  " ７
digraphs j8 65304  " ８
digraphs j9 65305  " ９

" その他の記号
digraphs j~ 12316  " 〜
digraphs j/ 12539  " ・
digraphs js 12288  " 　

digraphs j, 12289  " 、
digraphs j. 12290  " 。

noremap fj f<C-k>j
noremap Fj F<C-k>j
noremap tj t<C-k>j
noremap Tj T<C-k>j

digraphs jj 106  " j

]]

--ka	か
--sa	さ
--ta	た
--na	な
--Ka	カ
--Sa	サ

--yA	ゃ
--YA	ャ
--a5	あ
--A6	ア
