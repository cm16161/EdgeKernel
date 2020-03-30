file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libget_time_memdisk.pdb"
  "lib/libget_time_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/get_time_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
