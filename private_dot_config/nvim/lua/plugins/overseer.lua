return {
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>tt", "<cmd>OverseerRun<cr>" },
    },
    event = "VeryLazy",
    config = function()
      local overseer = require("overseer")
      overseer.setup({
        strategy = {
          "toggleterm",
          direction = "vertical",
          close_on_exit = false,
          use_shell = true,
          on_create = function(t)
            local function override_exit(self, cmd)
              local Terminal = require('toggleterm.terminal').Terminal
              if (cmd == "exit $?") then
                Terminal.send(self, "exit $status")
              else
                Terminal.send(self, cmd)
              end
            end
            t.send = override_exit
          end
        },
      })
      overseer.register_template({
        name = "Terraform Plan",
        builder = function()
          local parent = vim.fn.expand("%:p:h")
          return {
            cmd = { "terraform" },
            args = { "plan" },
            cwd = parent,
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "terraform", "tfvars" },
        },
      })
      overseer.register_template({
        name = "Terraform Apply",
        builder = function()
          local parent = vim.fn.expand("%:p:h")
          return {
            cmd = { "terraform" },
            args = { "apply", "-auto-approve" },
            cwd = parent,
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "terraform", "tfvars" },
        },
      })

      overseer.register_template({
        name = "Run Test",
        builder = function()
          local file = vim.fn.expand("%:p")
          local cmd = { "go", "test", "-v", file }
          return {
            cmd = cmd,
            components = {
              { "on_output_quickfix", set_diagnostics = true },
              "on_result_diagnostics",
              "default",
            },
          }
        end,
        filetype = { "go" },
      })

      overseer.register_template({
        name = "Make",
        builder = function()
          local file = vim.fn.expand("%:p:h")
          local cmd = { "make", "-C", file }
          return {
            cmd = cmd,
            components = {
              { "on_output_quickfix", set_diagnostics = true },
              "on_result_diagnostics",
              "default",
            },
          }
        end,
        filetype = { "tex" },
      })
    end
  },
}
