# add preflight.css (https://tailwindcss.com/docs/preflight)
import './preflight.css'

# set some global css
global css
	html,body m:0 p:0 w:100% h:100% ff:sans

# define a web component
tag app-root
	<self>
		<h1[fw:700 c:purple7]> "imba-starter-app"
		<p> "get started now!"

# mount a component into the document.body
imba.mount <app-root>