# db/seeds.rb

# Define challenges for different languages
challenges = [
  {
    title: 'Repeat String N Times',
    description: 'Write a function that takes a string and an integer n, and returns the string repeated n times.',
    language: 'python3',
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
    code_template: <<~CODE,
      public class Solution {
          public String stringNumTimes(String s, int n) {
              return "";
          }
      }
    CODE
    test_template: <<~TEST
      public class Main {
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
    title: 'Repeat String N Times (C++)',
    description: 'Write a method in C++ that takes a string and an integer n, and returns the string repeated n times.',
    language: 'cpp',
    code_template: <<~CODE,
      class Solution {
      public:
          std::string stringNumTimes(const std::string& s, int n) {
              return "";
          }
      };
    CODE
    test_template: <<~TEST
      #include <iostream>
      #include <string>
      #include <vector>
      #include <cassert>

      class Solution {
      public:
          std::string stringNumTimes(const std::string& s, int n) {
              return "";
          }
      };

      int main() {
          Solution solution;
          int testPassed = 0;

          // Test cases
          std::vector<std::tuple<std::string, int, std::string>> testCases = {
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
          for (size_t i = 0; i < testCases.size(); ++i) {
              auto [s, n, expected] = testCases[i];
              std::string result = solution.stringNumTimes(s, n);
              if (result == expected) {
                  ++testPassed;
              } else {
                  if (i < 3) {  // For the first 3 tests, print the difference if they fail
                      std::cout << "Test " << i+1 << " failed: expected '" << expected << "', but got '" << result << "'\n";
                  } else {
                      std::cout << "Test " << i+1 << " failed\n";
                  }
              }
          }

          if (testPassed == testCases.size()) {
              std::cout << "Winner\n";
          } else {
              std::cout << "Tests passed: " << testPassed << "/" << testCases.size() << "\n";
          }

          return 0;
      }
    TEST
  },
  {
    title: 'Longest Common Prefix',
    description: 'Write a function to find the longest common prefix string amongst an array of strings.',
    language: 'python3',
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
    code_template: <<~CODE,
      public class Solution {
          public String longestCommonPrefix(String[] strs) {
              return "";
          }
      }
    CODE
    test_template: <<~TEST
      public class Main {
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
    title: 'Longest Common Prefix (C++)',
    description: 'Write a method in C++ to find the longest common prefix string amongst an array of strings.',
    language: 'cpp',
    code_template: <<~CODE,
      class Solution {
      public:
          std::string longestCommonPrefix(const std::vector<std::string>& strs) {
              return "";
          }
      };
    CODE
    test_template: <<~TEST
      #include <iostream>
      #include <string>
      #include <vector>
      #include <cassert>

      class Solution {
      public:
          std::string longestCommonPrefix(const std::vector<std::string>& strs) {
              return "";
          }
      };

      int main() {
          Solution solution;
          int testPassed = 0;

          // Test cases
          std::vector<std::tuple<std::vector<std::string>, std::string>> testCases = {
              {{"flower", "flow", "flight"}, "fl"},
              {{"dog", "racecar", "car"}, ""},
              {{"interspecies", "interstellar", "interstate"}, "inter"},
              {{"apple", "applet", "applied"}, "appl"},
              {{"", "", ""}, ""}
          };

          // Running tests
          for (size_t i = 0; i < testCases.size(); ++i) {
              auto [strs, expected] = testCases[i];
              std::string result = solution.longestCommonPrefix(strs);
              if (result == expected) {
                  ++testPassed;
              } else {
                  if (i < 3) {  // For the first 3 tests, print the difference if they fail
                      std::cout << "Test " << i+1 << " failed: expected '" << expected << "', but got '" << result << "'\n";
                  } else {
                      std::cout << "Test " << i+1 << " failed\n";
                  }
              }
          }

          if (testPassed == testCases.size()) {
              std::cout << "Winner\n";
          } else {
              std::cout << "Tests passed: " << testPassed << "/" << testCases.size() << "\n";
          }

          return 0;
      }
    TEST
  }
]

# Create challenges
challenges.each do |attributes|
  Challenge.create!(attributes)
end
