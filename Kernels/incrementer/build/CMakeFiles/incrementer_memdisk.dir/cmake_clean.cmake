file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libincrementer_memdisk.pdb"
  "lib/libincrementer_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/incrementer_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
