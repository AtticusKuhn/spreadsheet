import GlobalState from "./globalState.imba"
import Cell from "./Cell.imba"
import {toExcel, isBetween, evalutateFormula, isPointInsideElement, decimalPart} from "./utils.imba"


tag SpreadSheetHolder < GlobalState
	scrollY = 0
	index = 0
	xindex = 0
	# autorender=1fps
	def mount
		center = 
			x: 0 # $container.clientWidth/2,
			y: 0# $container.clientHeight/2 
		$container.scroll(0,0)
		log "mount"
		const storage = window.localStorage.getItem('spreadsheet') || "\{\}";
		# if storage
		map = JSON.parse(storage)
		render!
	def handleScroll 
		dy=  $container.scrollTop - $container.clientHeight/2
		dx = $container.scrollLeft -  $container.clientWidth/2
		index  =  index + ($container.scrollTop - center.y)/cellHeight
		xindex =  xindex + ($container.scrollLeft - center.x)/cellWidth
		center =
			x: $container.clientWidth/2 + (dx % cellHeight)
			y:  $container.clientHeight/2 + (dy % cellHeight)
		$container.scroll(center.x, center.y)
	def left
		if mode === "select"
			draggedCell = 
				x:draggedCell.x - 1
				y: draggedCell.y
		else
			cell.x = Math.max 0, cell.x - 1
			xindex = Math.max 0, xindex - 1
			mode="normal"
	def right
		if mode === "select"
			draggedCell = 
				x:draggedCell.x+1
				y: draggedCell.y
		else
			cell.x = Math.max 0, cell.x + 1
			xindex = cell.x - 7
			mode="normal"
	def up
		if mode === "select"
			draggedCell = 
				x:draggedCell.x
				y: draggedCell.y - 1 
		else
		cell.y = Math.max 0, cell.y - 1
		index =  Math.max 0, index - 1
		mode="normal"
	def down 
		if mode === "select"
			draggedCell = 
				x:draggedCell.x
				y: draggedCell.y + 1
		else
			cell.y = Math.max 0, cell.y + 1
			index =  Math.max 0, index + 1
			mode="normal"
	def copy
		# let clipboard
		if mode === "select"
			const lowx = Math.min(cell.x, draggedCell.x)
			const highx = Math.max(cell.x, draggedCell.x)
			const lowy = Math.min(cell.y, draggedCell.y)
			const highy = Math.max(cell.y, draggedCell.y)
			const tmp = [ ... map[(toExcel i) + j]  for j in [lowy .. highy]  for i in [lowx ... highx]]
			clipboard = tmp
			log tmp
		else
			clipboard = map[(toExcel cell.x) + cell.y]
		window.navigator.clipboard.writeText(clipboard.join(""))
	def paste
		if typeof clipboard === "string"
			log "string {clipboard}"
			map[(toExcel cell.x) + cell.y] = clipboard
		else
			log clipboard
			for i in [0 ... clipboard.length]
				for j in [0 ... clipboard[0].length]
					log "i={i} j={j}"
					map[(toExcel (cell.x + i)) + (cell.y + j)] = clipboard[i][j]
	def shift
		mode="select"
		draggedCell = cell
	def escape
		mode ="normal"
		draggedCell = null
	def render
		<self
			@hotkey("left")=(left)
			@hotkey("right")=(right)
			@hotkey("up")=(up)
		 	@hotkey("down")=(down)
			@hotkey("c")=(copy)
			@hotkey("p")=(paste)
			@hotkey("shift")=(shift)
			@hotkey("esc")=(escape)
		>
			<h1 [ta:center fs:3rem]> "SpreadSheet"
			<h1 [ta:center fs:2rem]> "Shortcuts"
			<ol>
				<li> "c: copy"
				<li> "p: paste"
				<li> "left arrow: left"
				<li> "right arrow: right"
				<li> "up arrow: up"
				<li> "down arrow: down"
				<li> "e: edit cell"
				<li> "shift: select"
				<li> "escape: go to normal mode"
			<h1 [ta:center fs:2rem]> "Debug Information"

			<pre>
				"xindex = " ,  xindex, " yindex = ", index
				"mode = {mode}"
				"cell = {JSON.stringify(cell)}"
				"draggedCell = {JSON.stringify(draggedCell)}"
				"clipboard = {JSON.stringify(clipboard)}"
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log.prevent=(handleScroll)>
				<div [h:{decimalPart(index)}px]>
				for y in [0 ... 10]
					<div.row[white-space: nowrap d:flex fld:row]>
						for x in [0 ... 20] 
							<Cell x=Math.floor(x + xindex) y=Math.floor(y + index)>  # if (x + xindex >=0) && (y + index) >=0
export default SpreadSheetHolder