#!/bin/bash

add_country_flag=false

# 解析命令行参数 --add-country
for arg in "$@"; do
    case $arg in
        --add-country)
            add_country_flag=true
            shift
            ;;
    esac
done

# 检查是否提供了国家代码参数
if [ $# -eq 0 ]; then
    echo "错误：请提供至少一个国家代码作为参数，例如：US CN JP"
    exit 1
fi

# 遍历每个国家代码
for country in "$@"; do

    # 在10-20之间取一个随机数字
    random_number=$((RANDOM % 11 + 10))
    
    # 输出正在处理的国家代码
    echo "正在处理国家代码：$country"
    
    # 发送 GET 请求获取数据
    response=$(curl -s "https://bestip.06151953.xyz/country/${country}")

    # 转换数据格式
    formatted_data=$(echo "$response" | jq -r '.[] | "\(.ip):\(.port)"' | tr '\n' ',')

    # 去除最后一个逗号
    formatted_data=${formatted_data%,}

    # 使用 sed 将逗号替换为回车符
    final_data=$(echo "$formatted_data" | sed 's/,/\n/g')

    # 根据标志决定是否添加 #country
    if $add_country_flag; then
        final_data=$(echo "$final_data" | sed "s/$/#$country/")
    fi

    # 生成文件名
    filename="bestip$(echo "$country" | tr '[:upper:]' '[:lower:]').txt"

    # 输出最终结果
    echo "$final_data" > "$filename"

    # 休眠指定的随机秒数
    sleep $random_number
done