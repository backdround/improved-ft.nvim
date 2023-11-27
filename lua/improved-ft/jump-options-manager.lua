local user_options_utils = require("improved-ft.user-options-utils")
local utils = require("improved-ft.utils")

---@return IFT_JumpOptionsManager
local new = function()
  ---@class IFT_JumpOptionsManager
  local manager = {
    _dot_repetition_cache = {},
    _user_repetition_cache = {},
  }

  ---@param user_options IFT_UserJumpOptions
  ---@return IFT_JumpOptions
  manager.get_from_user_options = function(user_options)
    user_options = vim.deepcopy(user_options or {})

    user_options_utils.assert(user_options)
    user_options_utils.fill_default(user_options)

    local jump_options = {
      direction = user_options.direction,
      offset = user_options.offset,
    }

    -- Get pattern
    if utils.is_vim_repeat() then
      jump_options.pattern = manager._dot_repetition_cache.pattern
    elseif user_options.pattern ~= nil then
      jump_options.pattern = user_options.pattern
    else
      jump_options.pattern = utils.get_user_inputed_pattern()
    end

    -- Get count
    if vim.v.count ~= 0 then
      jump_options.count = vim.v.count
    elseif utils.is_vim_repeat() then
      jump_options.count = manager._dot_repetition_cache.count
    else
      jump_options.count = 1
    end

    -- Save caches
    manager._dot_repetition_cache = jump_options
    if user_options.save_for_repetition then
      manager._user_repetition_cache = jump_options
    end

    return jump_options
  end

  ---@param direction "forward"|"backward"
  ---@return IFT_JumpOptions|nil
  manager.get_repeating_options = function(direction)
    if manager._user_repetition_cache.pattern == nil then
      return
    end

    return manager.get_from_user_options({
      direction = direction,
      pattern = manager._user_repetition_cache.pattern,
      offset = manager._user_repetition_cache.offset,
    })
  end

  return manager
end

return {
  new = new
}
