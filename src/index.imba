# add preflight.css (https://tailwindcss.com/docs/preflight)
import './assets/preflight.css'

# import asset
import logo from './assets/logo.svg'

# set some global css
global css
	html,body m:0 p:0 w:100% h:100% ff:sans
	h1 fs:30px fw:600 c:gray9
	p c:gray8 fs:md

# define a web component
tag app-root
	<self[d:vflex ja:center pos:absolute inset:0]>
		<img[w:300px] src=logo>
		<h1> "imba-starter-app"
		<p> "let's go!"

# mount a component into the document.body
imba.mount <app-root>