-- Path: ~/.config/nvim/lua/custom/configs/python_utils.lua

local M = {}

-- Function to find the Python executable in a virtual environment
function M.find_venv_python()
  local cwd = vim.fn.getcwd()
  
  -- Common virtual environment directory patterns
  local venv_patterns = {
    "/.venv",          -- Standard venv location
    "/venv",           -- Alternative venv location
  }

  -- Check for Poetry virtual environment
  local poetry_config = io.open(cwd .. "/pyproject.toml", "r")
  if poetry_config then
    poetry_config:close()
    -- Try to find Poetry's virtualenv location
    local poetry_venv_cmd = "poetry env info -p 2>/dev/null"
    local poetry_venv = vim.fn.system(poetry_venv_cmd):gsub("%s+$", "")

    if poetry_venv ~= "" and vim.fn.isdirectory(poetry_venv) == 1 then
      local python_path = poetry_venv .. "/bin/python"
      if vim.fn.executable(python_path) == 1 then
        return python_path
      end
    end
  end

  -- Check for common virtual environment locations
  for _, pattern in ipairs(venv_patterns) do
    local venv_dir = cwd .. pattern
    if vim.fn.isdirectory(venv_dir) == 1 then
      local python_path
      if vim.fn.has("win32") == 1 then
        python_path = venv_dir .. "/Scripts/python.exe"
      else
        python_path = venv_dir .. "/bin/python"
      end

      if vim.fn.executable(python_path) == 1 then
        return python_path
      end
    end
  end

  -- Check for virtualenvwrapper environments
  local venv_wrapper = os.getenv("WORKON_HOME")
  if venv_wrapper then
    local project_name = vim.fn.fnamemodify(cwd, ":t")
    local wrapper_path = venv_wrapper .. "/" .. project_name

    if vim.fn.isdirectory(wrapper_path) == 1 then
      local python_path = wrapper_path .. "/bin/python"
      if vim.fn.executable(python_path) == 1 then
        return python_path
      end
    end
  end

  -- Return the system Python as fallback
  return nil
end

return M
