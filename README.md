# leo Module - Data Processing and Manipulation Toolkit

The `leo` module provides a comprehensive set of utility functions for data processing and manipulation, including factor encoding, multidimensional array creation, data frame construction, list management, and pipeline operations. These tools are designed to simplify the data processing workflow, enhance code readability, and improve efficiency.

in bash, use `luarocks install leo` to install this packages.

## Table of Contents

- [Factor() - Create a Factor Object](#factor---create-a-factor-object)
- [Array() - Create a Multidimensional Array](#array---create-a-multidimensional-array)
- [Matrix() - Create a 2D Matrix](#matrix---create-a-2d-matrix)
- [DataFrame() - Create a Data Frame Object](#dataframe---create-a-data-frame-object)
- [List() - Create a List Object](#list---create-a-list-object)
- [Pipe() - Create a Pipeline Object](#pipe---create-a-pipeline-object)
- [Summary() - Compute Statistical Summary](#summary---compute-statistical-summary)
- [Which() - Find Indices of Elements Satisfying a Condition](#which---find-indices-of-elements-satisfying-a-condition)
- [Is_na() - Check for nil Elements](#is_na---check-for-nil-elements)
- [Na_omit() - Remove nil Elements](#na_omit---remove-nil-elements)
- [Narm - Compute Mean Ignoring nil Values](#narm---compute-mean-ignoring-nil-values)

---

## Core Objectives

- **Simplify Data Processing Workflow**: The `leo` module offers a wide range of functions from basic data structure creation to complex data operations, allowing developers to focus on business logic without worrying about low-level implementation details.
- **Enhance Code Readability and Efficiency**: By encapsulating common data processing tasks, the `leo` module helps write cleaner and more understandable code while optimizing performance to ensure efficient operation on large datasets.
- **Support Multiple Data Types**: Whether dealing with numbers, strings, booleans, or complex nested structures, the `leo` module is flexible enough to handle various scenarios and meet different needs.
- **Promote Modular Programming**: The design of the `leo` module encourages modular programming, making the code more structured, easier to extend, and reusable.

---

## Key Features

- **Factor Encoding (Factor)**
  The `Factor()` function encodes categorical data into integer values, creating a factor object. This object retains the original category information while providing an encoded numerical representation, which is useful for statistical analysis and other data processing tasks. This feature is particularly important in fields like machine learning and data analysis.

- **Multidimensional Array Creation (Array and Matrix)**
  The `Array()` and `Matrix()` functions create multidimensional arrays and 2D matrices, respectively, and fill them according to specified parameters. `Array()` supports the creation of 2D or 3D arrays with options for cyclic or linear filling, while `Matrix()` is specifically designed for 2D matrices and initializes each element's value. These functions are ideal for mathematical computations and image processing.

- **Data Frame Construction (DataFrame)**
  The `DataFrame()` function creates a data frame object that can store structured data and provides convenient data manipulation interfaces. Data frames support column-wise storage, allowing independent operations on each column such as filtering, sorting, and aggregation. Additionally, data frames offer formatted output functionality for easy debugging and data presentation.

- **List Management (List)**
  The `List()` function creates a list object by extracting elements from variadic arguments or a single table. List objects support dynamic addition and removal of elements, making them suitable for scenarios where the data structure needs frequent modification. Compared to ordinary Lua tables, `List()` provides richer operation methods, enhancing flexibility and usability.

- **Pipeline Operations (Pipe)**
  The `pipe()` function creates a pipeline object that allows a series of operations to be performed on data through chain calls. Pipeline operations make complex transformations more intuitive and user-friendly, reducing the complexity introduced by nested function calls. Through pipelines, developers can easily combine multiple functions to achieve efficient data processing pipelines.

- **Statistical Summary (Summary)**
  The `Summary()` function computes the minimum, first quartile, median, mean, third quartile, and maximum of a numeric array. It provides functionality similar to R's `summary()` function, helping users quickly understand the basic statistical information of their data. Statistical summaries are very useful for data analysis and visualization.

- **Conditional Search (Which)**
  The `Which()` function finds the indices of elements that satisfy a given condition. The condition can be a function or a logical array, and `Which()` returns a list of indices for elements that meet the condition. This function is commonly used for data filtering and anomaly detection.

- **Handling Missing Values (Is_na, Na_omit, Narm)**
  The `Is_na()` function checks whether each element in a numeric array is `nil` and returns a logical array indicating the status of each element. The `Na_omit()` function removes all `nil` elements from a numeric array and returns a new array. The `Narm()` function computes the average of a numeric array, ignoring `nil` elements. These functions help developers effectively handle missing data, ensuring the accuracy of subsequent analyses.

---

## Show() - Formatted Output

### Description
The `Show()` function outputs information directly to the console. It can handle values of any type and formats the output appropriately based on the type of the value. For tables, it recursively prints the contents of the table; for custom objects, it attempts to call the object's `__tostring` metamethod; for other types of values, it prints them directly.

### Parameters
- `...` (variadic arguments): Can be values of any type, including tables, custom objects, strings, numbers, etc.

### Returns
- No return value, but prints formatted output to the console.

### Example
```lua
local my_table = {
    name = "Alice",
    age = 30,
    address = {
        street = "123 Main St",
        city = "Wonderland"
    }
}

leo.Show(my_table)
```

### Output
```
[Table]
name = Alice
age = 30
address:
  street = 123 Main St
  city = Wonderland
```

---

## Factor() - Create a Factor Object

### Description
The `Factor()` function creates a factor object that encodes categorical data into integer values, facilitating statistical analysis and other data processing tasks.

### Parameters
- `data` (table): A table containing the data to be encoded. Each element represents a category.

### Returns
- A factor object with the following attributes:
  - `levels` (table): All levels (i.e., different categories) of the factor.
  - `level_map` (table): A mapping from original values to encoded integer values.
  - `encoded_data` (table): The encoded data, where each element is an integer representing the corresponding category index.

### Example
```lua
local factor = leo.Factor({"apple", "banana", "apple", "orange", "banana"})
print("Levels:", table.concat(factor.levels, ", "))
print("Encoded Data:", table.concat(factor.encoded_data, ", "))
```

### Output
```
Levels: apple, banana, orange
Encoded Data: 1, 2, 1, 3, 2
```

---

## Array() - Create a Multidimensional Array

### Description
The `Array()` function creates a multidimensional array (such as a matrix or 3D array) and fills it according to specified parameters.

### Parameters
- `dims` (table): A table containing the size of each dimension, supporting 2D or 3D arrays.
- `startValue` (number): The starting value for filling the array.
- `endValue` (number): The ending value for filling the array.
- `loop` (boolean): Indicates whether to loop back to the start value after reaching `endValue`.

### Returns
- A multidimensional array generated according to the specified dimensions and filling rules.

### Example
```lua
local array_2d_loop = leo.Array({3, 3}, 1, 5, true)
leo.Show(array_2d_loop)
```

### Output
```
[Table]
1 = 
  1 = 1
  2 = 2
  3 = 3
2 = 
  1 = 4
  2 = 5
  3 = 1
3 = 
  1 = 2
  2 = 3
  3 = 4
```

---

## Matrix() - Create a 2D Matrix

### Description
The `Matrix()` function creates a 2D matrix and initializes each element's value.

### Parameters
- `rows` (integer): The number of rows in the matrix.
- `cols` (integer): The number of columns in the matrix.
- `initValue` (any type): The initial value for each element.

### Returns
- A 2D matrix where each element is initialized to `initValue`.

### Example
```lua
local matrix = leo.Matrix(3, 3, 0)
leo.Show(matrix)
```

### Output
```
[Table]
1 = 
  1 = 0
  2 = 0
  3 = 0
2 = 
  1 = 0
  2 = 0
  3 = 0
3 = 
  1 = 0
  2 = 0
  3 = 0
```

---

## DataFrame() - Create a Data Frame Object

### Description
The `DataFrame()` function creates a data frame object that can store structured data and provides convenient data manipulation interfaces.

### Parameters
- `columns` (table): A table where keys are column names and values are column data. All columns must have the same length.

### Return Value
- A data frame object with the following attributes:
  - `numRows` (integer): The number of rows in the data frame.
  - Column Data: Each column's data is stored in a table, and invalid data are replaced with `null`.
  - `__tostring` metamethod: Used for formatting the display of the data frame content when used with the `print` function.

### Example
```lua
local df = leo.DataFrame({
    Name = {"Alice", "Bob", "Charlie"},
    Age = {25, 30, 35},
    City = {"New York", "Los Angeles", "Chicago"}
})
print(tostring(df))
```

### Output
```
DEBUG: Name    Age     City
DEBUG: Alice   25      New York
DEBUG: Bob     30      Los Angeles
DEBUG: Charlie 35      Chicago
Name    Age     City
Alice   25      New York
Bob     30      Los Angeles
Charlie 35      Chicago
```

---

## List() - Create a List Object

### Description
The `List()` function creates a list object that extracts elements from variadic arguments or a single table.

### Parameters
- `...` (variadic arguments): Can be individual values or a single table.

### Return Value
- A list object containing all the passed elements.

### Example
```lua
local list = leo.List(1, 2, 3, {4, 5, 6})
print(table.concat(list, ", "))
```

### Output
```
1, 2, 3, 4, 5, 6
```

---

## pipe() - Create a Pipeline Object

### Description
The `pipe()` function creates a pipeline object that allows a series of operations to be performed on data through chain calls.

### Parameters
- `value` (any type): The initial value.
- `...` (optional): A list of functions to execute immediately.

### Return Value
- A pipeline object that can continue adding operations by calling methods and eventually returns the processed result.

### Example
```lua
local result = leo.pipe(10)
    :call(function(x) return x + 5 end)
    :call(function(x) return x * 2 end)
    :get()
print(result)  -- Output: 30
```

### Output
```
30
```

---

## Summary() - Compute Statistical Summary

### Description
The `Summary()` function computes the minimum (Min), first quartile (1st Qu.), median (Median), mean (Mean), third quartile (3rd Qu.), and maximum (Max) of a numeric array. This function aims to provide functionality similar to R's `summary()` function, making it easy for users to quickly understand the basic statistical information of their data.

### Parameters
- `data` (numeric array): A table containing the data points to analyze. The elements in the array should be of numeric type.

### Return Value
- No return value, but prints a formatted statistical summary to the console.

### Example
```lua
local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
leo.Summary(data)
```

### Output
```
   Min. 1st Qu. Median   Mean 3rd Qu.    Max.
   1.0    3.0    5.5    5.5    8.0   10.0
```

---

## Which() - Find Indices of Elements Satisfying a Condition

### Description
The `Which()` function finds the indices of elements that satisfy a given condition. The condition can be a function or a logical array. If the condition is a function, it will iterate over each element in the array and return the indices of elements that satisfy the condition; if the condition is a logical array, it returns the indices corresponding to `true`.

### Parameters
- `condition` (expression or function): Used to determine whether each element satisfies the condition. It can be a function or a logical array.
- `data` (numeric array or logical array): The array to check.

### Return Value
- A list of indices containing the indices of elements that satisfy the condition.

### Example
```lua
local data = {1, 2, 3, 4, 5}
local indices = leo.Which(function(x) return x > 3 end, data)
print(table.concat(indices, ", "))  -- Output: 4, 5
```

### Output
```
4, 5
```

---

## Is_na() - Check for nil Elements

### Description
The `Is_na()` function checks whether each element in a numeric array is `nil` and returns a logical array indicating the status of each element.

### Parameters
- `data` (numeric array): The array to check.

### Return Value
- A logical array indicating whether each element is `nil`.

### Example
```lua
local data = {1, nil, 3, nil, 5}
local result = leo.Is_na(data)
print(table.concat(result, ", "))  -- Output: false, true, false, true, false
```

### Output
```
false, true, false, true, false
```

---

## Na_omit() - Remove nil Elements

### Description
The `Na_omit()` function removes all `nil` elements from a numeric array and returns a new array.

### Parameters
- `data` (numeric array): The array to process.

### Return Value
- A new array with all `nil` elements removed.

### Example
```lua
local data = {1, nil, 3, nil, 5}
local result = leo.Na_omit(data)
print(table.concat(result, ", "))  -- Output: 1, 3, 5
```

### Output
```
1, 3, 5
```

---

## Narm() - Compute Mean Ignoring nil Values

### Description
The `Narm()` function computes the mean of a numeric array, ignoring `nil` elements. If there are no non-`nil` numeric elements in the array, it returns `nil`.

### Parameters
- `t` (numeric array): An array that may contain `nil` values.

### Return Value
- The mean of the array (returns `nil` if there are no non-`nil` elements).

### Example
```lua
local data = {1, nil, 3, nil, 5}
local mean = leo.Narm(data)
print(mean)  -- Output: 3
```

### Output
```
3
```

---

## Compatibility with Lua 5.1 and Lua 5.4 `unpack`

To ensure that the code works correctly across different versions of Lua, the `leo` module provides compatibility support for the `unpack` function. In Lua 5.1, `unpack` is a global function, while in Lua 5.4, it has been moved to `table.unpack`. Therefore, the `leo` module ensures that `table.unpack` is available in all versions with the following code:

```lua
if not table.unpack then
    table.unpack = unpack
end
```

---

## Conclusion

The `leo` module not only offers a rich set of data processing tools but also adds several useful utility functions such as statistical summaries, conditional searches, `nil` element handling, mean calculation, and formatted output. These features enable developers to perform data analysis and debugging more efficiently. Whether you are working in data analysis, machine learning, scientific computing, or Web/game development, we hope the `leo` module brings significant convenience and performance improvements.

If you have any questions or need further assistance, please feel free to contact our development team. We look forward to your feedback and suggestions!

---

**Version**: 1.0.0  
**Author**: ZhiXi Information Team Lead - Genius Teen B  
**Date**: January 3, 2025



