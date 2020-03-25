file(REMOVE_RECURSE
  "memdisk.o"
  "memdisk.fat"
  "lib/libchar_string_link_memdisk.pdb"
  "lib/libchar_string_link_memdisk.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/char_string_link_memdisk.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
