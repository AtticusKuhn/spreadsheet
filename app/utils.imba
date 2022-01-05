export def toExcel n
	let ordA = 'A'.charCodeAt(0);
	let ordZ = 'Z'.charCodeAt(0);
	let len = ordZ - ordA + 1;

	let s = "";
	while n >= 0 
		s = String.fromCharCode(n % len + ordA) + s;
		n = Math.floor(n / len) - 1;
	return s;
export def decimalPart n
	n - Math.floor(n)
export def evalutateFormula formula, context
	if formula.startsWith "="
		try
			let regex = /[A-Z]+[0-9]+/
			let replaced = formula.substring(1).replace(regex, do(e) JSON.stringify(evalutateFormula context[e], context))
			# log replaced
			return window.eval "({replaced})"
		catch e
			return "#ERROR"
	return formula

export def isPointInsideElement event, element
	const rect = element.getBoundingClientRect();
	const x = event.clientX;
	return false if (x < rect.left || x >= rect.right) 
	const y = event.clientY;
	return false if (y < rect.top || y >= rect.bottom) 
	return true;
export const  isBetween =  do(x, low, high) x >= low && x <= high
export const log = console.log
