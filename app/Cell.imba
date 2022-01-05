import GlobalState from "./globalState.imba"
import {toExcel, isBetween, evalutateFormula, isPointInsideElement, decimalPart} from "./utils.imba"




tag Cell < GlobalState
	prop x 
	prop y
	def handlechange
		map[(toExcel x) + y] = $input.value if !($input.value == "" && !map[(toExcel x) + y])
		window.localStorage.setItem("spreadsheet", JSON.stringify(map))
	# autorender=1fps
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
			@dragend=(dragend x,y)
			# @dragenter.log("dragenter")
			# @dragleave.log("dragleave")
			@dragover=(dragover x,y )
			@dragstart=(dragstart x,  y)
			# @drop=(drop")
		draggable
		>
			<div> name
			<div>
				<input$input .mousetrap [w:{cellWidth}px display:inline-block] type='text' readonly=(mode==="normal") @change=(handlechange) value=(map[name] || "")>
			<div> evalutateFormula((map[name] || ""), map)
			JSON.stringify(cell)

export default Cell