#!/bin/bash
for i in {1089..1089};
do
  cp background.DAT background"_"$i.DAT
  sed -i s/1089/$i/g background"_"$i.DAT
  sed -i s/zeeg/$i/g background"_"$i.DAT
<<<<<<< HEAD:mcfm_gen.sh
  ./mcfm background"_"$i.DAT
=======

  cp mcfm_run.sh mcfm_run"_"$i.sh
  sed -i s/1089/$i/g mcfm_run"_"$i.sh
  bsub -q 1nw mcfm_run"_"$i.sh
>>>>>>> 5198123dd5675793652c390c38bc62da73002e3f:mcfm_sub.sh
done
