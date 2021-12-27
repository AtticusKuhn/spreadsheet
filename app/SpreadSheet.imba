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
def thingy low, high
	let a = []
	a.push(high)
	while a[0] > low
		b = a[0] - 1
		a.unshift b
	return a
tag SpreadSheet
	scrollY = 0
	index = 0
	xindex = 0
	# ranger = do(low, high) return [low ... high]
	def mount
		# log "mount"
		# log($container.clientHeight)
		$container.scroll(0,0)

		# $container.scroll($container.clientWidth/2, $container.clientHeight/2)
	def onscroll e
		# log e
		index  = Math.max(0, index+ ( $container.scrollTop - $container.clientHeight/2 ))
		xindex =Math.max(0, index+( $container.scrollLeft - $container.clientWidth/2 ))
		$container.scroll($container.clientWidth/2, $container.clientHeight/2)
	def render
		<self>
			<h1> "hi!"
			"xindex = " , xindex, " yindex = ", index
			<div$container.container[h:100vh w:100vw of:scroll] @scroll(window).log=(onscroll)>
				for y in [0 ... 100]
					<div.row[  white-space: nowrap]>
						for x in [0 ... 15] 
							<div[display:inline-block p:10px border:3px solid black]> ("x = ", Math.floor(x + xindex), " y = ",   Math.floor(y + index))
export default SpreadSheet