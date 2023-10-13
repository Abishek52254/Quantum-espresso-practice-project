#!/bin/sh
NAME="ecut"

for CUTOFF in  10 15 20 25 30 35 40
do
cat > ${NAME}_${CUTOFF}.in << EOF
 &control
    calculation = 'scf',
    prefix = 'n2'
    outdir = './.'
    pseudo_dir = './.'
 /
 &system
    ibrav =  0,
    nat =  2,
    ntyp = 1,
    ecutwfc = $CUTOFF
 /
 &electrons
    mixing_beta = 0.6
 /
ATOMIC_SPECIES
 N 14.007 N.pbe-n-kjpaw_psl.1.0.0.UPF

ATOMIC_POSITIONS angstrom
 N  7.7 7.5 9.23205
 N 6.56 7.5 9.23205

CELL_PARAMETERS (angstrom)
 15 0 0
  0 15 0
 0 0 15

K_POINTS (gamma)

EOF

pw.x < ${NAME}_${CUTOFF}.in > ${NAME}_${CUTOFF}.out
echo ${NAME}_${CUTOFF}
grep ! ${NAME}_${CUTOFF}.out  
done
awk '/kinetic-energy/{ecut=$4}
     /^!.*total/{print ecut, $5}' *out > etot_v_ecut.dat

