
require("codecompanion").setup({
  adapters = {
    acp = {
      claude_code = function()
        return require("codecompanion.adapters").extend("claude_code", {
          env = {
            CLAUDE_CODE_OAUTH_TOKEN = "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",
          },
        })
      end,
    },
  },
})
