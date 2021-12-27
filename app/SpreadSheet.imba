# const todos = []
# for count in [0 ... 1000]
# 	let text = 'I have so many things to do!'
# 	todos.push { text, count }

tag App
	show-items = 300

	def render
		<self>
			<div>
				for item, i in todos when i < show-items
					<h1> "render" 
				<div[h:10px] @intersect.in=(show-items += 0)>
# ---
export class State

	einstance = null

	prop spreasheet

	def instance
		einstance ||= self.new
	
	def initialize
		spreasheet = {}

tag Cell 
	prop x 
	prop y
	<self[display:inline-block p:10px border:3px solid black]>
		<div> x ," , ", y
tag SpreadSheetHolder
	scrollY = 0
	index = 0
	xindex = 0
	def mount
		$container.scroll(0,0)
	def onscroll e
		log $container.scrollLeft, $container.clientWidth/2
		index  = Math.max(0, index+ ( $container.scrollTop - $container.clientHeight/2 ))
		xindex =Math.max(0, xindex+( $container.scrollLeft - $container.clientWidth/2 ))
		$container.scroll($container.clientWidth/2, $container.clientHeight/2)
	def render
		<self>
			<h1> "SpreadSheet"
			"xindex = " , xindex, " yindex = ", index
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log=(onscroll)>
				for y in [0 ... 30]
					<div.row[white-space: nowrap]>
						for x in [0 ... 30] 
							# <div[display:inline-block p:10px border:3px solid black]> x, y
							# <Bruh> "hi"
							<Cell x=Math.floor(x + xindex) y=Math.floor(y + index)>
export default SpreadSheetHolder