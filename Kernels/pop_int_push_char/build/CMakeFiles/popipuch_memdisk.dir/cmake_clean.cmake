file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libpopipuch_memdisk.pdb"
  "lib/libpopipuch_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/popipuch_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
