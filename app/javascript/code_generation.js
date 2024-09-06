function create_java_template(code_template){
    return `class Solution {\n\t${code_template}\n}\n`
}
 function create_python_template(code_template){
    return `class Solution(object):\n\t${code_template}\n}\n`
}

function create_cpp_template(code_template){
    return `class Solution {\npublic:\n\t${code_template}\n}\n`
}

function create_java_execution(code, test){
    let res = `\npublic class Progman{public static void main(String[] args) { ${test} }}`
    return res.concat(code)
}
function create_cpp_execution(code, test){
    let res = `\nint main(int argc, char** argv) { ${test} return 0;}`
    return code.concat(res)
}
function create_python_execution(code, test){
    let res = `\nif __name__ == "__main__":\n\t${test}`
    return code.concat(res)
}

export function create_template(language, code){
    switch (language){
        case "python3":
            return create_python_template(code)
        case "java":
            return create_java_template(code)
        case "cpp":
            return create_cpp_template(code)
    }
}
export function create_executable(language, code, test){
    switch (language){
        case "python3":
            return create_python_execution(code, test)
        case "java":
            return create_java_execution(code, test)
        case "cpp":
            return create_cpp_execution(code, test)
    }
}


