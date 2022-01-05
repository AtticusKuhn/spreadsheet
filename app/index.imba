import SpreadSheetHolder from "./SpreadSheet.imba"
# global css body
# 	p:10
let cell = {x:5, y:0}
let mode = "normal"
let clipboard\string|string[][] = ""
let draggedCell\{x:number,y:number}|null = null
let cellHeight= 100
let cellWidth= 100
let map = {}
extend tag element
	
	get cell
		log "cells {cell}"
		cell
	set cell n
		log "set cells {n}"
		cell = n
	get mode
		mode
	set mode m
		mode = m
	get clipboard
		clipboard
	set clipboard c
		clipboard = c
	get map
		map
	set map m
		if Object.keys(m).length !== 0
			map = m
			window.localStorage.setItem("spreadsheet", JSON.stringify(map))
	get draggedCell
		draggedCell
	set draggedCell d
		draggedCell = d
		
	
tag App
	def render
		<self>
			<SpreadSheetHolder>

imba.mount <App>