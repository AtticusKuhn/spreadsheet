import {toExcel} from "./utils.imba"
# let cell = {x:5, y:0}
# let mode = "normal"
# let clipboard\string|string[][] = ""
# let draggedCell\{x:number,y:number}|null = null
# let cellHeight= 100
# let cellWidth= 100
# # cell = {
# # 	x: 0
# # 	y: 0 
# # }
# let map = {}
export tag GlobalState
	cell\{x:number, y:number} = {x:0, y:0}
	map\Record<string, string> = {}
	cellHeight= 100
	cellWidth= 100
	def dragstart x\number,y\number
		log "dragstart"
		mode = "select"
		cell = 
			x:x
			y:y
	def dragover x\number,y\number
		log "draover"
		draggedCell = 
			x:x
			y:y
		log draggedCell
	def dragend x,y
		log "dragend"
		mode = "normal" 
		if draggedCell
			const lowx = Math.min(cell.x, draggedCell.x)
			const highx = Math.max(cell.x, draggedCell.x)
			const lowy = Math.min(cell.y, draggedCell.y)
			const highy = Math.max(cell.y, draggedCell.y)
			for i in [lowx ... highx]
				for j in [lowy .. highy]
					map[(toExcel i) + j] = map[(toExcel x) + y] if (toExcel x) + y !== ""
		draggedCell = null
		window.localStorage.setItem("spreadsheet", JSON.stringify(map))

	
export default GlobalState