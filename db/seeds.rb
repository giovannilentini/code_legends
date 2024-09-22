# db/seeds.rb

# Define challenges for different languages
challenges = [
  {
    title: 'Repeat String N Times (Python)',
    description: 'Write a function that takes a string and an integer n, and returns the string repeated n times.',
    language: 'python3',
    difficulty: 'easy',
    code_template: <<~CODE,
      class Solution:
          def string_num_times(self, s: str, n: int) -> str:
              return ""
    CODE
    test_template: <<~TEST
      if __name__ == "__main__":
          solution = Solution()

          test_passed = 0

          # Test cases
          test_cases = [
              ("Hello", 3, "HelloHelloHello"),
              ("abc", 5, "abcabcabcabcabc"),
              ("x", 10, "xxxxxxxxxx"),
              ("", 5, ""),  # Empty string should return empty
              ("Test", 0, ""),  # Repeating 0 times should return empty
              ("Repeat", 1, "Repeat"),  # Repeating once should return the string itself
              ("123", 3, "123123123"),
              ("Hi", 4, "HiHiHiHi"),
              ("!", 6, "!!!!!!"),
              ("LongString", 2, "LongStringLongString")
          ]

          # Running tests
          for i, (s, n, expected) in enumerate(test_cases):
              result = solution.string_num_times(s, n)
              if result == expected:
                  test_passed += 1
              else:
                  if i < 3:  # For the first 3 tests, print the difference if they fail
                      print(f"Test {i+1} failed: expected '{expected}', but got '{result}'")
                  else:
                      print(f"Test {i+1} failed")

          if(test_passed == len(test_cases)):
              print("Winner")
          else:
              print(f"Tests passed: {test_passed}/{len(test_cases)}")
    TEST
  },
  {
    title: 'Repeat String N Times (Java)',
    description: 'Write a method in Java that takes a string and an integer n, and returns the string repeated n times.',
    language: 'java',
    difficulty: 'easy',
    code_template: <<~CODE,
      class Solution {
          public String stringNumTimes(String s, int n) {
              return "";
          }
      }
    CODE
    test_template: <<~TEST
      public class Progman {
          public static void main(String[] args) {
              Solution solution = new Solution();

              int testPassed = 0;

              // Test cases
              Object[][] testCases = {
                  {"Hello", 3, "HelloHelloHello"},
                  {"abc", 5, "abcabcabcabcabc"},
                  {"x", 10, "xxxxxxxxxx"},
                  {"", 5, ""},  // Empty string should return empty
                  {"Test", 0, ""},  // Repeating 0 times should return empty
                  {"Repeat", 1, "Repeat"},  // Repeating once should return the string itself
                  {"123", 3, "123123123"},
                  {"Hi", 4, "HiHiHiHi"},
                  {"!", 6, "!!!!!!"},
                  {"LongString", 2, "LongStringLongString"}
              };

              // Running tests
              for (int i = 0; i < testCases.length; i++) {
                  String s = (String) testCases[i][0];
                  int n = (Integer) testCases[i][1];
                  String expected = (String) testCases[i][2];
                  String result = solution.stringNumTimes(s, n);
                  if (result.equals(expected)) {
                      testPassed++;
                  } else {
                      if (i < 3) {  // For the first 3 tests, print the difference if they fail
                          System.out.printf("Test %d failed: expected '%s', but got '%s'%n", i+1, expected, result);
                      } else {
                          System.out.printf("Test %d failed%n", i+1);
                      }
                  }
              }

              if (testPassed == testCases.length) {
                  System.out.println("Winner");
              } else {
                  System.out.printf("Tests passed: %d/%d%n", testPassed, testCases.length);
              }
          }
      }
    TEST
  },
  {
    "title": "Repeat String N Times (JavaScript)",
    "description": "Write a method in JavaScript that takes a string and an integer n, and returns the string repeated n times.",
    "language": "javascript",
    "difficulty": "easy",
    "code_template": <<~CODE,
    class Solution {
      stringNumTimes(s, n) {
        // Implementation will go here
      }
    }
    CODE
    "test_template": <<~TEST
    const assert = require('assert');

    function runTests() {
      const solution = new Solution();
      const testCases = [
        { s: "Hello", n: 3, expected: "HelloHelloHello" },
        { s: "abc", n: 5, expected: "abcabcabcabcabc" },
        { s: "x", n: 10, expected: "xxxxxxxxxx" },
        { s: "", n: 5, expected: "" },
        { s: "Test", n: 0, expected: "" },
        { s: "Repeat", n: 1, expected: "Repeat" },
        { s: "123", n: 3, expected: "123123123" },
        { s: "Hi", n: 4, expected: "HiHiHiHi" },
        { s: "!", n: 6, expected: "!!!!!!" },
        { s: "LongString", n: 2, expected: "LongStringLongString" }
      ];

      let allPassed = true;

      testCases.forEach((testCase, index) => {
        const result = solution.stringNumTimes(testCase.s, testCase.n);
        if (result !== testCase.expected) {
          console.log(`Test ${index + 1} failed: expected '${testCase.expected}', but got '${result}'`);
          allPassed = false;
          // Optionally break if a failure is encountered.
        }
      });

      if (allPassed) {
        console.log("Winner");
      }
    }

    runTests();
    TEST
  },
  {
    title: 'Longest Common Prefix (Python)',
    description: 'Write a function to find the longest common prefix string amongst an array of strings.',
    language: 'python3',
    difficulty: 'medium',
    code_template: <<~CODE,
      class Solution:
          def longest_common_prefix(self, strs: List[str]) -> str:
              return ""
    CODE
    test_template: <<~TEST
      if __name__ == "__main__":
          solution = Solution()

          test_passed = 0

          # Test cases
          test_cases = [
              (["flower", "flow", "flight"], "fl"),
              (["dog", "racecar", "car"], ""),
              (["interspecies", "interstellar", "interstate"], "inter"),
              (["apple", "applet", "applied"], "appl"),
              ([""], "")
          ]

          # Running tests
          for i, (strs, expected) in enumerate(test_cases):
              result = solution.longest_common_prefix(strs)
              if result == expected:
                  test_passed += 1
              else:
                  if i < 3:  # For the first 3 tests, print the difference if they fail
                      print(f"Test {i+1} failed: expected '{expected}', but got '{result}'")
                  else:
                      print(f"Test {i+1} failed")

          if(test_passed == len(test_cases)):
              print("Winner")
          else:
              print(f"Tests passed: {test_passed}/{len(test_cases)}")
    TEST
  },
  {
    title: 'Longest Common Prefix (Java)',
    description: 'Write a method in Java to find the longest common prefix string amongst an array of strings.',
    language: 'java',
    difficulty: 'medium',
    code_template: <<~CODE,
      class Solution {
          public String longestCommonPrefix(String[] strs) {
              return "";
          }
      }
    CODE
    test_template: <<~TEST
      public class Progman {
          public static void main(String[] args) {
              Solution solution = new Solution();

              int testPassed = 0;

              // Test cases
              String[][] testCases = {
                  {"flower", "flow", "flight", "fl"},
                  {"dog", "racecar", "car", ""},
                  {"interspecies", "interstellar", "interstate", "inter"},
                  {"apple", "applet", "applied", "appl"},
                  {"", "", ""}
              };

              // Running tests
              for (int i = 0; i < testCases.length; i++) {
                  String[] strs = Arrays.copyOfRange(testCases[i], 0, testCases[i].length - 1);
                  String expected = testCases[i][testCases[i].length - 1];
                  String result = solution.longestCommonPrefix(strs);
                  if (result.equals(expected)) {
                      testPassed++;
                  } else {
                      if (i < 3) {  // For the first 3 tests, print the difference if they fail
                          System.out.printf("Test %d failed: expected '%s', but got '%s'%n", i+1, expected, result);
                      } else {
                          System.out.printf("Test %d failed%n", i+1);
                      }
                  }
              }

              if (testPassed == testCases.length) {
                  System.out.println("Winner");
              } else {
                  System.out.printf("Tests passed: %d/%d%n", testPassed, testCases.length);
              }
          }
      }
    TEST
  },
  {
    "title": "Longest Common Prefix (JavaScript)",
    "description": "Write a method in JavaScript to find the longest common prefix string amongst an array of strings.",
    "language": "javascript",
    "difficulty": "medium",
    "code_template": <<~CODE,
    class Solution {
      longestCommonPrefix(strs) {
        // Implementation will go here
      }
    }
    CODE
    "test_template": <<~TEST
    const assert = require('assert');

    function runTests() {
      const solution = new Solution();
      const testCases = [
        { strs: ["flower", "flow", "flight"], expected: "fl" },
        { strs: ["dog", "racecar", "car"], expected: "" },
        { strs: ["interspecies", "interstellar", "interstate"], expected: "inter" },
        { strs: ["apple", "applet", "applied"], expected: "appl" },
        { strs: ["", "", ""], expected: "" }
      ];

      let allPassed = true;

      testCases.forEach((testCase, index) => {
        const result = solution.longestCommonPrefix(testCase.strs);
        if (result !== testCase.expected) {
          console.log(`Test ${index + 1} failed: expected '${testCase.expected}', but got '${result}'`);
          allPassed = false;
        }
      });

      if (allPassed) {
        console.log("Winner");
      }
    }

    runTests();
    TEST
  }
]

# Create challenges
challenges.each do |attributes|
  Challenge.create!(attributes)
end


additional_challenges = [
  {
    title: 'Two Sum (Python)',
    description: 'Given an array of integers, return indices of the two numbers such that they add up to a specific target.',
    language: 'python3',
    difficulty: 'easy',
    code_template: <<~CODE,
      class Solution:
          def two_sum(self, nums: List[int], target: int) -> List[int]:
              return []
    CODE
    test_template: <<~TEST
      if __name__ == "__main__":
          solution = Solution()

          test_passed = 0

          # Test cases
          test_cases = [
              ([2, 7, 11, 15], 9, [0, 1]),
              ([3, 2, 4], 6, [1, 2]),
              ([3, 3], 6, [0, 1]),
              ([1, 5, 3, 7], 12, [1, 3]),
              ([1, 2, 3, 4], 7, [2, 3])
          ]

          # Running tests
          for i, (nums, target, expected) in enumerate(test_cases):
              result = solution.two_sum(nums, target)
              if result == expected:
                  test_passed += 1
              else:
                  if i < 3:  # For the first 3 tests, print the difference if they fail
                      print(f"Test {i+1} failed: expected '{expected}', but got '{result}'")
                  else:
                      print(f"Test {i+1} failed")

          if(test_passed == len(test_cases)):
              print("Winner")
          else:
              print(f"Tests passed: {test_passed}/{len(test_cases)}")
    TEST
  },
  {
    title: 'Two Sum (Java)',
    description: 'Write a method in Java to return indices of the two numbers such that they add up to a specific target.',
    language: 'java',
    difficulty: 'easy',
    code_template: <<~CODE,
      class Solution {
          public int[] twoSum(int[] nums, int target) {
              return new int[]{};
          }
      }
    CODE
    test_template: <<~TEST
      public class Progman {
          public static void main(String[] args) {
              Solution solution = new Solution();

              int testPassed = 0;

              // Test cases
              Object[][] testCases = {
                  {new int[]{2, 7, 11, 15}, 9, new int[]{0, 1}},
                  {new int[]{3, 2, 4}, 6, new int[]{1, 2}},
                  {new int[]{3, 3}, 6, new int[]{0, 1}},
                  {new int[]{1, 5, 3, 7}, 12, new int[]{1, 3}},
                  {new int[]{1, 2, 3, 4}, 7, new int[]{2, 3}}
              };

              // Running tests
              for (int i = 0; i < testCases.length; i++) {
                  int[] nums = (int[]) testCases[i][0];
                  int target = (Integer) testCases[i][1];
                  int[] expected = (int[]) testCases[i][2];
                  int[] result = solution.twoSum(nums, target);
                  if (Arrays.equals(result, expected)) {
                      testPassed++;
                  } else {
                      if (i < 3) {  // For the first 3 tests, print the difference if they fail
                          System.out.printf("Test %d failed: expected '%s', but got '%s'%n", i+1, Arrays.toString(expected), Arrays.toString(result));
                      } else {
                          System.out.printf("Test %d failed%n", i+1);
                      }
                  }
              }

              if (testPassed == testCases.length) {
                  System.out.println("Winner");
              } else {
                  System.out.printf("Tests passed: %d/%d%n", testPassed, testCases.length);
              }
          }
      }
    TEST
  },
  {
    "title": "Two Sum (JavaScript)",
    "description": "Write a method in JavaScript to return indices of the two numbers such that they add up to a specific target.",
    "language": "javascript",
    "difficulty": "easy",
    "code_template": <<~CODE,
    class Solution {
      twoSum(nums, target) {
        // Implementation will go here
      }
    }
    CODE
    "test_template": <<~TEST
    const assert = require('assert');

    function runTests() {
      const solution = new Solution();
      const testCases = [
        { nums: [2, 7, 11, 15], target: 9, expected: [0, 1] },
        { nums: [3, 2, 4], target: 6, expected: [1, 2] },
        { nums: [3, 3], target: 6, expected: [0, 1] },
        { nums: [1, 5, 3, 7], target: 12, expected: [1, 3] },
        { nums: [1, 2, 3, 4], target: 7, expected: [2, 3] }
      ];

      let allPassed = true;

      testCases.forEach((testCase, index) => {
        const result = solution.twoSum(testCase.nums, testCase.target);
        if (!arraysEqual(result, testCase.expected)) {
          console.log(`Test ${index + 1} failed: expected '${testCase.expected}', but got '${result}'`);
          allPassed = false;
        }
      });

      if (allPassed) {
        console.log("Winner");
      }
    }

    function arraysEqual(arr1, arr2) {
      if (arr1.length !== arr2.length) return false;
      for (let i = 0; i < arr1.length; i++) {
        if (arr1[i] !== arr2[i]) return false;
      }
      return true;
    }

    runTests();
    TEST
  },
  {
    title: 'Valid Parentheses (Python)',
    description: 'Given a string containing just the characters (,),{,},[,], determine if the input string is valid.',
    language: 'python3',
    difficulty: 'hard',
    code_template: <<~CODE,
      class Solution:
          def is_valid(self, s: str) -> bool:
              return True
    CODE
    test_template: <<~TEST
      if __name__ == "__main__":
          solution = Solution()

          test_passed = 0

          # Test cases
          test_cases = [
              ("()", True),
              ("()[]{}", True),
              ("(]", False),
              ("([)]", False),
              ("{[]}", True)
          ]

          # Running tests
          for i, (s, expected) in enumerate(test_cases):
              result = solution.is_valid(s)
              if result == expected:
                  test_passed += 1
              else:
                  if i < 3:  # For the first 3 tests, print the difference if they fail
                      print(f"Test {i+1} failed: expected '{expected}', but got '{result}'")
                  else:
                      print(f"Test {i+1} failed")

          if(test_passed == len(test_cases)):
              print("Winner")
          else:
              print(f"Tests passed: {test_passed}/{len(test_cases)}")
    TEST
  },
  {
    title: 'Valid Parentheses (Java)',
    description: 'Write a method in Java to determine if the input string containing just the characters (,),{,},[,], is valid.',
    language: 'java',
    difficulty: 'hard',
    code_template: <<~CODE,
       class Solution {
          public boolean isValid(String s) {
              return true;
          }
      }
    CODE
    test_template: <<~TEST
      public class Progman {
          public static void main(String[] args) {
              Solution solution = new Solution();

              int testPassed = 0;

              // Test cases
              Object[][] testCases = {
                  {"()", true},
                  {"()[]{}", true},
                  {"(]", false},
                  {"([)]", false},
                  {"{[]}", true}
              };

              // Running tests
              for (int i = 0; i < testCases.length; i++) {
                  String s = (String) testCases[i][0];
                  boolean expected = (Boolean) testCases[i][1];
                  boolean result = solution.isValid(s);
                  if (result == expected) {
                      testPassed++;
                  } else {
                      if (i < 3) {  // For the first 3 tests, print the difference if they fail
                          System.out.printf("Test %d failed: expected '%b', but got '%b'%n", i+1, expected, result);
                      } else {
                          System.out.printf("Test %d failed%n", i+1);
                      }
                  }
              }

              if (testPassed == testCases.length) {
                  System.out.println("Winner");
              } else {
                  System.out.printf("Tests passed: %d/%d%n", testPassed, testCases.length);
              }
          }
      }
    TEST
  },
  {
    "title": "Valid Parentheses (JavaScript)",
    "description": "Write a method in JavaScript to determine if the input string containing just the characters (,),{,},[,], is valid.",
    "language": "javascript",
    "difficulty": "hard",
    "code_template": <<~CODE,
    class Solution {
      isValid(s) {
        // Implementation will go here
      }
    }
    CODE
    "test_template": <<~TEST
    const assert = require('assert');

    function runTests() {
      const solution = new Solution();
      const testCases = [
        { s: "()", expected: true },
        { s: "()[]{}", expected: true },
        { s: "(]", expected: false },
        { s: "([)]", expected: false },
        { s: "{[]}", expected: true }
      ];

      let allPassed = true;

      testCases.forEach((testCase, index) => {
        const result = solution.isValid(testCase.s);
        if (result !== testCase.expected) {
          console.log(`Test ${index + 1} failed: expected '${testCase.expected}', but got '${result}'`);
          allPassed = false;
          break;  // Exit early on first failure
        }
      });

      if (allPassed) {
        console.log("Winner");
      }
    }

    runTests();
    TEST
  }
]
additional_challenges.each do |attributes|
  Challenge.create!(attributes)
end