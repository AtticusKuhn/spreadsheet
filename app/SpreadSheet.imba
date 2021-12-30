
# class State
# 	static instance = null
# 	constructor
# 		self.cells = {}
# 	def setCell cell, value
# 		self.cells[cell] = value if value != ""
const log = console.log
# let state = new State!
const cellHeight= 100
const cellWidth= 100
let mode = "normal"
let draggedCell = null
let cell =
	x: 0
	y: 0 
log "cell", cell
# import string
# def divmod_excel n
# 	# a, b = divmod(n, 26)
# 	let a  = n // 26
# 	let b  = n % 26
# 	if b == 0
# 		return a - 1, b + 26
# 	return a, b
# def to_excel num
# 	let chars = ["e"]
# 	while num > 0
# 		let tmp = divmod_excel(num)
# 		console.log "tmp is {tmp}"
# 		num = tmp[0]
# 		chars.push(String.fromCharCode([tmp[1] - 1]))
# 	return chars.reverse().join("")
# window.to_excel = to_excel
let map = {}
# def convertBases num, radix=10
# 	let keys = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
# 	#   if (!(radix >= 2 && radix <= keys.length)) throw new RangeError("toBase() radix argument must be between 2 and " + keys.length)
# 	let isNegative=false
# 	if (num < 0) 
# 		isNegative = true
# 	# if (isNaN(num = Math.abs(+num))) return NaN

# 	let output = [];
# 	while num !=0
# 		let index = num % radix;
# 		output.unshift(keys[index]);
# 		num = Math.trunc(num / radix);
# 	# } while (num != 0);
# 	if (isNegative) 
# 		output.unshift('-')
# 	return output
# def toExcel num
# 	const digits = convertBases num, 26
# 	const numberDigits = digits.map(do(d) typeof d === "string" ? d.charCodeAt(0) - 65 : d )
# 	const letters = numberDigits.map(do(d) 	String.fromCharCode(d+65))
# 	const str = letters.join("")
def toExcel n
	#   function colName(n) {
	let ordA = 'A'.charCodeAt(0);
	let ordZ = 'Z'.charCodeAt(0);
	let len = ordZ - ordA + 1;

	let s = "";
	while n >= 0 
		s = String.fromCharCode(n % len + ordA) + s;
		n = Math.floor(n / len) - 1;
	return s;

# def computeFormula formula
# 	if formula.startsWith "="
# 		return  eval "({formula})"
# 	return formula + " (nothing)"
def evalutateFormula formula, context
	if formula.startsWith "="
		try
			let regex = /[A-Z]+[0-9]+/
			let replaced = formula.substring(1).replace(regex, do(e) evalutateFormula context[e], context)
			# log replaced
			return window.eval "({replaced})"
		catch e
			return "#ERROR {e}"
	return formula
# def isPointInsideElement element, x, y
# 	const rect = element.getBoundingClientRect()
# 	log "rect", rect
# 	log "x,y",x,y
	# return !(x < rect.left  or x > rect.right or y < rect.top or y > rect.botton)
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
	# def setup
	# 	self.name = 
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
	def dragover
		draggedCell = 
			x:x
			y:y
	def dragend
		const lowx = Math.min(cell.x, draggedCell.x)
		const highx = Math.max(cell.x, draggedCell.x)
		const lowy = Math.min(cell.y, draggedCell.y)
		const highy = Math.max(cell.y, draggedCell.y)
		for i in [lowx ... highx]
			for j in [lowy .. highy]
				map[(toExcel i) + j] = map[(toExcel x) + y] if (toExcel x) + y !== ""
		draggedCell = null
		window.localStorage.setItem("spreadsheet", JSON.stringify(map))
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
			# @dragstart.log("dragstart")
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
		cell.x = Math.max 0, cell.x - 1
		xindex = Math.max 0, xindex - 1
		mode="normal"
	def right
		cell.x = Math.max 0, cell.x + 1
		xindex = Math.max 0, xindex + 1
		mode="normal"
	def up
		cell.y = Math.max 0, cell.y - 1
		index =  Math.max 0, index - 1
		mode="normal"
	def down 
		cell.y = Math.max 0, cell.y + 1
		index =  Math.max 0, index + 1
		mode="normal"

	def render
		<self
			@hotkey("left")=(left)
			@hotkey("right")=(right)
			@hotkey("up")=(up)
		 	@hotkey("down")=(down)
		>
			<h1> "SpreadSheet"
			JSON.stringify(map)
			"xindex = " ,  xindex, " yindex = ", index
			"mode = {mode}"
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log.prevent=(handleScroll)>
				<div [h:{decimalPart(index)}px]>
				for y in [0 ... 10]
					<div.row[white-space: nowrap d:flex fld:row]>
						for x in [0 ... 20] 
							<Cell x=Math.floor(x + xindex) y=Math.floor(y + index)>  # if (x + xindex >=0) && (y + index) >=0
export default SpreadSheetHolder