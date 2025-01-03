local leo = {}

-----------------------------------------------------------------------------------
-- 模块: Factor() 数据处理工具

--- 创建一个因子对象，用于编码分类数据。
-- @param data 表，包含要编码的数据
-- @return 因子对象，包含编码后的数据和水平（levels）
function leo.Factor(data)
    if not data or type(data) ~= "table" then
        error("Data must be a table.")
    end

    local factor = {
        levels = {},
        level_map = {}
    }

    -- 确定因子的水平
    for _, value in pairs(data) do
        if not factor.level_map[value] then
            table.insert(factor.levels, value)
            factor.level_map[value] = #factor.levels
        end
    end

    -- 为因子添加编码后的数据
    factor.encoded_data = {}
    for _, value in pairs(data) do
        table.insert(factor.encoded_data, factor.level_map[value])
    end

    return factor
end

--- 模块： Array()函数
-- @param dims 表，包含每个维度的大小（2D或3D）
-- @param startValue 数值，填充数组的起始值
-- @param endValue 数值，填充数组的结束值
-- @param loop 布尔值，指示是否循环回开始值
-- @return 多维数组

function leo.Array(dims, startValue, endValue, loop)
    -- 参数校验
    if not (dims and type(dims) == "table" and #dims >= 2 and #dims <= 3) then
        error("Dimensions must be a table with 2 or 3 positive integer elements")
    end
 
    for i = 1, #dims do
        if type(dims[i]) ~= "number" or dims[i] <= 0 then
            error("All dimensions must be positive integers")
        end
    end
 
    if startValue > endValue then
        error("Start value cannot be greater than end value")
    end
 
    local totalElements = 1
    for _, v in ipairs(dims) do
        totalElements = totalElements * v
    end
 
    local valueRange = endValue - startValue + 1
    if valueRange < totalElements and not loop then
        error("The range of values is smaller than the number of elements to fill, and loop is disabled.")
    end
 
    -- 全局计数器
    local counter = startValue - 1

    -- 递归填充函数
    local function fillArray(index, arr)
        if index > #dims then
            return
        end
 
        local currentDim = dims[index]
        for i = 1, currentDim do
            if index == #dims then
                -- 最内层，填充值
                counter = counter + 1
                if not loop and counter > endValue then
                    error("Exceeded the end value without looping")
                elseif loop then
                    counter = (counter - startValue) % valueRange + startValue
                end
                table.insert(arr, counter)
            else
                -- 创建下一层
                local newArray = {}
                table.insert(arr, newArray)
                fillArray(index + 1, newArray)
            end
        end
    end

    -- 爱你小猫

    local array = {}
    fillArray(1, array)
 
    -- 确保返回多维数组
    return array
end


--- 模块：Matrix()函数
-- @param rows 整数，矩阵的行数
-- @param cols 整数，矩阵的列数
-- @param initValue 任意类型，初始化每个元素的值
-- @return 二维矩阵
function leo.Matrix(rows, cols, initValue)
    if type(rows) ~= "number" or rows <= 0 or type(cols) ~= "number" or cols <= 0 then
        error("Rows and columns must be positive integers.")
    end

    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = initValue
        end
    end
    return matrix
end

-----------------------------------------------------------------------------------
-- 模块: 数据框工具

--- 创建一个数据框对象。
-- @param columns 表，键是列名，值是列数据
-- @return 数据框对象
function leo.DataFrame(columns)
    local dataFrame = {}
    local null = nil  -- 定义null为nil，如果你有特定的null定义可以替换

    -- 自定义有效性检查函数
    local function is_valid(value, validTypes)
        validTypes = validTypes or {"number", "string", "boolean"}
        for _, t in ipairs(validTypes) do
            if t == type(value) then
                return true
            end
        end
        return false
    end
    
    -- 初始化数据框，columns是一个表，其中键是列名，值是列数据
    local expectedLength = nil
    for columnName, columnData in pairs(columns) do
        -- 确保columnData是一个表
        if type(columnData) ~= "table" then
            error("Column data must be a table for column '" .. tostring(columnName) .. "'.")
        end

        -- 检查所有列长度一致
        local columnLength = #columnData
        if expectedLength == nil then
            -- 如果是第一列，初始化行数
            expectedLength = columnLength
            dataFrame.numRows = columnLength
        elseif columnLength ~= expectedLength then
            error("All columns must have the same length. Column '" .. tostring(columnName) .. "' has length " .. columnLength .. ", but expected " .. expectedLength .. ".")
        end

        -- 验证并填充无效数据
        dataFrame[columnName] = columnData  -- 直接使用原始数据
        for i = 1, expectedLength do
            if columnData[i] == nil or not is_valid(columnData[i]) then
                columnData[i] = null  -- 将无效值替换为null
            end
        end
    end

    -- 存储行数，方便后续使用
    dataFrame.numRows = dataFrame.numRows or 0

    -- 定义__tostring元方法，用于print函数输出
    setmetatable(dataFrame, {
        __tostring = function(self)
            local result = {}

            -- 收集列名
            local columnNames = {}
            for columnName in pairs(self) do
                if type(columnName) == "string" and columnName ~= "numRows" then
                    table.insert(columnNames, columnName)
                end
            end

            -- 按列名排序（可选）
            table.sort(columnNames)

            -- 构建表头
            table.insert(result, table.concat(columnNames, "\t"))

            -- 构建每一行
            for row = 1, self.numRows do
                local rowData = {}
                for _, name in ipairs(columnNames) do
                    -- 使用tostring转换值，对于nil显示为"null"
                    local value = self[name][row]
                    table.insert(rowData, value == null and "null" or tostring(value))
                end
                table.insert(result, table.concat(rowData, "\t"))
            end

            -- 调试输出
            for _, line in ipairs(result) do
                print("DEBUG: " .. line)
            end

            return table.concat(result, "\n")
        end
    })

    return dataFrame
end


function leo.ILoveYou_Yun()
    local poems = {
        [[
        生命因为付诸于爱而更为丰盛，
        在你眼中我找到了我的世界。
        你的爱像晨曦的光辉，
        照亮了我心中每一个角落。
        ]],
        [[
        我的心在等待，等待着你，
        等待着你那温柔的目光。
        当你终于出现在我面前，
        我的世界因你而完整。
        ]],
        [[
        让我们把生命中的每一天，
        都当作是永恒的纪念。
        因为有你在，时光不再虚度，
        每一刻都充满了意义。
        ]]
    }
    math.randomseed(os.time())
    local random_index = math.random(#poems)
    print(poems[random_index])
end

-----------------------------------------------------------------------------------
-- 模块: 列表工具

--- 创建一个列表对象。
-- @param ... 变长参数，可以是单个值或一个表
-- @return 列表对象
function leo.List(...)
    local list = {}
    local args = {...}
    for _, arg in ipairs(args) do
        if type(arg) == "table" then
            for _, value in ipairs(arg) do
                table.insert(list, value)
            end
        else
            table.insert(list, arg)
        end
    end
    return list
end

-----------------------------------------------------------------------------------
-- 模块: 管道操作符工具

--- 创建一个管道对象。
-- @param value 初始值
-- @param ... 可选的函数列表，立即执行这些函数
-- @return 管道对象或最终结果
function leo.Pipe(value, ...)
    local funcs = {...}

    -- 创建管道对象
    local p = setmetatable({value = value}, {
        __call = function(self, func, ...)
            -- 检查func是否为函数
            if type(func) ~= "function" then
                error("Expected a function, got " .. type(func))
            end

            -- 将当前值作为第一个参数传递给func，并更新self.value
            self.value = func(self.value, ...)
            return self  -- 返回管道对象，以便链式调用
        end,
        __tostring = function(self)
            return tostring(self.value)
        end,
        -- 添加一个方法来获取当前值
        __index = {
            get = function(self)
                return self.value
            end
        }
    })

    -- 如果有额外的函数传入，则执行管道操作
    if #funcs > 0 then
        for _, func in ipairs(funcs) do
            p(func)  -- 直接调用 p 以触发 __call metamethod
        end
        return p:get()  -- 返回最终结果
    end

    -- 如果没有额外的函数传入，返回管道对象
    return p
end

-----------------------------------------------------------------------------------
-- 模块: Summary()函数模块

--- 计算一个数值数组的最小值（Min）、第一四分位数（1st Qu.）、中位数（Median）、平均值（Mean）、第三四分位数（3rd Qu.）和最大值（Max）
-- @param data 数值数组，包含要分析的数据点
-- @return 无返回值，但在控制台打印出统计摘要

function leo.Summary(data)
    if not data or #data == 0 then
        error("Input data is empty or nil")
    end

    -- 创建数据的排序副本
    local sorted_data = {}
    for i, v in ipairs(data) do
        table.insert(sorted_data, v)
    end
    table.sort(sorted_data)

    -- 计算统计数据
    local n = #sorted_data
    local min_val = sorted_data[1]
    local max_val = sorted_data[n]
    local sum = 0
    for _, v in ipairs(data) do
        sum = sum + v
    end
    local mean_val = sum / n

    -- 定义计算四分位数的辅助函数
    local function quartile(q)
        if n == 1 then
            return sorted_data[1]  -- 特殊处理单元素数组
        end

        local pos = q * (n + 1)
        local lower = math.floor(pos)
        local upper = math.ceil(pos)
        if lower == upper then
            return sorted_data[lower]
        else
            return sorted_data[lower] + (pos - lower) * (sorted_data[upper] or sorted_data[lower] - sorted_data[lower])
        end
    end

    local median_val = quartile(0.5)
    local first_quartile = quartile(0.25)
    local third_quartile = quartile(0.75)
    
    -- 打印统计摘要，格式类似于 R 的 output
    print(string.format("%7s %7s %7s %7s %7s %7s", "Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max."))
    print(string.format("%7.1f %7.1f %7.1f %7.1f %7.1f %7.1f", 
                        min_val, first_quartile, median_val, mean_val, third_quartile, max_val))
end

-----------------------------------------------------------------------------------
-- 模块: Which()函数模块
-- @param condition 表达式或函数，用于判断每个元素是否满足条件
-- @param data 数值数组或逻辑数组
-- @return 索引列表，包含满足条件的元素的索引
function leo.Which(condition, data)
    local indices = {}
    if type(condition) == "function" then
        for i, v in ipairs(data) do
            if condition(v) then
                table.insert(indices, i)
            end
        end
    elseif type(condition) == "table" then
        for i, v in ipairs(condition) do
            if v then
                table.insert(indices, i)
            end
        end
    else
        error("Condition must be a function or a logical table")
    end
    return indices
end

-----------------------------------------------------------------------------------
-- 模块: Is_na()函数模块
-- @param data 数值数组
-- @return 逻辑数组，指示每个元素是否为 nil
function leo.Is_na(data)
    local result = {}
    for i, v in ipairs(data) do
        table.insert(result, v == nil)
    end
    return result
end

-----------------------------------------------------------------------------------
-- 模块: Na_omit()函数模块
-- @param data 数值数组
-- @return 新的数组，移除了所有 nil 元素
function leo.Na_omit(data)
    local result = {}
    for _, v in pairs(data) do
        if v ~= nil then
            table.insert(result, v)
        end
    end
    return result
end

-----------------------------------------------------------------------------------
-- 模块: Narm
-- @param t 数值数组，可能包含 nil 值
-- @return 平均值（如果数组中没有非 nil 元素，则返回 nil）

function leo.Narm(t)
    -- 如果输入表为空或为 nil，直接返回 nil
    if not t or #t == 0 then
        return nil
    end

    local sum = 0
    local count = 0

    
    -- 遍历表中的每个元素，使用 pairs 而不是 ipairs 以支持稀疏表
    for _, value in pairs(t) do
        -- 如果元素是数字，则累加到 sum，并增加 count
        if type(value) == "number" then
            sum = sum + value
            count = count + 1
        end
    end

    -- 如果 count 为 0，表示没有非 nil 的数字元素，返回 nil
    if count == 0 then
        return nil
    end

    -- 返回平均值
    return sum / count
end

-----------------------------------------------------------------------------------
-- 模块: 输出工具

--- 用于直接输出信息的函数 Show
-- @param ... 变长参数，可以是任意类型的值
-- @return 无返回值，但在控制台打印出格式化的输出
function leo.Show(...)
    local function print_table(tbl, indent)
        indent = indent or 0
        local indent_str = string.rep("  ", indent)  -- 创建缩进字符串

        for key, value in pairs(tbl) do
            if type(value) == "table" then
                -- 如果是表，递归打印
                print(indent_str .. tostring(key) .. ":")
                print_table(value, indent + 1)
            else
                -- 否则，直接打印键值对
                print(indent_str .. tostring(key) .. " = " .. tostring(value))
            end
        end
    end

    -- 遍历所有传入的参数
    for i, arg in ipairs({...}) do
        if type(arg) == "table" then
            -- 如果是表，使用 print_table 函数递归打印
            print("[Table]")
            print_table(arg)
        elseif type(arg) == "userdata" or getmetatable(arg) then
            -- 如果是自定义对象，尝试调用 __tostring 元方法
            local mt = getmetatable(arg)
            if mt and mt.__tostring then
                print(tostring(arg))
            else
                print("[Userdata or custom object without __tostring]")
            end
        else
            -- 否则，直接打印值
            print(tostring(arg))
        end
    end
end


---------------------------------------------------------------------------------
-- 兼容Lua 5.1和Lua 5.4的unpack
if not table.unpack then
    table.unpack = unpack
end

return leo