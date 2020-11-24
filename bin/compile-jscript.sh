#!/bin/bash

#set -x

# 1. closure-compiler:
# https://github.com/google/closure-compiler ...
# necesas nun mvn aŭ npx por ruli ĝin:
# npx ŝajnas la plej rapida voj:
# https://www.npmjs.com/package/google-closure-compiler

# 2. MathJax
# curl -LO https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=AM_CHTML

compiler="java -jar /usr/local/share/java/closure-compiler.jar"
# aŭ (post): npm install google-closure-compiler
# npx google-closure-compiler

js_in="jsc/util.js jsc/transiroj.js jsc/artikolo.js jsc/kadro.js jsc/redaktilo.js"
js_mn_in="jsc/malnova.js"

js_out=build/jsc/revo-1c.js
js_mn_out=build/jsc/malnova-1c.js
opt=BUNDLE
#opt=SIMPLE

echo "$js_out <-- $js_in"

# vi povas antaŭinstali por eviti ĉiufoje ŝargi el la reto:
#   npm install google-closure-compiler
${compiler} --compilation_level ${opt} \
            --js_module_root jsc --entry_point jsc/kadro.js \
            --js_output_file ${js_out} \
            ${js_in}

echo "$js_mn_out <-- $js_mn_in"

${compiler} --compilation_level ${opt} \
            --js_module_root jsc \
            --js_output_file ${js_mn_out} \
            ${js_mn_in}
           
