
const log = console.log
const cellHeight= 100
const cellWidth= 100
let mode = "normal"
let clipboard\string|string[][] = ""
let draggedCell = null
let cell =
	x: 0
	y: 0 
log "cell", cell

let map = {}

def toExcel n
	let ordA = 'A'.charCodeAt(0);
	let ordZ = 'Z'.charCodeAt(0);
	let len = ordZ - ordA + 1;

	let s = "";
	while n >= 0 
		s = String.fromCharCode(n % len + ordA) + s;
		n = Math.floor(n / len) - 1;
	return s;

def evalutateFormula formula, context
	if formula.startsWith "="
		try
			let regex = /[A-Z]+[0-9]+/
			let replaced = formula.substring(1).replace(regex, do(e) JSON.stringify(evalutateFormula context[e], context))
			# log replaced
			return window.eval "({replaced})"
		catch e
			return "#ERROR"
	return formula

def isPointInsideElement event, element
	const rect = element.getBoundingClientRect();
	const x = event.clientX;
	return false if (x < rect.left || x >= rect.right) 
	const y = event.clientY;
	return false if (y < rect.top || y >= rect.bottom) 
	return true;
const  isBetween =  do(x, low, high) x >= low && x <= high
tag Cell 
	prop x 
	prop y
	def handlechange
		map[(toExcel x) + y] = $input.value if !($input.value == "" && !map[(toExcel x) + y])
		window.localStorage.setItem("spreadsheet", JSON.stringify(map))
	autorender=1fps
	def edit 
		if (x === cell.x) && (y === cell.y)
			mode="edit"
			$input.focus()
	def esc
		$input.blur()
		mode="normal"
	def handleTouch evt
		cell = 
			x: x
			y: y
		const isInside = isPointInsideElement(evt, $input)
		log "isinside {isInside}"
		if isInside
			mode="edit"
		else 
			mode="normal"
		draggedCell = null
	def dragover
		draggedCell = 
			x:x
			y:y
	def dragend
		mode = "normal"
		const lowx = Math.min(cell.x, draggedCell.x)
		const highx = Math.max(cell.x, draggedCell.x)
		const lowy = Math.min(cell.y, draggedCell.y)
		const highy = Math.max(cell.y, draggedCell.y)
		for i in [lowx ... highx]
			for j in [lowy .. highy]
				map[(toExcel i) + j] = map[(toExcel x) + y] if (toExcel x) + y !== ""
		draggedCell = null
		window.localStorage.setItem("spreadsheet", JSON.stringify(map))
	def dragstart
		mode = "select"
		cell = 
			x:x
			y:y
	def render
		const name = (toExcel x) + y
		const isInDragSelection = draggedCell !== null && isBetween(x, Math.min(cell.x, draggedCell.x), Math.max(cell.x, draggedCell.x))  && isBetween(y, Math.min(cell.y, draggedCell.y), Math.max(cell.y, draggedCell.y))
		const color = (x === cell.x) && (y === cell.y) ? "red" : (isInDragSelection ? "blue" :  "black")
		<self[display:inline-block w:{cellWidth}px h:{cellHeight}px border:3px solid {color} d:flex fld:column]
		@hotkey("e").passive.prevent=(edit)
		@hotkey("x").passive.prevent.stop=(esc)
		# @touch.outside
		@click=(handleTouch)
			# @drag.log("drag")
			@dragend=(dragend)
			# @dragenter.log("dragenter")
			# @dragleave.log("dragleave")
			@dragover=(dragover)
			@dragstart=(dragstart)
			# @drop=(drop")
		draggable
		>
			<div> name
			<div>
				<input$input .mousetrap [w:{cellWidth}px display:inline-block] type='text' readonly=(mode==="normal") @change=(handlechange) value=(map[name] || "")>
			<div> evalutateFormula((map[name] || ""), map)


def decimalPart n
	n - Math.floor(n)
tag SpreadSheetHolder
	scrollY = 0
	index = 0
	xindex = 0
	autorender=1fps
	def mount
		center = 
			x: 0 # $container.clientWidth/2,
			y: 0# $container.clientHeight/2 
		$container.scroll(0,0)
		log "mount"
		const storage = window.localStorage.getItem('spreadsheet') || "\{\}";
		# if storage
		map = JSON.parse(storage)
		render
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
		window.navigator.clipboard.writeText(clipboard)
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

			# JSON.stringify(map)
			<pre>
				"xindex = " ,  xindex, " yindex = ", index
				"mode = {mode}"
				"cell = {JSON.stringify(cell)}"
				"clipboard = {JSON.stringify(clipboard)}"
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log.prevent=(handleScroll)>
				<div [h:{decimalPart(index)}px]>
				for y in [0 ... 10]
					<div.row[white-space: nowrap d:flex fld:row]>
						for x in [0 ... 20] 
							<Cell x=Math.floor(x + xindex) y=Math.floor(y + index)>  # if (x + xindex >=0) && (y + index) >=0
export default SpreadSheetHolder