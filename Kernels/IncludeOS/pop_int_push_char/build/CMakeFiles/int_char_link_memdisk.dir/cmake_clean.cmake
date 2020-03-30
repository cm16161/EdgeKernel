file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libint_char_link_memdisk.pdb"
  "lib/libint_char_link_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/int_char_link_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
