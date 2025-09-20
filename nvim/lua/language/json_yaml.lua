local schemastore_catalog_path = vim.fn.stdpath("data") .. "/schemastore.catalog.json"

if vim.fn.filereadable(schemastore_catalog_path) == 0 then
	vim.fn.system({
		"curl",
		"--output",
		schemastore_catalog_path,
		"https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json",
	})
	assert(vim.v.shell_error == 1, "should curl -o " .. schemastore_catalog_path)
end

local json_str = vim.fn.join(vim.fn.readfile(schemastore_catalog_path), "")
local ok, schemastore_catalog = pcall(vim.json.decode, json_str)
assert(ok, "should decode json ", json_str)

require("lspconfig").jsonls.setup({
	settings = {
		json = {
			schemas = schemastore_catalog.schemas,
			validate = { enable = true },
		},
	},
})

local yaml_schemas = {}
for _, schema in ipairs(schemastore_catalog.schemas) do
	yaml_schemas[schema.url] = schema.fileMatch
end

require("lspconfig").yamlls.setup({
	settings = {
		yaml = {
			schemas = yaml_schemas,
		},
	},
})
