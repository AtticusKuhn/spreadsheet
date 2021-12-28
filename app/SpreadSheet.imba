
class State
	static instance = null
	constructor
		self.cells = {}
	def setCell cell, value
		self.cells[cell] = value if value != ""
const log = console.log
let state = new State!
const cellHeight= 100
const cellWidth= 100
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
def convertBases num, radix=10
	let keys = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
	#   if (!(radix >= 2 && radix <= keys.length)) throw new RangeError("toBase() radix argument must be between 2 and " + keys.length)
	let isNegative=false
	if (num < 0) 
		isNegative = true
	# if (isNaN(num = Math.abs(+num))) return NaN

	let output = [];
	while num !=0
		let index = num % radix;
		output.unshift(keys[index]);
		num = Math.trunc(num / radix);
	# } while (num != 0);
	if (isNegative) 
		output.unshift('-')
	return output
def toExcel num
	const digits = convertBases num, 26
	const numberDigits = digits.map(do(d) typeof d === "string" ? d.charCodeAt(0) - 65 : d )
	const letters = numberDigits.map(do(d) 	String.fromCharCode(d+65))
	const str = letters.join("")

window.toExcel = toExcel

tag Cell 
	prop x 
	prop y
	# def setup
	# 	self.name = 
	def render
		<self[display:inline-block w:{cellWidth}px h:{cellHeight}px border:1px solid black]>
			<div> (toExcel x) + y
			<input$input type='text' onchange=(state.setCell((toExcel x) + y, $input.value)) value=(state.cells[(toExcel x) + y] || "")>
def decimalPart n
	n - Math.floor(n)
tag SpreadSheetHolder
	scrollY = 0
	index = 0
	xindex = 0
	def mount
		center = 
			x: $container.clientWidth/2,
			y: $container.clientHeight/2 
		$container.scroll(0,0)
		log state
	def handleScroll 
		log center
		dy=  $container.scrollTop - $container.clientHeight/2
		dx = $container.scrollLeft -  $container.clientWidth/2
		index  = Math.max(0, index + ($container.scrollTop - center.y)/cellHeight)
		xindex = Math.max(0, xindex + ($container.scrollLeft - center.x)/cellWidth)
		center =
			x: $container.clientWidth/2 + (dx % cellHeight)
			y:  $container.clientHeight/2 + (dy % cellHeight)
		$container.scroll(center.x, center.y)
	def render
		<self>
			<h1> "SpreadSheet"
			JSON.stringify(state.cells)
			"xindex = " ,  xindex, " yindex = ", index
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log.prevent=(handleScroll)>
				<div [h:{decimalPart(index)}px]>
				for y in [0 ... 10]
					<div.row[white-space: nowrap]>
						for x in [0 ... 20] 
							<Cell x=Math.floor(x + xindex) y=Math.floor(y + index)>
export default SpreadSheetHolder