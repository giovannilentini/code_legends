function create_java_execution(code, test){
    return code.concat(test)
}
function create_javascript_execution(code, test){
    return code.concat(test)
}
function create_python_execution(code, test){
    return code.concat("\n"+test)
}
export function create_executable(language, code, test){
    switch (language){
        case "python3":
            return create_python_execution(code, test)
        case "java":
            return create_java_execution(code, test)
        case "javascript":
            return create_javascript_execution(code, test)
    }
}


