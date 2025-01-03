-- rest-nvim dependent on xml2lua
local xml2lua = require 'neotest.lib.xml.internal'
xml2lua.parse = require 'neotest.lib.xml'.parse
return xml2lua
