# define a web component
tag app-root
	<self>
		<h1[fw:700 c:purple7]> "imba-starter-app"
		<p> "get started now!"

# mount a component into the document.body
imba.mount <app-root>