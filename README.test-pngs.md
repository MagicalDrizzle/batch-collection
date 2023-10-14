`test-pngs.cmd`: compare lossless PNG compression programs.
The programs tested:
- `advpng` and `advdef`: https://github.com/amadvance/advancecomp
- `ect`: https://github.com/fhanau/Efficient-Compression-Tool
- `optipng`: https://optipng.sourceforge.net
- `oxipng`: https://github.com/shssoichiro/oxipng
- `pingo`: https://www.css-ig.net/pingo
- `pngcrush`: https://pmt.sourceforge.io/pngcrush/
- `PngOptimizer`: https://psydk.org/pngoptimizer
- `pngout`: http://www.advsys.net/ken/utils.htm
- `TruePNG`: http://x128.ho.ua/pngutils.html

Put your test image file in the same directory as the script with the name `test.png` and run the script.
The result should be saved into `testpng-result.txt`.