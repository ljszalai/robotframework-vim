" gotofile.vim: gf replacement by using the tags file
" Original Author: Nathan Huizinga (nathan dot huizinga at gmail dot com)
" Last Change: 12-Jan-2017
" Created:     15-Apr-2016
" Requires:    Vim-7.0, genutils.vim(1.2)
" Version:     0.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
" Download From:
"     http://www.vim.org//script.php?script_id=xxxx
" Usage:
"     This script defines a new command 'GotoRobotFile', which resembles the
"     normal 'gf' function, but uses builtin variable ${CURDIR} of RoboFramework
"     to expand file name under cursor. In other cases, when the fileName under
"     cursor does not contain ${CURDIR} as a string, it will work as normal gf.
"     For further information about ${CURDIR}, see
"       http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#id510
"     Additionally when you have a common folder where more Robot files exist
"     you might want to define an environment variable called commPath_Ev and this
"     and this plugin will handles this case too.
"
"     Original script was written by
"       Nathan Huizinga (nathan dot huizinga at gmail dot com)
"       http://www.vim.org/scripts/script.php?script_id=1812
"
"	  Add the following mapping to your .vimrc (or _vimrc) to replace the
"	  normal 'gf' behavior by the GotoFile command:
"
"	  nmap <silent> gf :GotoRobotFile<CR>
"
"     NOTE: let me (ljszalai) recommend you to use 'grf' instead of normal 'gf' 
"     where 'grf' stands for 'Goto Robot File' and accordingly use
"	  nmap <silent> grf :GotoRobotFile<CR>
"     instead of what's been written above.
"
"     I wrote this script to find out the way of altering the behaviour of gf
"     command. This makes me easyer to implement other project specific
"     alternative behaviours like using environment variabes to access files
"     (%{env_var_name} in RobotFramework).
"
" Installing:
"     Just place this script in your plugin directory.
"     Generate the tags file.
"     Make sure that your tags file can be found by vim. See :help 'tags'
"     Install the latest version of genutils
"     (http://www.vim.org/scripts/script.php?script_id=197).
"

if exists("loaded_gotorobotfile")
    finish
endif
if v:version < 700
  echomsg 'gotofile: You need at least Vim 7.0'
  finish
endif
if !exists('loaded_genutils')
  runtime plugin/genutils.vim
endif
if !exists('loaded_genutils') || loaded_genutils < 200
  echomsg 'gotofile: You need a newer version of genutils.vim plugin'
  finish
endif
let loaded_gotorobotfile = 1

command! -nargs=0 -complete=file GotoRobotFile :call <SID>FindRobotFile(expand("<cfile>"))

function! s:FindRobotFile(pattern)
	if a:pattern == ""
        echohl ErrorMsg | echo "No filename!" | echohl NONE
		return
	endif
    let l:commpath = substitute($commPath_Ev, "\\", "/", "g")
    let l:currdir = substitute(fnamemodify('.', ':p'), "\\", "/", "g")


    let l:pattern = substitute(a:pattern, "${CURDIR}", l:currdir, "")
    let l:pattern = substitute(l:pattern, "%{commPath_Ev}", l:commpath, "")

	let fileName = l:pattern

	" [START] code snippet taken from: lookupfile.vim
	"     http://www.vim.org//script.php?script_id=1581
	let winnr = bufwinnr(genutils#FindBufferForName(fileName))
	if winnr != -1
		exec winnr.'wincmd w'
	else
		let splitOpen = 0
		if &switchbuf ==# 'split'
			let splitOpen = 1
		endif
		" First try opening as a buffer, if it fails, we will open as a file.
		try
			exec (splitOpen?'s':'').'buffer' fileName
		catch
			exec (splitOpen?'split':'edit') fileName
		endtry
	endif
	" [END] code snippet
endfunction

" vim6:sw=4
