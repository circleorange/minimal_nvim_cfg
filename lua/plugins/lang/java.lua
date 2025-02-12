return {
  "neovim/nvim-lspconfig",
  dependencies = { "mfussenegger/nvim-jdtls" },
  opts = {
    setup = {
      jdtls = function(_, _)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "java",
          callback = function()
            require("lazyvim.util").on_attach(function(_, buffer)
            
              -- Keymaps for JDTLS
              vim.keymap.set("n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { buffer = buffer, desc = "Organize Imports" })
              vim.keymap.set("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", { buffer = buffer, desc = "Test Class" })
              vim.keymap.set("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", { buffer = buffer, desc = "Test Nearest Method" })
              vim.keymap.set("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { buffer = buffer, desc = "Extract Variable" })
              vim.keymap.set("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", { buffer = buffer, desc = "Extract Variable" })
              vim.keymap.set("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { buffer = buffer, desc = "Extract Method" })
              vim.keymap.set("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = buffer, desc = "Format" })
            end)

            -- Detect OS
            local is_mac = (vim.fn.has("macunix") == 1)
            local is_linux = (vim.fn.has("unix") == 1) and not is_mac

            -- Determine HOME directory
            local home = os.getenv("HOME")

            -- Derive project name from the current working directory
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

            -- Build workspace directory (cross-platform)
            local workspace_dir = home .. "/.workspace/" .. project_name

            -- Default paths (you could also set them to nil and check later)
            local java_bin = "java"
            local lombok_jar = home .. "/.local/share/java/lombok.jar" -- example default
            local jdtls_launcher = "/usr/share/java/jdtls/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
            local jdtls_config = "/usr/share/java/jdtls/org.eclipse.jdt.ls.product/target/repository/config_linux/"

            if is_mac then
              java_bin = home .. "/.sdkman/candidates/java/current/bin/java"
              lombok_jar = home .. "/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar"
              jdtls_launcher = "/opt/homebrew/Cellar/jdtls/1.40.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
              jdtls_config   = "/opt/homebrew/Cellar/jdtls/1.40.0/libexec/config_mac"
            elseif is_linux then
              java_bin = "/usr/lib/jvm/java-21-openjdk-amd64/bin/java"
              lombok_jar = home .. "/.local/share/java/lombok.jar"
              jdtls_launcher = "/usr/share/java/jdtls/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
              jdtls_config   = "/usr/share/java/jdtls/org.eclipse.jdt.ls.product/target/repository/config_linux/"
            end

            -- Build the cmd array
            local cmd = {
              java_bin,
              "-javaagent:" .. lombok_jar,
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-Xms1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens", "java.base/java.util=ALL-UNNAMED",
              "--add-opens", "java.base/java.lang=ALL-UNNAMED",
              "--add-opens", "java.base/java.lang.invoke=ALL-UNNAMED",
              "--add-opens", "java.base/sun.reflect.annotation=ALL-UNNAMED",
              "-jar", jdtls_launcher,
              "-configuration", jdtls_config,
              "-data", workspace_dir,
            }

            local config = {
              cmd = cmd,
              -- root_dir = vim.fs.find({ ".git", "mvnw", "gradlew" }, { upward = true })[1] or vim.fn.getcwd(),
              root_dir = require("jdtls.setup").find_root(
                { ".git", "mvnw", "gradlew", "Main.java" }
              ) or vim.fn.getcwd(),

              -- JDTLS specific settings
              settings = {
                java = {
                  format = { enabled = false },
                  signatureHelp = { enabled = true },
                  contentProvider = { preferred = 'fernflower' },
                  completion = {
                    favoriteStaticMembers = {
                      "org.junit.Assert.*",
                      "org.junit.Assume.*",
                      "org.junit.jupiter.api.Assertions.*",
                      "org.junit.jupiter.api.Assumptions.*",
                      "org.junit.jupiter.api.DynamicContainer.*",
                      "org.junit.jupiter.api.DynamicTest.*"
                    }
                  },
                  sources = {
                    organizeImports = {
                      starThreshold = 9999,
                      staticStarThreshold = 9999
                    }
                  }
                },
              },
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
