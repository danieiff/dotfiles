vim.uv.os_setenv('JAVA_HOME', [[\pleiades-v4.5\java\8]])
vim.uv.os_setenv('CATALINA_HOME', [[\tomcat\apache-tomcat-8.5.28]])
vim.uv.os_setenv('TOMCAT_HOME', [[\tomcat\apache-tomcat-8.5.28]])

local java_root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" })
local config = {                             -- https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    [[\Program Files\Java\jdk-17\bin\java]], -- winget install --id=Oracle.JDK.17 -e
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', [[\jdtls\plugins\org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar]],

    '-configuration', [[\jdtls\config_win]],
    '-data', NVIM_DATA .. '/jdtls-data/java_root_dir' -- MUST NOT be in workspace itself
  },
  root_dir = java_root_dir,

  -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      project = {
        referencedLibraries = {
        },
      },
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = [[\pleiades-v4.5\java\8\jre]],
            default = true
          }
        }
      }
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files if you want to use additional eclipse.jdt.ls plugins.
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },
}

AUC('FileType', { pattern = 'java', callback = function() require 'jdtls'.start_or_attach(config) end })
