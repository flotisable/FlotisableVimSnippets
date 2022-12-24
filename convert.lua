local scriptDir = vim.fn.fnamemodify( '%', ':h' )
local vsnipDir  = scriptDir .. '/vsnip'

vim.opt.runtimepath:append{ scriptDir .. '/snippet-converter.nvim' }
vim.opt.runtimepath:append{ scriptDir }

local converter = require 'snippet_converter'

converter.setup
{
  templates =
  {
    {
      name    = 'snipMateToOther',
      sources = { snipmate = { './snippets' } },
      output  = { vsnip = { vsnipDir, opts = { generate_package_json = false } } }
    },
    {
      name    = 'snipMateCppStdlibToOther',
      sources = { snipmate = { './snippets/cpp/stdlib.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/stdlib',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMateCppStructureToOther',
      sources = { snipmate = { './snippets/cpp/structure.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/structure',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMateCppSyntaxToOther',
      sources = { snipmate = { './snippets/cpp/syntax.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/syntax',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMateCppTemplateToOther',
      sources = { snipmate = { './snippets/cpp/template.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/template',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMatePerlStructureToOther',
      sources = { snipmate = { './snippets/perl/structure.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/structure',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMatePerlSyntaxToOther',
      sources = { snipmate = { './snippets/perl/syntax.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/syntax',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMatePerlTemplateToOther',
      sources = { snipmate = { './snippets/perl/template.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/template',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMateTclStructureToOther',
      sources = { snipmate = { './snippets/tcl/structure.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/structure',
          opts = { generate_package_json = false }
        }
      }
    },
    {
      name    = 'snipMateTclSyntaxToOther',
      sources = { snipmate = { './snippets/tcl/syntax.snippets' } },
      output  =
      {
        vsnip =
        {
          vsnipDir .. '/syntax',
          opts = { generate_package_json = false }
        }
      }
    },
  },
  default_opts = { headless = true }
}
vim.cmd( 'ConvertSnippets snipMateToOther' )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/all.json', vsnipDir .. '/global.json' ) end )

vim.cmd( 'ConvertSnippets snipMateCppStdlibToOther snipMateCppStructureToOther snipMateCppSyntaxToOther snipMateCppTemplateToOther' )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/stdlib/stdlib.json',        vsnipDir .. '/stdlib/cpp.json' ) end )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/structure/structure.json',  vsnipDir .. '/structure/cpp.json' ) end )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/syntax/syntax.json',        vsnipDir .. '/syntax/cpp.json' ) end )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/template/template.json',    vsnipDir .. '/template/cpp.json' ) end )

vim.cmd( 'ConvertSnippets snipMatePerlStructureToOther snipMatePerlSyntaxToOther snipMatePerlTemplateToOther' )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/structure/structure.json',  vsnipDir .. '/structure/perl.json' ) end )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/syntax/syntax.json',        vsnipDir .. '/syntax/perl.json' ) end )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/template/template.json',    vsnipDir .. '/template/perl.json' ) end )

vim.cmd( 'ConvertSnippets snipMateTclStructureToOther snipMateTclSyntaxToOther' )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/structure/structure.json',  vsnipDir .. '/structure/tcl.json' ) end )
vim.schedule( function() vim.fn.rename( vsnipDir .. '/syntax/syntax.json',        vsnipDir .. '/syntax/tcl.json' ) end )
