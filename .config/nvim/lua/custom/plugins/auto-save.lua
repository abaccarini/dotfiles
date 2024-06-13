return {

  'Pocco81/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      trigger_events = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger auto-save. See :h events
      execution_message = {
        message = '',
        --   function() -- message to print on save
        --   return ('AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S')
        -- end,
        dim = 0, -- dim the color of `message`
        cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
      },
      debounce_delay = 10000, -- saves the file at most every `debounce_delay` milliseconds

      condition = function(buf)
        local fn = vim.fn
        local utils = require 'auto-save.utils.data'

        if
          fn.getbufvar(buf, '&modifiable') == 1
          and utils.not_in(fn.getbufvar(buf, '&filetype'), {
            "tex"

          })
          and utils.not_in(fn.expand '%:t', {
          })
        then
          return true -- met condition(s), can save
        end
        return false -- can't save
      end,
    }
  end,
}
