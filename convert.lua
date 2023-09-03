local scriptDir   = vim.fn.fnamemodify( '%', ':h' )
local vsnipDir    = table.concat( { scriptDir, 'vsnip'    }, '/' )
local snipMateDir = table.concat( { scriptDir, 'snippets' }, '/' )

local function upperFirstChar( str )
  if str == '' then
    do return '' end
  end
  return string.upper( string.sub( str,  1, 1 ) ) .. string.sub( str,  2 )
end

local function getTemplateName( dir, snippetName )
  return 'snipMate' .. upperFirstChar( dir ) .. upperFirstChar( snippetName ) .. 'ToOther'
end

local function renameVsnipSnippet( fromName, toName )

  local from  = table.concat( { vsnipDir, fromName  }, '/' )
  local to    = table.concat( { vsnipDir, toName    }, '/' )

  vim.schedule( function() vim.fn.rename( from, to ) end )

end

local function convertionPostProcess( fileName )

  local tmpFileName = fileName .. '.tmp'
  local file        = io.open( tmpFileName, 'w' )

  if file then

    for line in io.lines( fileName ) do
      file:write( string.gsub( line, '\\\\}', '}' ) .. "\n" )
    end

    file:close();
    renameVsnipSnippet(
      string.gsub( tmpFileName, vsnipDir .. '/', '' ),
      string.gsub( fileName,    vsnipDir .. '/', '' )
    )

  end

end

local function loopSnipMateDir( callback )
  for dir, type in vim.fs.dir( snipMateDir ) do
    if type == 'directory' then
      callback( dir )
    end
  end
end

local function loopSnipMateSubdirFiles( dir, callback )
  for file, type in vim.fs.dir( table.concat( { snipMateDir, dir }, '/' ) )  do
    if type == 'file' then
      callback( file, string.gsub( file, '.snippets', '' ) )
    end
  end
end

vim.opt.runtimepath:append{ table.concat( { scriptDir, 'snippet-converter.nvim' }, '/' ) }
vim.opt.runtimepath:append{ scriptDir }

local templates =
{
  {
    name    = getTemplateName( '', '' ),
    sources = { snipmate = { './snippets' } },
    output  = { vsnip = { vsnipDir, opts = { generate_package_json = false } } }
  },
}
loopSnipMateDir( function( dir )
  loopSnipMateSubdirFiles( dir, function( file, name )

    local template =
    {
      name    = getTemplateName( dir, name ),
      sources = { snipmate = { table.concat( { snipMateDir, dir, file }, '/' ) } },
      output  =
      {
        vsnip =
        {
          table.concat( { vsnipDir, name }, '/' ),
          opts = { generate_package_json = false }
        }
      }
    }
    table.insert( templates, template )

  end )
end )

require'snippet_converter'.setup
{
  templates     = templates,
  default_opts  = { headless = true }
}
vim.cmd( 'ConvertSnippets ' .. getTemplateName( '', '' ) )
renameVsnipSnippet( 'all.json', 'global.json' )

loopSnipMateDir( function( dir )

  local templates = {}
  local datas     = {}

  loopSnipMateSubdirFiles( dir, function( file, name )
    table.insert( templates,  getTemplateName( dir, name )  )
    table.insert( datas,      name                          )
  end )

  vim.cmd( 'ConvertSnippets ' .. table.concat( templates, ' ' ) )

  for _, name in ipairs( datas )  do
    renameVsnipSnippet( table.concat( { name, name  .. '.json' }, '/' ),
                        table.concat( { name, dir   .. '.json' }, '/' ) )
  end

end )

for item, type in vim.fs.dir( vsnipDir ) do

  if type == 'directory' then
    for file, type in vim.fs.dir( table.concat( { vsnipDir, item }, '/' ) )  do
      if type == 'file' then
        convertionPostProcess( table.concat( { vsnipDir, item, file }, '/' )  )
      end
    end
  elseif type == 'file' then
    convertionPostProcess( table.concat( { vsnipDir, item }, '/' )  )
  end

end
