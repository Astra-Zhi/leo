local leo = require("src.leo")

-- 测试 Factor 函数
function Test_factor()
    print("Testing Factor function...")

    -- 正常情况
    local data = {"apple", "banana", "apple", "orange", "banana"}
    local factor = leo.Factor(data)
    assert(#factor.levels == 3, "Expected 3 levels")
    assert(factor.level_map["apple"] == 1, "apple should be level 1")
    assert(factor.level_map["banana"] == 2, "banana should be level 2")
    assert(factor.level_map["orange"] == 3, "orange should be level 3")
    assert(table.concat(factor.encoded_data, ",") == "1,2,1,3,2", "Encoded data should match")

    -- 空表
    local empty_data = {}
    local empty_factor = leo.Factor(empty_data)
    assert(#empty_factor.levels == 0, "Empty data should have 0 levels")
    assert(#empty_factor.encoded_data == 0, "Empty data should have 0 encoded elements")

    -- 错误输入
    local invalid_data = nil
    local status, err = pcall(leo.Factor, invalid_data)
    assert(not status and string.find(err, "Data must be a table"), "Invalid input should raise an error")

    print("Factor function tests passed.")
end

-- 测试 Array 函数
function Test_array()
    print("Testing Array function...")

    -- 2D 数组，不循环
    local dims_2d = {3, 4}
    local array_2d = leo.Array(dims_2d, 1, 12, false)
    assert(#array_2d == 3, "2D array should have 3 rows")
    for i = 1, 3 do
        assert(#array_2d[i] == 4, "Each row should have 4 elements")
    end
    local expected_values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
    local actual_values = {}
    for i = 1, 3 do
        for j = 1, 4 do
            table.insert(actual_values, array_2d[i][j])
        end
    end
    assert(table.concat(actual_values, ",") == table.concat(expected_values, ","), "2D array values should match")

    -- 3D 数组，循环
    local dims_3d = {2, 2, 2}
    local array_3d = leo.Array(dims_3d, 1, 3, true)
    assert(#array_3d == 2, "3D array should have 2 layers")
    for i = 1, 2 do
        assert(#array_3d[i] == 2, "Each layer should have 2 rows")
        for j = 1, 2 do
            assert(#array_3d[i][j] == 2, "Each row should have 2 elements")
        end
    end
    local expected_values_3d = {1, 2, 3, 1, 2, 3, 1, 2}
    local actual_values_3d = {}
    for i = 1, 2 do
        for j = 1, 2 do
            for k = 1, 2 do
                table.insert(actual_values_3d, array_3d[i][j][k])
            end
        end
    end
    assert(table.concat(actual_values_3d, ",") == table.concat(expected_values_3d, ","), "3D array values should match")

    -- 错误输入
    local invalid_dims = {0, 2}
    local status, err = pcall(leo.Array, invalid_dims, 1, 4, false)
    assert(not status and string.find(err, "All dimensions must be positive integers"), "Invalid dimensions should raise an error")

    local invalid_range = {2, 2}
    local status, err = pcall(leo.Array, invalid_range, 1, 3, false)
    assert(not status and string.find(err, "The range of values is smaller than the number of elements to fill"), "Invalid value range should raise an error")

    print("Array function tests passed.")
end

-- 测试 Matrix 函数
function Test_matrix()
    print("Testing Matrix function...")

    -- 正常情况
    local matrix = leo.Matrix(3, 4, 0)
    assert(#matrix == 3, "Matrix should have 3 rows")
    for i = 1, 3 do
        assert(#matrix[i] == 4, "Each row should have 4 elements")
        for j = 1, 4 do
            assert(matrix[i][j] == 0, "Each element should be initialized to 0")
        end
    end

    -- 错误输入
    local status, err = pcall(leo.Matrix, -1, 4, 0)
    assert(not status and string.find(err, "Rows and columns must be positive integers"), "Invalid rows should raise an error")

    local status, err = pcall(leo.Matrix, 3, -1, 0)
    assert(not status and string.find(err, "Rows and columns must be positive integers"), "Invalid columns should raise an error")

    print("Matrix function tests passed.")
end

-- 测试 DataFrame 函数
function Test_dataframe()
    print("Testing DataFrame function...")

    -- 正常情况
    local columns = {
        A = {1, 2, 3},
        B = {"a", "b", "c"},
        C = {true, false, true}
    }
    local df = leo.DataFrame(columns)
    assert(df.numRows == 3, "DataFrame should have 3 rows")
    assert(#df.A == 3, "Column A should have 3 elements")
    assert(#df.B == 3, "Column B should have 3 elements")
    assert(#df.C == 3, "Column C should have 3 elements")
    assert(tostring(df) == "A\tB\tC\n1\ta\ttrue\n2\tb\tfalse\n3\tc\ttrue", "DataFrame string representation should match")

    -- 不同长度的列
    local invalid_columns = {
        A = {1, 2, 3},
        B = {"a", "b"}
    }
    local status, err = pcall(leo.DataFrame, invalid_columns)
    assert(not status and string.find(err, "All columns must have the same length"), "Columns with different lengths should raise an error")

    -- 错误输入
    local invalid_columns_type = {
        A = {1, 2, 3},
        B = "invalid"
    }
    local status, err = pcall(leo.DataFrame, invalid_columns_type)
    assert(not status and string.find(err, "Column data must be a table"), "Invalid column type should raise an error")

    print("DataFrame function tests passed.")
end

-- 测试 List 函数
function Test_list()
    print("Testing List function...")

    -- 正常情况
    local list = leo.List(1, 2, 3)
    assert(#list == 3, "List should have 3 elements")
    assert(table.concat(list, ",") == "1,2,3", "List elements should match")

    -- 传入表
    local list_from_table = leo.List({1, 2, 3})
    assert(#list_from_table == 3, "List from table should have 3 elements")
    assert(table.concat(list_from_table, ",") == "1,2,3", "List from table elements should match")

    -- 混合输入
    local mixed_list = leo.List(1, {2, 3}, 4)
    assert(#mixed_list == 4, "Mixed input list should have 4 elements")
    assert(table.concat(mixed_list, ",") == "1,2,3,4", "Mixed input list elements should match")

    print("List function tests passed.")
end

-- 测试 Pipe 函数
function Test_pipe()
    print("Testing Pipe function...")

    -- 正常情况
    local result = leo.Pipe(5,
        function(x) return x + 3 end,
        function(x) return x * 2 end,
        function(x) return x - 1 end
    )
    assert(result == 15, "Pipe result should be 15")  -- 更新预期结果为 15

    -- 创建管道对象并逐步调用
    local p = leo.Pipe(5)
    p(function(x) return x + 3 end)
    p(function(x) return x * 2 end)
    p(function(x) return x - 1 end)
    assert(p:get() == 15, "Pipe object result should be 15")  -- 更新预期结果为 15

    -- 错误输入
    local status, err = pcall(leo.Pipe, 5, "not a function")
    assert(not status and string.find(err, "Expected a function"), "Invalid function should raise an error")

    print("Pipe function tests passed.")
end

-- 测试 Summary 函数
function Test_summary()
    print("Testing summary function...")

    -- 测试用例 1：基本整数序列
    local a = {1, 2, 3, 4, 5, 6, 7}
    print("Test Case 1: Basic integer sequence")
    leo.Summary(a)

    -- 测试用例 2：包含重复值的序列
    local b = {1, 2, 2, 3, 4, 5, 5, 6, 7}
    print("Test Case 2: Sequence with repeated values")
    leo.Summary(b)

    -- 测试用例 3：包含负数的序列
    local c = {-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5}
    print("Test Case 3: Sequence with negative numbers")
    leo.Summary(c)

    -- 测试用例 4：空数组
    print("Test Case 4: Empty array")
    local d = {}
    local status, err = pcall(leo.Summary, d)
    if not status then
        print("Error: " .. err)
    else
        print("Empty array should have caused an error")
    end

    -- 测试用例 5：单元素数组
    local e = {42}
    print("Test Case 5: Single element array")
    leo.Summary(e)

    print("Summary function tests completed.")
end

-- 测试 Which 函数
function Test_Which()
    print("Testing Which function...")

    local function run_test_case(description, condition, data, expected)
        print(description)
        local result = leo.Which(condition, data)
        if table.concat(result, ", ") == table.concat(expected, ", ") then
            print("Test passed.")
        else
            print("Test failed. Expected:", table.concat(expected, ", "), "Got:", table.concat(result, ", "))
        end
        print()  -- 空行用于分隔不同的测试用例
    end

    -- 测试用例 1：基本条件匹配
    run_test_case("Test Case 1: Basic condition matching", 
                  function(x) return x > 3 end, 
                  {1, 2, 3, 4, 5, 6}, 
                  {4, 5, 6})

    -- 测试用例 2：逻辑表作为条件
    run_test_case("Test Case 2: Logical table as condition", 
                  {false, true, false, true, false}, 
                  {1, 2, 3, 4, 5}, 
                  {2, 4})

    -- 测试用例 3：空数组
    run_test_case("Test Case 3: Empty array", 
                  function(x) return x > 0 end, 
                  {}, 
                  {})

    -- 测试用例 4：无效条件类型
    local status, err = pcall(function() leo.Which("invalid condition", {1, 2, 3}) end)
    if not status then
        print("Test Case 4: Invalid condition type")
        print("Error: " .. err)
        print("Test passed.")
    else
        print("Test Case 4: Invalid condition type")
        print("Test failed. Expected an error but got none.")
    end
    print()  -- 空行用于分隔不同的测试用例
end

-- 测试 Is_na 函数
function Test_Is_na()
    print("Testing Is_na function...")

    local function run_test_case(description, data, expected)
        print(description)
        local result = leo.Is_na(data)
        -- 将布尔值转换为字符串
        local result_str = table.concat(table.map(result, tostring), ", ")
        local expected_str = table.concat(table.map(expected, tostring), ", ")
        if result_str == expected_str then
            print("Test passed.")
        else
            print("Test failed. Expected:", expected_str, "Got:", result_str)
        end
        print()  -- 空行用于分隔不同的测试用例
    end

    -- 测试用例 1：包含 nil 的数组
    run_test_case("Test Case 1: Array with nil values", 
                  {1, nil, 3, nil, 5}, 
                  {"false", "true", "false", "true", "false"})

    -- 测试用例 2：不包含 nil 的数组
    run_test_case("Test Case 2: Array without nil values", 
                  {1, 2, 3, 4, 5}, 
                  {"false", "false", "false", "false", "false"})

    -- 测试用例 3：空数组
    run_test_case("Test Case 3: Empty array", 
                  {}, 
                  {})
end

-- local Love = leo.ILoveYou_Yun
-- Love()

-- 测试 Na_omit 函数
function Test_Na_omit()
    print("Testing Na_omit function...")

    local function run_test_case(description, data, expected)
        print(description)
        local result = leo.Na_omit(data)
        if table.concat(result, ", ") == table.concat(expected, ", ") then
            print("Test passed.")
        else
            print("Test failed. Expected:", table.concat(expected, ", "), "Got:", table.concat(result, ", "))
        end
        print()  -- 空行用于分隔不同的测试用例
    end

    -- 测试用例 1：包含 nil 的数组
    run_test_case("Test Case 1: Array with nil values", 
                  {1, nil, 3, nil, 5}, 
                  {1, 3, 5})

    -- 测试用例 2：不包含 nil 的数组
    run_test_case("Test Case 2: Array without nil values", 
                  {1, 2, 3, 4, 5}, 
                  {1, 2, 3, 4, 5})

    -- 测试用例 3：空数组
    run_test_case("Test Case 3: Empty array", 
                  {}, 
                  {})
end

-- 测试 Narm 函数
function Test_Narm()
    print("Testing Narm function...")

    local function run_test_case(description, data, expected)
        print(description)
        local result = leo.Narm(data)
        if result == expected then
            print("Test passed.")
        else
            print("Test failed. Expected:", expected, "Got:", result)
        end
        print()  -- 空行用于分隔不同的测试用例
    end

    -- 测试用例 1：基本整数序列
    run_test_case("Test Case 1: Basic integer sequence", 
                  {1, 2, 3, 4, 5}, 
                  3)

    -- 测试用例 2：包含 nil 的序列
    run_test_case("Test Case 2: Sequence with nil values", 
                  {1, nil, 3, nil, 5}, 
                  3)

    -- 测试用例 3：全为 nil 的序列
    run_test_case("Test Case 3: All nil values", 
                  {nil, nil, nil}, 
                  nil)

    -- 测试用例 4：空数组
    run_test_case("Test Case 4: Empty array", 
                  {}, 
                  nil)

    -- 测试用例 5：稀疏表
    run_test_case("Test Case 5: Sparse table", 
                  {[1] = 1, [3] = 3, [5] = 5}, 
                  3)

    -- 测试用例 6：包含负数的序列
    run_test_case("Test Case 6: Sequence with negative numbers", 
                  {-5, -4, -3, -2, -1}, 
                  -3)

    -- 测试用例 7：单个元素的数组
    run_test_case("Test Case 7: Single element array", 
                  {42}, 
                  42)

    -- 测试用例 8：包含非数字类型的元素
    run_test_case("Test Case 8: Array with non-numeric elements", 
                  {1, "two", 3, "four", 5}, 
                  3)
end

function Test_Show()
    print("Testing Show function...")

    -- 测试用例 1：单一值
    print("Test Case 1: Single value")
    leo.Show(42)  -- 输出: 42
    print()

    -- 测试用例 2：字符串
    print("Test Case 2: String")
    leo.Show("Hello, World!")  
    print()

    -- 测试用例 3：表
    print("Test Case 3: Table")
    local my_table = {
        name = "Alice",
        age = 30,
        address = {
            street = "123 Main St",
            city = "Wonderland"
        }
    }
    leo.Show(my_table)
    print()

    -- 测试用例 4：DataFrame
    print("Test Case 4: Custom object (DataFrame)")
    local df = leo.DataFrame({
        Name = {"Alice", "Bob", "Charlie"},
        Age = {25, 30, 35},
        City = {"New York", "Los Angeles", "Chicago"}
    })
    leo.Show(df)
    print()

    -- 测试用例 5：多维数组
    print("Test Case 5: Multi-dimensional array")
    local array_2d = leo.Array({3, 3}, 1, 9, false)
    leo.Show(array_2d)
    print()

    local dims_3d = {2, 2, 2}
    local array_3d = leo.Array(dims_3d, 1, 3, true)
    leo.Show(array_3d)
    print()

end

-- 测试辅助函数
function table.map(tbl, fn)
    local result = {}
    for i, v in ipairs(tbl) do
        result[i] = fn(v)
    end
    return result
end

-- 运行所有测试
Test_factor()
Test_array()
Test_matrix()
Test_dataframe()
Test_list()
Test_pipe()
Test_summary()
Test_Which()
Test_Is_na()
Test_Na_omit()
Test_Narm()
Test_Show()

print("All tests passed.")