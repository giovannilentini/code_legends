export function create_java_template(code_template, test_case){
    return `class Solution {\n\t${code_template}\n}`
}
export function create_python_template(code_template){
    return `class Solution(object):\n\t${code_template}\n`
}

export function create_cpp_template(code_template){
    return `class Solution {\npublic:\n\t${code_template}\n`
}

export function create_java_execution(code, test_case, function_name){
    let res = `public static void main(String[] args) { Solution solution = new Solution(); System.out.println(solution.${function_name});}`
    return code.concat(res)
}
export function create_cpp_execution(code, test_case, function_name){
    let res = `int main(int argc, char** argv) { Solution solution; System.out.println(solution.${function_name});}`
    return code.concat(res)
}