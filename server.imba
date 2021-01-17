import http from 'http'

const server = http.createServer do(req,res)
	res.end String <html>
		<head>
			<title> "Application"
		<body>
			<script type='module' src='./app/index.imba'>

imba.serve server.listen(process.env.PORT or 3000)