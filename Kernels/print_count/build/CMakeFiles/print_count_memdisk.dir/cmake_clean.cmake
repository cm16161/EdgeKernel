file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libprint_count_memdisk.pdb"
  "lib/libprint_count_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/print_count_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
