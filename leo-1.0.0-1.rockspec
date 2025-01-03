package = "leo"
version = "1.0.0-1"
source = {
   url = "https://github.com/Astra-Zhi/leo.git",  
   tag = "v1.0.0"  
}
description = {
   summary = "A data processing and manipulation toolkit for Lua.",
   detailed = [[
      Leo is a comprehensive Lua module that provides a set of utility functions for data processing and manipulation, including factor encoding, multidimensional array creation, data frame construction, list management, and pipeline operations.
   ]],
   homepage = "https://github.com/Astra-Zhi/leo", 
   license = "MIT"  
}
dependencies = {
   "lua >= 5.1",  
    "luarocks >= 3.0",
    "lpeg >= 1.0.0",
}
build = {
   type = "builtin",  
   modules = {
      leo = "src/leo.lua",  
   },
   install = {
      bin = {
      },
      lua = {
      },
      lib = {
      }
   }
}
maintainers = {
   "astra <1572528939@qq.com>"  
}