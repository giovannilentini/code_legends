
Challenge.destroy_all
TestCase.destroy_all
CodeTemplate.destroy_all



challenge = Challenge.create!(
  title: "PrintHello",
  description: "Print Hello a number of times",
  difficulty: "Easy"
)
code_template = CodeTemplate.create!(
  python: "def print_hello(self, num: int) -> int:\n\n\t",
  java: "public static String print_hello(int num){\n\n\t}",
  cpp: "String print_hello(int num){\n\n\n\t}",
  challenge_id: challenge.id
)

challenge.update!(code_templates_id: code_template.id)

TestCase.create!(
  python: 'Solution.print_hello(2)',
  java: 'Solution.print_hello(2)',
  cpp: 'Solution::print_hello(2)',
  challenge_id: challenge.id
)