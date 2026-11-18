-- Java support via nvim-jdtls (Eclipse JDT Language Server).
--
-- Tuned for the dash0 monorepo: every Java project there (components/accountant,
-- components/resource-extractor, modules/*/java, ...) is its own Gradle build with
-- its own gradlew, so each one gets its own root and jdtls workspace.
--
-- jdtls, java-debug-adapter and java-test are installed via Mason (see lsp/mason.lua).
-- mason-lspconfig must NOT auto-enable `jdtls`, otherwise two clients attach.

local function mason_path(...)
  return vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', ...)
end

-- JDKs installed by mise. The symlinked major versions (e.g. corretto-25) follow patch upgrades.
local function mise_jdk(name)
  local path = vim.fs.joinpath(vim.env.HOME, '.local', 'share', 'mise', 'installs', 'java', name)
  return vim.uv.fs_stat(path) and path or nil
end

local function java_runtimes()
  local runtimes = {}
  for _, rt in ipairs {
    { name = 'JavaSE-21', jdk = 'corretto-21' },
    { name = 'JavaSE-25', jdk = 'corretto-25', default = true },
  } do
    local path = mise_jdk(rt.jdk)
    if path then
      table.insert(runtimes, { name = rt.name, path = path, default = rt.default })
    end
  end
  return runtimes
end

local function bundles()
  local result = {}
  local debug_jar = vim.fn.glob(mason_path('packages', 'java-debug-adapter', 'extension', 'server', 'com.microsoft.java.debug.plugin-*.jar'), true)
  if debug_jar ~= '' then
    table.insert(result, debug_jar)
  end
  for _, jar in ipairs(vim.fn.glob(mason_path('packages', 'java-test', 'extension', 'server', '*.jar'), true, true)) do
    -- These jars are not OSGi bundles and make jdtls log errors.
    local name = vim.fs.basename(jar)
    if name ~= 'com.microsoft.java.test.runner-jar-with-dependencies.jar' and name ~= 'jacocoagent.jar' then
      table.insert(result, jar)
    end
  end
  return result
end

local function set_keymaps(bufnr)
  local jdtls = require 'jdtls'
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map('n', '<leader>Jo', jdtls.organize_imports, 'Java: organize imports')
  map('n', '<leader>Jv', jdtls.extract_variable, 'Java: extract variable')
  map('v', '<leader>Jv', function()
    jdtls.extract_variable(true)
  end, 'Java: extract variable')
  map('n', '<leader>Jc', jdtls.extract_constant, 'Java: extract constant')
  map('v', '<leader>Jc', function()
    jdtls.extract_constant(true)
  end, 'Java: extract constant')
  map('v', '<leader>Jm', function()
    jdtls.extract_method(true)
  end, 'Java: extract method')
  map('n', '<leader>Jt', jdtls.test_nearest_method, 'Java: debug nearest test')
  map('n', '<leader>JT', jdtls.test_class, 'Java: debug test class')
  map('n', '<leader>Jp', jdtls.pick_test, 'Java: pick test to debug')
  map('n', '<leader>Js', jdtls.super_implementation, 'Java: go to super implementation')
  map('n', '<leader>Ju', '<Cmd>JdtUpdateConfig<CR>', 'Java: reload Gradle/Maven project')
  map('n', '<leader>Jw', '<Cmd>JdtWipeDataAndRestart<CR>', 'Java: wipe workspace and restart')
end

-- Quarkus dev mode (`./gradlew quarkusDev`) listens for a debugger on 5005.
local function add_dap_configurations()
  local dap = require 'dap'
  dap.configurations.java = dap.configurations.java or {}
  for _, cfg in ipairs(dap.configurations.java) do
    if cfg.name == 'Attach to Quarkus dev (localhost:5005)' then
      return
    end
  end
  table.insert(dap.configurations.java, {
    type = 'java',
    request = 'attach',
    name = 'Attach to Quarkus dev (localhost:5005)',
    hostName = '127.0.0.1',
    port = 5005,
  })
end

local function start_jdtls()
  local jdtls = require 'jdtls'

  local root_dir = vim.fs.root(0, { { 'gradlew', 'mvnw' }, { 'settings.gradle.kts', 'settings.gradle', 'pom.xml' }, { '.git' } })
  if not root_dir then
    return
  end

  -- One workspace per project root (name + short hash, to keep worktrees apart).
  local workspace_dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls', 'workspace', vim.fs.basename(root_dir) .. '-' .. vim.fn.sha256(root_dir):sub(1, 8))

  local runtimes = java_runtimes()
  local gradle_java_home = mise_jdk 'corretto-25'

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local config = {
    name = 'jdtls',
    cmd = {
      mason_path('bin', 'jdtls'),
      '--jvm-arg=-javaagent:' .. mason_path('share', 'jdtls', 'lombok.jar'),
      '--jvm-arg=-Xmx4g',
      '-data',
      workspace_dir,
    },
    root_dir = root_dir,
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    init_options = {
      bundles = bundles(),
      extendedClientCapabilities = extendedClientCapabilities,
    },
    settings = {
      java = {
        configuration = {
          runtimes = runtimes,
          updateBuildConfiguration = 'interactive',
        },
        import = {
          gradle = {
            enabled = true,
            wrapper = { enabled = true },
            -- Run Gradle on Corretto 25 so the build's Amazon toolchain resolves without downloads.
            java = { home = gradle_java_home },
          },
          maven = { enabled = true },
        },
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        references = { includeDecompiledSources = true },
        referencesCodeLens = { enabled = true },
        implementationsCodeLens = { enabled = true },
        signatureHelp = { enabled = true },
        inlayHints = { parameterNames = { enabled = 'literals' } },
        contentProvider = { preferred = 'fernflower' },
        -- dash0 style comes from IntelliJ (.editorconfig) + Spotless (imports, license header).
        -- The Eclipse formatter would reflow whole files, so it is off; use `./gradlew spotlessApply`.
        format = { enabled = false },
        completion = {
          -- Matches Spotless importOrder("\\#", "java|javax", "com.dash0", "org", "").
          importOrder = { '#', 'java', 'javax', 'com.dash0', 'org', '' },
          favoriteStaticMembers = {
            'org.assertj.core.api.Assertions.*',
            'org.junit.jupiter.api.Assertions.*',
            'org.junit.jupiter.api.Assumptions.*',
            'org.mockito.Mockito.*',
            'org.mockito.ArgumentMatchers.*',
            'io.restassured.RestAssured.*',
            'org.hamcrest.Matchers.*',
          },
          filteredTypes = { 'com.sun.*', 'io.micrometer.shaded.*', 'java.awt.*', 'jdk.*', 'sun.*' },
        },
        sources = {
          organizeImports = { starThreshold = 999, staticStarThreshold = 999 },
        },
        codeGeneration = {
          toString = { template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}' },
          useBlocks = true,
        },
      },
    },
    on_attach = function(_, bufnr)
      set_keymaps(bufnr)
      jdtls.setup_dap { hotcodereplace = 'auto' }
      add_dap_configurations()
    end,
  }

  jdtls.start_or_attach(config)
end

return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  dependencies = {
    'mfussenegger/nvim-dap',
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('UserJdtls', { clear = true }),
      pattern = 'java',
      callback = start_jdtls,
    })
    -- The plugin loads on the first java FileType event, after it has already fired.
    if vim.bo.filetype == 'java' then
      start_jdtls()
    end
  end,
}
