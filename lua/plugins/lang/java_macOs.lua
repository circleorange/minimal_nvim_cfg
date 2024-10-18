return {
  "neovim/nvim-lspconfig",
  dependencies = { "mfussenegger/nvim-jdtls" },
  opts = {
    setup = {
      jdtls = function(_, opts)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "java",
          callback = function()
            local util = require("lazyvim.util")
            util.on_attach(function(_, buffer)
              -- Key mappings
              vim.keymap.set("n", "<leader>di", "<Cmd>lua require('jdtls').organize_imports()<CR>", { buffer = buffer, desc = "Organize Imports" })
              vim.keymap.set("n", "<leader>dt", "<Cmd>lua require('jdtls').test_class()<CR>", { buffer = buffer, desc = "Test Class" })
              vim.keymap.set("n", "<leader>dn", "<Cmd>lua require('jdtls').test_nearest_method()<CR>", { buffer = buffer, desc = "Test Nearest Method" })
              vim.keymap.set("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { buffer = buffer, desc = "Extract Variable" })
              vim.keymap.set("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", { buffer = buffer, desc = "Extract Variable" })
              vim.keymap.set("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { buffer = buffer, desc = "Extract Method" })
              vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = buffer, desc = "Format Code" })
            end)

            -- Determine project name and workspace directory
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = "/Users/piotr.bielski/.workspace/" .. project_name

            -- Configure JDTLS
            local config = {
              cmd = {
                -- Path to the Java binary
                "/Users/piotr.bielski/.sdkman/candidates/java/current/bin/java",
                "-javaagent:/Users/piotr.bielski/.m2/repository/org/projectlombok/lombok/1.18.32/lombok-1.18.32.jar",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",

                -- Path to the JDTLS launcher JAR
                "-jar",
                "/opt/homebrew/Cellar/jdtls/1.40.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
                "-configuration", "/opt/homebrew/Cellar/jdtls/1.40.0/libexec/config_mac",
                "-data", workspace_dir,
              },
              root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),
              settings = {
                java = {
                  -- Any additional JDTLS settings can be added here 
                  format = { enabled = false },
              }},
              init_options = { bundles = {} },
              handlers = {
                ["language/status"] = function() end,
                ["$/progress"] = function() end,
              },
            }
            require("jdtls").start_or_attach(config)
          end,
        })
        return true
      end,
    },
  },
}

