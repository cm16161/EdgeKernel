file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libecho_memdisk.pdb"
  "lib/libecho_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/echo_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
