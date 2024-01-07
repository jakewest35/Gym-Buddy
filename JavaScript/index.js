// This is a sample JavaScript file. This file is only referenced in the commented-out "Hello world"potion of index.html

let name = "jake";
console.log(name);

// primative types
let firstName = 'jake';
let lastName = 'west'; // string literal
let age = 25; // number literal. Includes floats, ints
let isApproved = true; // boolean literal
let notDefined = undefined; // undefined
let blank = null; // null   


// use 'const' if variable should not be reassigned. Use 'let' if variable needs to get reassigned at some point.
const interestRate = .3;
console.log(interestRate);

// creating an object
let person = {
    name: "jake",
    age: 25
}
console.log(person.name);

// dot notation
person.name = 'John';
console.log(person.name);

// bracket notation
person['name'] = 'mary';
console.log(person.name);

// creating an array. Setting console.log to print the array automatically returns all values of the array, no need to iterate through it. 
// Can be dynamically changed to add/remove different indices and types.
let selectedColors = ['red', 'blue'];
selectedColors[2] = 'green';
selectedColors[3] = 1
console.log(selectedColors);

// creating a function
function greet(name, lastName) {
    console.log("Hello " + name + " " + lastName);
}

greet("Jake");
greet("John", "smith")

// calculating a value
function square(number) {
    return number * number;
}

console.log(square(2));