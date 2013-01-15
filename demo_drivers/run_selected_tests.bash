backup=`pwd`
echo $backup

# e.g. create a list of all directorties containing .cc or .h files with
# the word "preconditioner" in them.
list=`cat <(find . -name *.cc)  <(find . -name *.h ) | xargs grep "preconditioner" -l | xargs -n 1 dirname`

list="./axisym_navier_stokes/unstructured_torus ./interaction/unstructured_fsi ./meshing/mesh_from_inline_triangle ./meshing/mesh_from_triangle "
list=`echo $list "./meshing/mesh_from_xfig_triangle ./solid/unstructured_solid ./solid/unstructured_adaptive_solid "`
list=`echo $list "./navier_stokes/jeffery_orbit ./navier_stokes/unstructured_adaptive_fs "`
list=`echo $list "./navier_stokes/unstructured_adaptive_ALE ./navier_stokes/unstructured_fluid ./navier_stokes/unstructured_adaptive_3d_ALE "`

echo $list

for dir in `echo $list`; do
    cd $dir
    make check
    cd $backup
done
