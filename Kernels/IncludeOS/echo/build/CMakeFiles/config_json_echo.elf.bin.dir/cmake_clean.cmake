file(REMOVE_RECURSE
  "config.json.o"
  "lib/libconfig_json_echo.elf.bin.pdb"
  "lib/libconfig_json_echo.elf.bin.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/config_json_echo.elf.bin.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
