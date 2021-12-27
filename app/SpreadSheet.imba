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
	# ranger = do(low, high) return [low ... high]
	def mount
		log "mount"
		log($container.clientHeight)
		$container.scroll(0, $container.clientHeight/2)
	def onscroll e
		# log e
		scrollY = window.scrollY
	def handlescroll i,isLow
		# i == index ? index +=1  :  index -= 1
		# log $container
		log(i, index, isLow)
		$container.scroll(0, $container.clientHeight/2)
		if isLow
			index +=1
		else
			# pass
			index -=1
	def render
		<self>
			<h1> "hi!"
			# <h1> (thingy 100, 200).toString!
			index
			<div$container.container[h:80vh w:80vw of:scroll] @scroll(window).log=(onscroll)>
				# <div.padding[mb:{index*100}px]>
				# <div.padding[mt:{index*100}px]>
				for i, idx in thingy index - 500, index+500
					<h1 @intersect.out=(handlescroll i, idx in [12,13,14,15,16, 17])> i, " and ",  idx
				# <App>
export default SpreadSheet