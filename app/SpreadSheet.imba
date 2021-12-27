
class State
	static instance = null
	constructor
		self.cells = {}
	def setCell cell, value
		self.cells[cell] = value
	
let state = new State!
const cellHeight= 100
const cellWidth= 100

tag Cell 
	prop x 
	prop y
	<self[display:inline-block w:{cellWidth}px h:{cellHeight}px border:1px solid black]>
		<div> x ," , ", y
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
		# log $container.scrollLeft, $container.clientWidth/2
		dy=  $container.scrollTop - $container.clientHeight/2
		dx = $container.scrollLeft -  $container.clientWidth/2
		index  = Math.max(0, index + ($container.scrollTop - center.y)/cellHeight)
		xindex = Math.max(0, xindex + ($container.scrollLeft - center.x)/cellWidth)
		center =
			x: $container.clientWidth/2 + (dx % cellHeight)
			y:  $container.clientHeight/2 + (dy % cellHeight)
		$container.scroll(center.x, center.y)
		# $container.scroll($container.clientWidth/2+ (dx % cellHeight), $container.clientHeight/2 + (dy % cellHeight))
	def render
		<self>
			<h1> "SpreadSheet"
			"xindex = " , xindex, " yindex = ", index
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log.prevent=(handleScroll)>
				<div [h:{decimalPart(index)}px]>
				for y in [0 ... 30]
					<div.row[white-space: nowrap]>
						for x in [0 ... 30] 
							# <div[display:inline-block p:10px border:3px solid black]> x, y
							# <Bruh> "hi"
							<Cell x=Math.floor(x + xindex) y=Math.floor(y + index)>
export default SpreadSheetHolder