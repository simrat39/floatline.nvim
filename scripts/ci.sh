#! /bin/bash

sed -i '1,10!d' README.md
echo "\`\`\` log" >> README.md
echo "Update by bot:" >> README.md

date >> README.md

./scripts/benchmark.sh  10000

cat output.txt
cat output.txt >> README.md

echo "\`\`\`" >> README.md

rm output.txt
