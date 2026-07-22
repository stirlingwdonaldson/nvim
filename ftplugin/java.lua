local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local mason_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher = vim.fn.glob(mason_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")

if launcher == "" then
  vim.notify("jdtls launcher not found. Run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok and type(blink.get_lsp_capabilities) == "function" then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xmx1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
  "-jar",
  launcher,
  "-configuration",
  mason_dir .. "/config_mac",
  "-data",
  workspace_dir,
}

local lombok = mason_dir .. "/lombok.jar"
if vim.fn.filereadable(lombok) == 1 then
  table.insert(cmd, 2, "-javaagent:" .. lombok)
end

jdtls.start_or_attach({
  cmd = cmd,
  capabilities = capabilities,
  root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git", "pom.xml", "build.gradle", "build.gradle.kts" }),
})
